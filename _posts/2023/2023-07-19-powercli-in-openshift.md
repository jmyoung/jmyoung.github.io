---
title: 'vmWare PowerCLI in OpenShift'
author: James Young
layout: post
categories:
  - technical
tags:
  - kubernetes
  - microk8s
  - powershell
  - vmware
---

Leaning on [vmWare PowerCLI](https://developer.vmware.com/web/tool/13.1.0/vmware-powercli) for much of my day-to-day system administration needs, I also have need for running PowerCLI scripts regularly.  There are many ways to do this, but since I have an OpenShift cluster available, why not run those scripts in containers so you can simply set up a cronjob manifest to run them?

Fortunately, Microsoft released [Powershell for Ubuntu](https://learn.microsoft.com/en-us/powershell/scripting/install/install-ubuntu?view=powershell-7.3), and the PowerCLI cmdlets install and load in it just fine.  We'll run through an example setup, using Ubuntu 22.04 Jammy, Powershell 7.2.5 LTS, and configure some bits to provide auto-login to a VMware cluster.

First, you will require a `profile.ps1`.  This script is automatically executed on container startup, and will log into a set of one (or more) vCenter servers using the credentials provided in the environment;

| Variable         | Purpose                                             |
| ---------------- | --------------------------------------------------- |
| VCENTER_SERVER   | Comma-delimited list of host vCenters to connect to |
| VCENTER_USERNAME | User to connect as, full uid@domain format          |
| VCENTER_PASSWORD | Password to use to connect                          |

The `profile.ps1` appears below;

```powershell
# Profile is copied to /profile/.config/powershell/Microsoft.PowerShell_profile.ps1

# Disable history saving for transient containers
Set-PSReadLineOption -HistorySaveStyle SaveNothing

# If vCenter login creds are included, use them
if ($env:VCENTER_SERVER) {
  # Username and password must also be included
  if ($env:VCENTER_USERNAME -and $env:VCENTER_PASSWORD) {
    # Process login to vCenter servers
    $secPass = $env:VCENTER_PASSWORD | ConvertTo-SecureString -AsPlainText -Force
    $credential = New-Object System.Management.Automation.PSCredential -ArgumentList $env:VCENTER_USERNAME,$secPass
    foreach ($server in ${env:VCENTER_SERVER}.split(",")) { Connect-VIServer -Server $server -Credential $credential }

    # Check that we have actually logged into all vCenter servers in the list
    if (${env:VCENTER_SERVER}.split(",").Count -ne @($DefaultVIServers).Count) {
      Write-Error "ERROR: Did not connect to all vCenter servers requested"
    } else {
      # Set a global variable to indicate that we are connected to vCenter correctly
      $global:VCENTER_CONNECTED=$true
    }
  } else {
    Write-Error "ERROR: vCenter servers provided, usernames and passwords were not"
  }
}

# Set a global variable to indicate the default scripts directory
$global:SCRIPTS_DIRECTORY="/profile/scripts"

# End of startup script
```
Next you'll need a `Dockerfile`, which assumes you have the Powershell install deb in the same directory as it;

```dockerfile
#
# Assembles a container image with PowerShell and VMware PowerCLI preinstalled
#

# Based off Ubuntu Jammy
FROM docker.io/library/ubuntu:jammy

# Install required libraries and tools
RUN apt-get update && apt-get install -y \
        wget \
        libicu70 \
        && rm -rf /var/lib/apt/lists/*

# Define a profile directory, set HOME to it, and make it permission 777
RUN mkdir /profile && chown nobody:nogroup /profile && chmod a+rwx /profile && cd /profile
ENV HOME=/profile
WORKDIR /profile

# Install a specific version of Powershell
ADD powershell-lts_7.2.5-1.deb_amd64.deb /powershell-lts_7.2.5-1.deb_amd64.deb
RUN dpkg -i /powershell-*.deb && rm -f /powershell-*.deb

# Install PowerCLI and configure it
RUN pwsh -nol -noni -Command "Set-PSReadLineOption -HistorySaveStyle SaveNothing"
RUN pwsh -nol -noni -Command "Set-PSRepository -Name PSGallery -InstallationPolicy Trusted"
RUN pwsh -nol -noni -Command "Install-Module VMware.PowerCLI -Scope AllUsers -AcceptLicense -Confirm:\$false"
RUN pwsh -nol -noni -Command "Set-PowerCLIConfiguration -Scope AllUsers -ParticipateInCEIP \$false -Confirm:\$false"
RUN pwsh -nol -noni -Command "Set-PowerCLIConfiguration -Scope AllUsers -DefaultVIServerMode Multiple -Confirm:\$false"

# Create a profile directory and put the profile into it
RUN mkdir -p /profile/.config/powershell
ADD profile.ps1 /profile/.config/powershell/Microsoft.PowerShell_profile.ps1

# Reset all permissions on the profile folder
RUN chown -R nobody:nogroup /profile && chmod -R a+rwx /profile

# Configure entrypoint to use PowerShell with no logo
ENTRYPOINT [ "/opt/microsoft/powershell/7-lts/pwsh", "-nol" ]
```

With that done, you can then build the image however you normally would and make use of it.  Your command line should look like `-nol -Command "/profile/scripts/your-script.ps1"` .

If you want to bring up a pod on Kubernetes, your manifest will look something like this;

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: test-pod
spec:
  containers:
  - args:
    - -nol
    - -Command
    - "/profile/scripts/YOURSCRIPT.ps1"
    env:
    - name: VCENTER_SERVER
      valueFrom:
        secretKeyRef:
          key: VCENTER_SERVER
          name: creds-vcenter
    - name: VCENTER_USERNAME
      valueFrom:
        secretKeyRef:
          key: VCENTER_USERNAME
          name: creds-vcenter
    - name: VCENTER_PASSWORD
      valueFrom:
        secretKeyRef:
          key: VCENTER_PASSWORD
          name: creds-vcenter
    image: YOURIMAGEGOESHERE:latest
    imagePullPolicy: Always
    name: test-pod
    resources:
      limits:
        cpu: 2000m
        memory: 1024Mi
      requests:
        cpu: 250m
        memory: 256Mi
    volumeMounts:
      - name: scripts-volume
        mountPath: /profile/scripts
  volumes:
    - name: scripts-volume
      configMap:
        name: script-example-script
  dnsPolicy: ClusterFirst
  restartPolicy: Never
  serviceAccount: default
```

As should be obvious, you'll need a `secret` named `creds-vcenter` holding the required vCenter credentials, and you'll need to also have a configmap with an entry in it for a filename which contains your file to run.

This functionality should be quite extensible and robust.