---
id: 826
title: Cisco 7965 VOIP Phones Standalone (with Asterisk)
date: 2015-12-08T11:32:33+09:30
author: James Young
layout: post
guid: http://blog.zencoffee.org/?p=826
permalink: /2015/12/cisco-7965-voip-phones-standalone-asterisk/
categories:
  - Computers
  - Telephony
tags:
  - asterisk
  - c7965
  - voip
---
My work has a number of older [Cisco 7965](http://www.cisco.com/c/en/us/products/collaboration-endpoints/unified-ip-phone-7965g/index.html) VOIP Unified Communications phones, which are being disposed of.  I thought I'd grab one and see if I could make it work.  These phones are intended to be used with a Cisco Unified Call Manager & using Cisco's proprietary SCCP protocol.  But it's possible to re-flash them with a SIP-based firmware and configure them without UCM.

Firstly, you will need the following components;

  * A SIP server on your local network (eg, [Asterisk](http://www.asterisk.org/)).  That SIP server needs to support any of g729, u-law and/or a-law codecs.
  * A DHCP server on your local network, which you can customize DHCP options for.
  * A TFTP server that you can point your phone at.
  * The Cisco 7965 SIP Firmware Bundle.  I won't link it here, but you can find it by looking through the references at the end of this article.  The exact version I used was cmterm-7945_7965-sip.9-3-1SR4-1.zip (md5 4088c17c622a1e181b1c2b1265349df6).
  * A Cisco 7965 phone (duh) and some way to power it.

And some references.

  * [VOIP Info's page on the Standalone C7965](http://www.voip-info.org/wiki/view/Standalone+Cisco+7945/7965)
  * [Mark Holloway's Blog](http://www.markholloway.com/blog/?p=549)

Let's get started.

# Reflashing the Phone

Extract the entire firmware package (it should contain a number of .sbn and .loads files) into the root of your TFTP server.  Then, in that root, create a new XMLDefault.cnf.xml containing the following;

<pre>&lt;loadInformation8 model="Cisco 7965"&gt;SIP45.9-3-1SR4&lt;/loadInformation8&gt;</pre>

In your DHCP configuration, add option 66 and option 150 pointing to the IP address of your TFTP server.

Power up the phone, and hold down the hash (#) button until the line buttons alongside the display start blinking.  Now, enter 123456789*0# on the keypad.  The screen should flash a few times and it should then enter the updater which will reflash the firmware from your TFTP server and do a factory reset at the same time.

Once that's done, you can verify under Settings->Model Information that the Call Control Protocol is listed as SIP.

# Configuring Asterisk

I'm assuming here you are using users.conf to generate extensions into extensions.conf, and have an otherwise normal Asterisk setup.  It's critical that the extension which the phone is using has specified 'nat=no', otherwise it will simply refuse to register.  Obviously change your names, secrets and extensions to suit your setup!

Put this into users.conf;

<pre>[c7965]
fullname = My-VOIP-Phone
secret = PASSWORD
hassip=yes
host=dynamic
context = my-context
qualify = yes
alternateexts = 502
nat=no
disallow=all
allow=g729,alaw,ulaw</pre>

If your Asterisk setup doesn't support g729, remove it from the codec list.  Reload Asterisk, and you're nearly there.

# Configure Phone XML

Now the hard bit.  You need to create a SEPxxxx.cnf.xml file in the root of your TFTP server where xxxx is the UPPERCASED version of your device's MAC address.

You must get all parts of this file exactly right.  Even one tiny typo will stop the phone from reading the config.  I'll put my file here with some adjustments to protect the innocent.  Interesting parts are bolded.

In order to reboot the phone, press Settings and then (quickly) enter \*\*#\*\* .

<pre>&lt;device xsi:type="axl:XIPPhone" <strong>ctiid="1234567890"</strong>&gt;
&lt;deviceProtocol&gt;SIP&lt;/deviceProtocol&gt;
&lt;sshUserId&gt;<strong>SSHUSERHERE</strong>&lt;/sshUserId&gt;
&lt;sshPassword&gt;<strong>SSHPASSWORDHERE</strong>&lt;/sshPassword&gt;
&lt;devicePool&gt;
 &lt;dateTimeSetting&gt;
 &lt;!-- FIXME: Set your preferred date format and timezone here --&gt;
 &lt;dateTemplate&gt;<strong>D/M/Y</strong>&lt;/dateTemplate&gt;
 &lt;timeZone&gt;<strong>Cen. Australia Standard/Daylight Time</strong>&lt;/timeZone&gt;
 &lt;ntps&gt;
 &lt;!-- NTP might not actually work, but the phone can set the
 date/time from the SIP response headers --&gt;
 &lt;ntp&gt;
 &lt;name&gt;<strong>pool.ntp.org</strong>&lt;/name&gt;
 &lt;ntpMode&gt;Unicast&lt;/ntpMode&gt;
 &lt;/ntp&gt;
 &lt;/ntps&gt;
 &lt;/dateTimeSetting&gt;

 &lt;!-- This section probably does not do anything useful. --&gt;
 &lt;callManagerGroup&gt;
 &lt;members&gt;
 &lt;member priority="0"&gt;
 &lt;callManager&gt;
 &lt;ports&gt;
 &lt;ethernetPhonePort&gt;2000&lt;/ethernetPhonePort&gt;
 &lt;sipPort&gt;5060&lt;/sipPort&gt;
 &lt;securedSipPort&gt;5061&lt;/securedSipPort&gt;
 &lt;/ports&gt;
 &lt;processNodeName&gt;<strong>YOURSIPSERVERHERE</strong>&lt;/processNodeName&gt;
 &lt;/callManager&gt;
 &lt;/member&gt;
 &lt;/members&gt;
 &lt;/callManagerGroup&gt;
&lt;/devicePool&gt;
&lt;sipProfile&gt;
 &lt;sipProxies&gt;
 &lt;registerWithProxy&gt;true&lt;/registerWithProxy&gt;
 &lt;/sipProxies&gt;
 &lt;sipCallFeatures&gt;
 &lt;cnfJoinEnabled&gt;true&lt;/cnfJoinEnabled&gt;
 &lt;callForwardURI&gt;x-serviceuri-cfwdall&lt;/callForwardURI&gt;
 &lt;callPickupURI&gt;x-cisco-serviceuri-pickup&lt;/callPickupURI&gt;
 &lt;callPickupListURI&gt;x-cisco-serviceuri-opickup&lt;/callPickupListURI&gt;
 &lt;callPickupGroupURI&gt;x-cisco-serviceuri-gpickup&lt;/callPickupGroupURI&gt;
 &lt;meetMeServiceURI&gt;x-cisco-serviceuri-meetme&lt;/meetMeServiceURI&gt;
 &lt;abbreviatedDialURI&gt;x-cisco-serviceuri-abbrdial&lt;/abbreviatedDialURI&gt;
 &lt;rfc2543Hold&gt;false&lt;/rfc2543Hold&gt;
 &lt;callHoldRingback&gt;2&lt;/callHoldRingback&gt;
 &lt;localCfwdEnable&gt;true&lt;/localCfwdEnable&gt;
 &lt;semiAttendedTransfer&gt;true&lt;/semiAttendedTransfer&gt;
 &lt;anonymousCallBlock&gt;2&lt;/anonymousCallBlock&gt;
 &lt;callerIdBlocking&gt;2&lt;/callerIdBlocking&gt;
 &lt;dndControl&gt;0&lt;/dndControl&gt;
 &lt;remoteCcEnable&gt;true&lt;/remoteCcEnable&gt;
 &lt;/sipCallFeatures&gt;
 &lt;sipStack&gt;
 &lt;sipInviteRetx&gt;6&lt;/sipInviteRetx&gt;
 &lt;sipRetx&gt;10&lt;/sipRetx&gt;
 &lt;timerInviteExpires&gt;180&lt;/timerInviteExpires&gt;
 &lt;!-- Force short registration timeout to keep NAT connection alive --&gt;
 &lt;timerRegisterExpires&gt;180&lt;/timerRegisterExpires&gt;
 &lt;timerRegisterDelta&gt;5&lt;/timerRegisterDelta&gt;
 &lt;timerKeepAliveExpires&gt;120&lt;/timerKeepAliveExpires&gt;
 &lt;timerSubscribeExpires&gt;120&lt;/timerSubscribeExpires&gt;
 &lt;timerSubscribeDelta&gt;5&lt;/timerSubscribeDelta&gt;
 &lt;timerT1&gt;500&lt;/timerT1&gt;
 &lt;timerT2&gt;4000&lt;/timerT2&gt;
 &lt;maxRedirects&gt;70&lt;/maxRedirects&gt;
 &lt;remotePartyID&gt;false&lt;/remotePartyID&gt;
 &lt;userInfo&gt;None&lt;/userInfo&gt;
 &lt;/sipStack&gt;
 &lt;autoAnswerTimer&gt;1&lt;/autoAnswerTimer&gt;
 &lt;autoAnswerAltBehavior&gt;false&lt;/autoAnswerAltBehavior&gt;
 &lt;autoAnswerOverride&gt;true&lt;/autoAnswerOverride&gt;
 &lt;transferOnhookEnabled&gt;false&lt;/transferOnhookEnabled&gt;
 &lt;enableVad&gt;false&lt;/enableVad&gt;
 &lt;preferredCodec&gt;<strong>none</strong>&lt;/preferredCodec&gt;
 &lt;dtmfAvtPayload&gt;101&lt;/dtmfAvtPayload&gt;
 &lt;dtmfDbLevel&gt;3&lt;/dtmfDbLevel&gt;
 &lt;dtmfOutofBand&gt;avt&lt;/dtmfOutofBand&gt;
 &lt;alwaysUsePrimeLine&gt;false&lt;/alwaysUsePrimeLine&gt;
 &lt;alwaysUsePrimeLineVoiceMail&gt;false&lt;/alwaysUsePrimeLineVoiceMail&gt;
 &lt;kpml&gt;3&lt;/kpml&gt;
 &lt;natEnabled&gt;false&lt;/natEnabled&gt;
 &lt;natAddress&gt;&lt;/natAddress&gt;
 &lt;!-- FIXME: This will appear in the upper right corner of the display --&gt;
 &lt;phoneLabel&gt;<strong>MyVOIP-Phone</strong>&lt;/phoneLabel&gt;
 &lt;stutterMsgWaiting&gt;1&lt;/stutterMsgWaiting&gt;
 &lt;callStats&gt;false&lt;/callStats&gt;
 &lt;silentPeriodBetweenCallWaitingBursts&gt;10&lt;/silentPeriodBetweenCallWaitingBursts&gt;
 &lt;disableLocalSpeedDialConfig&gt;false&lt;/disableLocalSpeedDialConfig&gt;
 &lt;startMediaPort&gt;16384&lt;/startMediaPort&gt;
 &lt;stopMediaPort&gt;16391&lt;/stopMediaPort&gt;
 &lt;sipLines&gt;
 &lt;line button="1"&gt;
 &lt;featureID&gt;9&lt;/featureID&gt;
 &lt;featureLabel&gt;<strong>MyVOIP-Phone</strong>&lt;/featureLabel&gt;
 &lt;proxy&gt;USECALLMANAGER&lt;/proxy&gt;
 &lt;port&gt;5060&lt;/port&gt;
 &lt;name&gt;<strong>c7965</strong>&lt;/name&gt;
 &lt;displayName&gt;<strong>MyVOIP-Phone</strong>&lt;/displayName&gt;
 &lt;autoAnswer&gt;
 &lt;autoAnswerEnabled&gt;2&lt;/autoAnswerEnabled&gt;
 &lt;/autoAnswer&gt;
 &lt;callWaiting&gt;3&lt;/callWaiting&gt;
 &lt;authName&gt;<strong>c7965</strong>&lt;/authName&gt;
 &lt;authPassword&gt;<strong>PASSWORD</strong>&lt;/authPassword&gt;
 &lt;sharedLine&gt;false&lt;/sharedLine&gt;
 &lt;messageWaitingLampPolicy&gt;3&lt;/messageWaitingLampPolicy&gt;
 &lt;messagesNumber&gt;<strong>501</strong>&lt;/messagesNumber&gt;
 &lt;ringSettingIdle&gt;4&lt;/ringSettingIdle&gt;
 &lt;ringSettingActive&gt;5&lt;/ringSettingActive&gt;
 &lt;contact&gt;<strong>502</strong>&lt;/contact&gt;
 &lt;forwardCallInfoDisplay&gt;
 &lt;callerName&gt;true&lt;/callerName&gt;
 &lt;callerNumber&gt;false&lt;/callerNumber&gt;
 &lt;redirectedNumber&gt;false&lt;/redirectedNumber&gt;
 &lt;dialedNumber&gt;true&lt;/dialedNumber&gt;
 &lt;/forwardCallInfoDisplay&gt;
 &lt;/line&gt;
 &lt;line button="2"&gt;
 &lt;featureID&gt;21&lt;/featureID&gt;
 &lt;featureLabel&gt;<strong>SomeOtherNumber</strong>&lt;/featureLabel&gt;
 &lt;speedDialNumber&gt;<strong>55512345</strong>&lt;/speedDialNumber&gt;
 &lt;/line&gt;
 &lt;/sipLines&gt;

 &lt;voipControlPort&gt;5060&lt;/voipControlPort&gt;
 &lt;dscpForAudio&gt;184&lt;/dscpForAudio&gt;
 &lt;ringSettingBusyStationPolicy&gt;0&lt;/ringSettingBusyStationPolicy&gt;
 &lt;dialTemplate&gt;<strong>dialplan.xml</strong>&lt;/dialTemplate&gt;
&lt;/sipProfile&gt;
&lt;commonProfile&gt;
 &lt;phonePassword&gt;&lt;/phonePassword&gt;
 &lt;backgroundImageAccess&gt;true&lt;/backgroundImageAccess&gt;
 &lt;callLogBlfEnabled&gt;2&lt;/callLogBlfEnabled&gt;
&lt;/commonProfile&gt;
&lt;!-- FIXME: Change this to upgrade the firmware --&gt;
&lt;loadInformation&gt;<strong>SIP45.9-3-1SR4-1S</strong>&lt;/loadInformation&gt;
&lt;vendorConfig&gt;
 &lt;disableSpeaker&gt;false&lt;/disableSpeaker&gt;
 &lt;disableSpeakerAndHeadset&gt;false&lt;/disableSpeakerAndHeadset&gt;
 &lt;pcPort&gt;0&lt;/pcPort&gt;
 &lt;settingsAccess&gt;1&lt;/settingsAccess&gt;
 &lt;garp&gt;0&lt;/garp&gt;
 &lt;voiceVlanAccess&gt;1&lt;/voiceVlanAccess&gt;
 &lt;videoCapability&gt;0&lt;/videoCapability&gt;
 &lt;autoSelectLineEnable&gt;0&lt;/autoSelectLineEnable&gt;
 &lt;webAccess&gt;0&lt;/webAccess&gt;
 &lt;sshAccess&gt;0&lt;/sshAccess&gt;
 &lt;sshPort&gt;22&lt;/sshPort&gt;

 &lt;!-- For Sunday (1) and Saturday (7):
 &lt;daysDisplayNotActive&gt;1,2,3,4,5,6,7&lt;/daysDisplayNotActive&gt;
 Current default is to enable the display 24/7.
 --&gt;
 &lt;daysDisplayNotActive&gt;1,2,3,4,5,6,7&lt;/daysDisplayNotActive&gt;
 &lt;displayOnTime&gt;00:00&lt;/displayOnTime&gt;
 &lt;displayOnDuration&gt;00:01&lt;/displayOnDuration&gt;
 &lt;displayIdleTimeout&gt;00:05&lt;/displayIdleTimeout&gt;
 &lt;spanToPCPort&gt;1&lt;/spanToPCPort&gt;
 &lt;loggingDisplay&gt;1&lt;/loggingDisplay&gt;
 &lt;loadServer&gt;&lt;/loadServer&gt;
 &lt;g722CodecSupport&gt;2&lt;/g722CodecSupport&gt;
&lt;/vendorConfig&gt;
&lt;versionStamp&gt;&lt;/versionStamp&gt;
&lt;userLocale&gt;
 &lt;name&gt;English_United_States&lt;/name&gt;
&lt;uid&gt;1&lt;/uid&gt;
 &lt;langCode&gt;en_US&lt;/langCode&gt;
&lt;version&gt;1.0.0.0-1&lt;/version&gt;
 &lt;winCharSet&gt;iso-8859-1&lt;/winCharSet&gt;
&lt;/userLocale&gt;
&lt;networkLocale&gt;United_States&lt;/networkLocale&gt;
&lt;networkLocaleInfo&gt;
 &lt;name&gt;United_States&lt;/name&gt;
&lt;uid&gt;64&lt;/uid&gt;
 &lt;version&gt;1.0.0.0-1&lt;/version&gt;
&lt;/networkLocaleInfo&gt;
&lt;deviceSecurityMode&gt;0&lt;/deviceSecurityMode&gt;
&lt;!--
&lt;authenticationURL&gt;http://yourwebserver/authenticate.php&lt;/authenticationURL&gt;
&lt;directoryURL&gt;http://yourwebserver/directory.xml&lt;/directoryURL&gt;
--&gt;
&lt;authenticationURL&gt;&lt;/authenticationURL&gt;
&lt;directoryURL&gt;&lt;/directoryURL&gt;
&lt;idleURL&gt;&lt;/idleURL&gt;
&lt;informationURL&gt;&lt;/informationURL&gt;
&lt;messagesURL&gt;&lt;/messagesURL&gt;
&lt;proxyServerURL&gt;&lt;/proxyServerURL&gt;
&lt;!--
 &lt;servicesURL&gt;http://phone-xml.berbee.com/menu.xml&lt;/servicesURL&gt;
--&gt;
&lt;dscpForSCCPPhoneConfig&gt;96&lt;/dscpForSCCPPhoneConfig&gt;
&lt;dscpForSCCPPhoneServices&gt;0&lt;/dscpForSCCPPhoneServices&gt;
&lt;dscpForCm2Dvce&gt;96&lt;/dscpForCm2Dvce&gt;
&lt;transportLayerProtocol&gt;2&lt;/transportLayerProtocol&gt;
&lt;capfAuthMode&gt;0&lt;/capfAuthMode&gt;
&lt;capfList&gt;
 &lt;capf&gt;
 &lt;phonePort&gt;3804&lt;/phonePort&gt;
 &lt;/capf&gt;
&lt;/capfList&gt;
&lt;certHash&gt;&lt;/certHash&gt;
&lt;encrConfig&gt;false&lt;/encrConfig&gt;
&lt;advertiseG722Codec&gt;1&lt;/advertiseG722Codec&gt;
&lt;/device&gt;</pre>

Fill in the details as suiting your environment, and reboot the phone.  Cross your fingers.  Changing the timezones is a particular bugbear, you'll need to dig around to find the correct values for your timezone.  Preferred codecs can be set to g711ulaw, g711alaw, g729a, or none.

The SSH username/password just gets you past the SSH challenge, you still need a login for the phone itself (log/log will show the logs remotely though).

You can configure the six line buttons to be any combination of SIP clients or speed-dials.  An example of each is above.  Now for the one piece remaining, the dial plan.

# Configuring the Dial Plan

Create a new dialplan.xml in the root of your TFTP server, containing this;

<pre>&lt;DIALTEMPLATE&gt;
 &lt;TEMPLATE MATCH="5.." Timeout="0"/&gt;
 &lt;TEMPLATE MATCH="000" Timeout="0"/&gt;
 &lt;TEMPLATE MATCH="106" Timeout="0"/&gt;

 &lt;TEMPLATE MATCH="1831-" Timeout="2"/&gt;
 &lt;TEMPLATE MATCH="1832-" Timeout="2"/&gt;

 &lt;TEMPLATE MATCH="13........" Timeout="0"/&gt;
 &lt;TEMPLATE MATCH="18........" Timeout="0"/&gt;
 &lt;TEMPLATE MATCH="19........" Timeout="0"/&gt;

 &lt;TEMPLATE MATCH="13...." Timeout="0"/&gt;

 &lt;TEMPLATE MATCH="61........." Timeout="0" Rewrite="0........"/&gt;
 &lt;TEMPLATE MATCH="001....-" Timeout="5"/&gt;
 &lt;TEMPLATE MATCH="02........" Timeout="0"/&gt;
 &lt;TEMPLATE MATCH="03........" Timeout="0"/&gt;
 &lt;TEMPLATE MATCH="04........" Timeout="0"/&gt;
 &lt;TEMPLATE MATCH="07........" Timeout="0"/&gt;
 &lt;TEMPLATE MATCH="08........" Timeout="0"/&gt;
 &lt;TEMPLATE MATCH="111" Timeout="0"/&gt;

 &lt;TEMPLATE MATCH="2......." Timeout="0"/&gt;
 &lt;TEMPLATE MATCH="3......." Timeout="0"/&gt;
 &lt;TEMPLATE MATCH="4......." Timeout="0"/&gt;
 &lt;TEMPLATE MATCH="5......." Timeout="0"/&gt;
 &lt;TEMPLATE MATCH="6......." Timeout="0"/&gt;
 &lt;TEMPLATE MATCH="7......." Timeout="0"/&gt;
 &lt;TEMPLATE MATCH="8......." Timeout="0"/&gt;
 &lt;TEMPLATE MATCH="9......." Timeout="0"/&gt;

 &lt;TEMPLATE MATCH="*.." Timeout="0"/&gt;
 &lt;TEMPLATE MATCH="*" Timeout="15"/&gt;
&lt;/DIALTEMPLATE&gt;</pre>

There's a bit of redundancy and probably errors in this, but this is what I use.  Obviously this is engineered for Australia, so it's formatted for Australian numbers.

At the very least, that dial plan should get you started.

# Hope it worked!

If all has gone well, the C7965 has registered to Asterisk, and you can test a call.  Try and receive a call first, then try and deliver one.  Use the 'sip show users' command to check that the phone is registering, and the 'sip show channels' command to view the codec that's being used when in a call.

Good luck!