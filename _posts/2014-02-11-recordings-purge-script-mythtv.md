---
id: 725
title: Recordings Purge Script for MythTV
date: 2014-02-11T09:28:16+09:30
author: James Young
layout: post
guid: http://blog.zencoffee.org/?p=725
permalink: /2014/02/recordings-purge-script-mythtv/
categories:
  - Technical
tags:
  - htpc
  - linux
  - mythtv
---
**Edit 25th Feb:  Discovered a bug in the logic, apparently UNION order isn't guaranteed.  Reworked the script so it does the right thing now.**

I've now converted my prior HTPC setup over to using an [HDHomeRun](http://www.silicondust.com/products/models/hdhr3-dt/) and [MythTV](http://www.mythtv.org/) on my Microserver.  The former MediaPortal box now runs exclusively [OpenElec](http://openelec.tv/) XBMC.  Anyway, MythTV has a proper database backend and a set of Python/Perl bindings, which is great for customization.

I have a pretty specific want for my recording schedules, which ARGUS (on MediaPortal) wasn't able to do, and which MythTV is not _quite_ able to do.  Namely, I want to record a certain number of a specific series, and then only record more of them if they get watched.  The oldest watched episode should be discarded to make room, so you always maintain N episodes that are unwatched, _but you don't record new episodes if you already have N episodes unwatched_.

MythTV's native "Expire old and record new" functionality does not do this (it will keep recording episodes to maintain N new episodes, overwriting older episodes even if unwatched with new ones).  The "Auto-expire" functionality won't do this (it will only delete episodes if running out of disk space).

Enter the following script.  Yes, the SQL query is freakin' huge.

<pre>#!/usr/bin/python -W ignore::DeprecationWarning
#
# Purges watched episodes from schedules so that new episodes can be
# recorded
#
# Only purges the oldest watched recording, and only if the schedule
# wouldn't record because it's reached the maximum episodes
#
# I'm terrible at Python.

from MythTV import MythDB, Recorded
import sys
import MySQLdb

db = MythDB()

cur = db.cursor()

# Fetch all candidate recording ids
cur.execute("""
SELECT
  candidates.recordid
FROM
  (
    SELECT
      record.recordid,
      record.title,
      record.maxepisodes,
      COUNT(recorded.basename) AS count
    FROM
      record,
      recorded
    WHERE
      record.autoexpire=1
      AND record.inactive=0
      AND record.maxnewest=0
      AND record.recordid = recorded.recordid
      AND NOT recorded.recgroup = 'LiveTV'
      AND NOT recorded.recgroup = 'Deleted'
      AND recorded.preserve = 0
      AND recorded.autoexpire = 1
    GROUP BY
      recorded.recordid
  ) AS candidates
WHERE
  candidates.maxepisodes &lt;= candidates.count
""")

for record in cur.fetchall() :
        cur2 = db.cursor();
        cur2.execute("""
                SELECT
                  e.title,
                  e.subtitle,
                  e.basename,
                  e.starttime,
                  e.deletepriority
                FROM
                (
                  (
                  -- Subselect fully watched episodes
                  SELECT
                    b.title,
                    b.subtitle,
                    b.basename,
                    b.starttime,
                    1 AS deletepriority
                  FROM
                    recorded AS b
                  WHERE
                    b.recordid = ?
                    AND b.preserve=0
                    AND b.autoexpire=1
                    AND b.watched=1
                    AND NOT b.recgroup = 'LiveTV'
                    AND NOT b.recgroup = 'Deleted'
                  -- End of watched episodes
                  ) UNION (
                  -- Subselect bookmarked episodes
                  SELECT
                    c.title,
                    c.subtitle,
                    c.basename,
                    c.starttime,
                    2 AS deletepriority
                  FROM
                    recorded as c,
                    recordedmarkup as d
                  WHERE
                    c.recordid = ?
                    AND c.preserve=0
                    AND c.autoexpire=1
                    AND c.watched=0
                    AND NOT c.recgroup = 'LiveTV'
                    AND NOT c.recgroup = 'Deleted'
                    AND d.chanid = c.chanid
                    AND d.starttime = c.starttime
                    AND d.type = 2
                  -- End of bookmarked episodes
                  )
                ) AS e
                ORDER BY
                  e.deletepriority,
                  e.starttime
                LIMIT 1
        """, (record[0], record[0]))
        for row in cur2.fetchall() :
                print row[0] + " : " + row[1] + " (" + row[2] + ") [" + str(row[3]) + "]"
                recs = list(db.searchRecorded(basename=row[2]))
                if len(recs) == 0:
                        print '  error - could not find episode by basename!'
                        sys.exit(0)
                for rec in recs:
                        rec.delete()</pre>

I'll break down what this does.

  * For each active autoexpirable recording schedule, see if the number of autoexpirable, nonpreserved, nondeleted recordings exceeds or matches the maximum number of allowable recordings.
  * For each of those schedules, find the oldest fully watched or bookmarked, nonpreserved, autoexpirable, nondeleted recording and delete it.

If you put this in crontab to run once a day, you'll find that each of your schedules will do what I outlined above.

The great thing about this is that it allows you to set up recording schedules for anything (where you don't care about episode order) that looks vaguely interesting, set an appropriate maximum (5 or so), and it'll only keep recording them if they're actually getting watched.

This is the functionality I want for children's television, and now I've got it.