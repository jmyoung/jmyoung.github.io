---
id: 113
title: 'PowerCLI: Get-VMSize'
date: 2011-04-27T05:18:00+09:30
author: James Young
layout: post
guid: http://wordpress/wordpress/?p=113
permalink: /2011/04/powercli-get-vmsize/
blogger_blog:
  - coding.zencoffee.org
blogger_author:
  - DW
blogger_permalink:
  - /2011/04/powercli-get-vmsize.html
categories:
  - Technical
---
I'm employed as a server admin, with most of my time spent working with VMware and managing a reasonably sized fleet of machines.  As such, I have a range of various Powershell scripts I've written to take advantage of VMware's [PowerCLI](http://communities.vmware.com/community/vmtn/vsphere/automationtools/powercli?view=overview) interface for Powershell.  PowerCLI is, in a word, great.  It provides some pretty good in-depth insight to what's going on in vCenter, and since it ties into Powershell, it's easy to script up whatever you want to do.

Anyhow, below is a filter script, which was cobbled together from some code from a source I can't recall (if you know the original source, let me know so I can attribute it properly!).  The purpose of this script is to take a bunch of VMs, calculate the Size and Used disk space of those VMs, and dump that out.

<a name="more"></a>

> <span><span>Begin {</span></p> 
> 
> <p>
>   <span>}</span>
> </p>
> 
> <p>
>   <span>Process {</span><br /><span>    $vm = $_</span>
> </p>
> 
> <p>
>   <span>    $report = $vm | select Name, Id, Size, Used</span><br /><span>    $report.Size = 0</span><br /><span>    $report.Used = 0</span>
> </p>
> 
> <p>
>   <span>    $vmview = $vm | Get-View</span><br /><span>    foreach($disk in $vmview.Storage.PerDatastoreUsage){ </span><br /><span>           $dsview = (Get-View $disk.Datastore)</span><br /><span>        #$dsview.RefreshDatastoreStorageInfo()</span><br /><span>        $report.Size += (($disk.Committed+$disk.Uncommitted)/1024/1024/1024)</span><br /><span>        $report.Used += (($disk.Committed)/1024/1024/1024)</span><br /><span>    } </span>
> </p>
> 
> <p>
>   <span>    $report.Size = [Math]::Round($report.Size, 2)</span><br /><span>    $report.Used = [Math]::Round($report.Used, 2)</span>
> </p>
> 
> <p>
>   <span>    Write-Output $report</span><br /><span>}</span>
> </p>
> 
> <p>
>   <span>End {</span>
> </p>
> 
> <p>
>   <span>}</span></span>
> </p></blockquote> 
> 
> <p>
>    An example of its use follows;
> </p>
> 
> <blockquote>
>   <p>
>     <span>Get-VM | .\Get-VMSize.ps1 | Measure-Object -Property Size -Sum</span>
>   </p>
> </blockquote>
> 
> <p>
>   The input should be a <span>VMware.VimAutomation.ViCore,Impl.V1.Inventory.VirtualMachineImpl</span> object, such as what gets returned by Get-VM.  Each output object from the script will contain the following fields;
> </p>
> 
> <ul>
>   <li>
>     <b>Name</b> - The text name of the VM as given by the Name field in the input object.
>   </li>
>   <li>
>     <b>Id</b> - The ID of the VM as given by the Id field of the input object.
>   </li>
>   <li>
>     <b>Size</b> - The sum of the sizes of all disks used by the VM.  This size is the figure set when provisioning the disk, not the actual on-disk allocation (ie, it will be bigger than the disk use if you are using thin provisioning).
>   </li>
>   <li>
>     <b>Used</b> - The amount of actual disk space being used by all disks on the VM.  This size is smaller than Size if the VM is thin provisioned.
>   </li>
> </ul>
> 
> <p>
>   Enjoy.
> </p>