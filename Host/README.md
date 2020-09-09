# Host #
Here you will find scripts relating to a single host machine.

## Configure Host
This script configures the Hostname, IP Address, Subnet Mask, Gateway and DNS servers of the host.
### Example
```powershell
& $([scriptblock]::Create((New-Object Net.WebClient).DownloadString("https://raw.githubusercontent.com/j-rademaker/WinServerScripts/master/Host/ConfigureHost.ps1")))  -Hostname HelloWorld -InterfaceName Ethernet0 -IP 192.168.242.10 -SubnetMask 255.255.255.128 -Gateway 192.168.242.2 -DNS1 192.168.242.2 -DNS2 8.8.4.4 -Restart
```
### Parameters
| Parameter | Hostname |
|---|---|
|Type|String|
|Description|The hostname you want to configure for the machine.|
|Valid Value|e.g. WinServer001|
|Mandatory|Yes|

| Parameter | InterfaceIndex |
|---|---|
|Type|Integer|
|Description|The ID of the network interface you want to configure on the machine.|
|Valid Value|e.g. 5|
|Mandatory|Yes, but could be replaced by InterfaceName|

| Parameter | InterfaceName |
|---|---|
|Type|String|
|Description|The Name of the network interface you want to configure on the machine.|
|Valid Value|e.g. Ethernet0|
|Mandatory|Yes, but could be replaced by InterfaceIndex|

| Parameter | IP |
|---|---|
|Type|String|
|Description|The IP Address you want to configure on the interface.|
|Valid Value|e.g. 192.168.1.100|
|Mandatory|Yes|

| Parameter | SubnetMask |
|---|---|
|Type|String|
|Description|The Subnet Mask you want to configure on the interface.|
|Valid Value|0.0.0.0-255.255.255.255|
|Mandatory|Yes, but could be replaced by CIDRSubnetMask|

| Parameter | CIDRSubnetMask |
|---|---|
|Type|Integer|
|Description|The Subnet Mask (in CIDR notation) you want to configure on the interface.|
|Valid Value|0-32|
|Mandatory|Yes, but could be replaced by SubnetMask|

| Parameter | Gateway |
|---|---|
|Type|String|
|Description|The IP Address of the Gateway you want to configure on the interface.|
|Valid Value|e.g. 192.168.1.1|
|Mandatory|Yes|

| Parameter | DNS1,DNS2 |
|---|---|
|Type|String|
|Description|The DNS Address(es) you want to configure on the interface.|
|Valid Value|e.g. 192.168.1.1|
|Mandatory|Yes, at least 1 parameter needs to be entered|

| Parameter | Restart |
|---|---|
|Type|switch|
|Description|Restart the machine when necessary (hostname change).|
|Valid Value|$true, $false|
|Mandatory|No|

