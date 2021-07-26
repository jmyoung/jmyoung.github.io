---
title: 'Importing HomeAssistant into Splunk Metrics'
author: James Young
layout: post
categories:
  - technical
tags:
  - splunk
  - homeassistant
---

I'm a fairly keen [HomeAssistant](https://www.home-assistant.io/) user, and I also use [Splunk](https://www.splunk.com/) for log analysis and as a lab for learning about it since my work uses it.  I was pretty interested in getting Home Assistant telemetry into Splunk, and in particular into the metric indexes that Splunk can store for efficiency and longer-term graphing of data from all my sensors.

Configure a HTTP Event Collector for Splunk
===========================================

Following the [documentation](https://docs.splunk.com/Documentation/Splunk/8.2.1/Data/UsetheHTTPEventCollector), create a new HTTP Event Collector on your Splunk instance, giving it a source datatype of something like `json_no_timestamp` for now.  Have all events sent to a new index.  This index won't be doing a whole lot, but we'll use this to verify everything is working correctly.

While you're at it, create a new Metrics Index named appropriately, and add it to the indexes for your HEC.  Set the default index for your HEC to the event index you created, not the metric index.  Record the HEC token, you'll need that shortly.

Configure HomeAssistant to send metrics
=======================================

In your HA `configuration.yaml`, you will need a fragment very much like this (`splunk_api_key` refers to a secret containing the HEC token you created above).

```yaml
# Splunk integration
splunk:
  token: !secret splunk_api_key
  host: YOURSPLUNKHECDOMAINNAME
  port: 8088
  ssl: true
  verify_ssl: false
  name: "hassio"
  filter:
    include_domains:
      - sensor
    exclude_entities:
      - sensor.date
      - sensor.time
      - sensor.date_time
```

This will only include the `sensor` domain, and will specifically exclude the clock-related HA sensors, since their data is not particularly useful to you, so you shouldn't bother ingesting it.  You may also want to collect binary sensors and such, but I'm much more interested in standard analog sensors, and need to keep my daily ingest down to fit into the Splunk Free license.

Configure Splunk to Transform HA Metrics
========================================

You should immediately start seeing events land in your events index.  Notably, the format of those JSON messages is not suitable for Splunk to direct ingest as metrics, so we can't use them.  Instead, we will set up a custom transform to add the correct fields to allow that to work.

There are two JSON fields in every packet that will be useful - the domain (which in the above example will always be `sensor`), and the entity_id, which is a unique field corresponding to the entity_id in HomeAssistant.  We will merge these together to make the metric name, and take the value from the JSON `value` field as the _value.

First, edit `$SPLUNK/etc/system/local/props.conf` and add the following stanza;

```conf
[hassio_metrics]
BREAK_ONLY_BEFORE = ^{
DATETIME_CONFIG = CURRENT
MAX_TIMESTAMP_LOOKAHEAD = 800
pulldown_type = 1
TRANSFORMS-hassio-metricname = hassio_metric_name_domain,hassio_metric_name_entityid,hassio_metric_name_merge
TRANSFORMS-hassio-metricvalue = hassio_metric_value
category = Metrics
```

This defines a new sourcetype named `hassio_metrics` which will have a set of transforms applied to it to do the field extractions we need.  Don't restart Splunk yet.

Then, edit `$SPLUNK/etc/system/local/transforms.conf` and add the following stanzas;

```conf
# Extract the domain
[hassio_metric_name_domain]
REGEX = "domain": "(\S+)"
FORMAT = metric_domain::$1
WRITE_META = true

# Extract the entity_id
[hassio_metric_name_entityid]
REGEX = "entity_id": "(\S+)"
FORMAT = metric_entityid::$1
WRITE_META = true

# Merge domain, entityid into the metric name
# We only accept metric names in the 'sensor' domain
[hassio_metric_name_merge]
SOURCE_KEY = fields:metric_domain,metric_entityid
REGEX = (sensor) (\S+)
FORMAT = metric_name::$1.$2
WRITE_META = true

# Extract metric value from a standard sensor
[hassio_metric_value]
REGEX = "value": (\d+.?\d+)
FORMAT = _value::$1
WRITE_META = true
```

Now what happens here is a bit funny, so let's explain.  The `hassio_metric_name_domain` and `hassio_metric_name_entityid` transforms pull those fields out of the raw JSON (before it's indexed) and create new fields named `metric_domain` and `metric_entityid` respectively.  You have to do it here and not use `INDEXED_EXTRACTIONS=JSON` in props.conf before the indexed extractions happen _after_ your custom transforms and therefore the required fields aren't available.  It would be a lot simpler if they were, but it is what it is.

After those two fields have been generated, we then define a new transform `hassio_metric_name_merge` which uses the two fields we defined earlier concatenated together (with spaces between) as the source.  This simply regexes it to be sure the domain is actually `sensor` and then creates a new field `metric_name` with the domain and entity_id concatenated together with a `.` between them.

And lastly, `hassio_metric_value` simply pulls out the relevant field from the raw event and inserts it into the `_value` field.

Restart Splunk, and then change your HEC's source datatype to `hassio_metrics` so the transforms you defined get applied to it.  Examining your new incoming events, you should see all the newly defined fields in the events, indicating that the transform has worked.

Converting to Metrics
=====================

Assuming that the events you are getting through have a correct `metric_name` and `value` field, you can now simply edit your HEC, and change your metrics index to be the default index for the collector.  You should then start seeing metrics populating into it, which are available in the Analytics tab in Search & Reporting.  There's a good chance you'll see all sorts of funny metrics coming in you didn't expect or even know existed.

Great success!