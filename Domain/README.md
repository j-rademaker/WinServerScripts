# Domain #
Here you will find scripts relating to a single host machine.

## Configure Domain controller
This script configures the Domain Controller on the current host.

### Example
```powershell
& $([scriptblock]::Create((New-Object Net.WebClient).DownloadString("https://raw.githubusercontent.com/j-rademaker/WinServerScripts/master/Domain/ConfigureDomainController.ps1")))  -FQDN demo.local -NetBIOS DEMO -SafeModePassword $SecureString -Restart
```
### Parameters
| Parameter | FQDN |
|---|---|
|Type|String|
|Description|The Fully Qualified Domain Name (FQDN) you want to configure for the domain.|
|Valid Value|e.g. demo.local|
|Mandatory|Yes|

| Parameter | NetBIOS |
|---|---|
|Type|String|
|Description|The NetBIOS name you want to configure the domain.|
|Valid Value|e.g. DEMO|
|Mandatory|Yes|

| Parameter | SafeModePassword |
|---|---|
|Type|SecureString|
|Description|The Safe Mode Administrator Password configure on the domain.|
|Valid Value|e.g. a securestring variable|
|Mandatory|Yes, but will be prompted for if not given|

| Parameter | ForestMode |
|---|---|
|Type|String|
|Description|Specifies the forest functional level for the new forest.|
|Valid Value|Win2008, Win2008R2, Win2012, Win2012R2, WinThreshold, Default|
|Mandatory|No|

| Parameter | DomainMode |
|---|---|
|Type|String|
|Description|Specifies the domain functional level of the first domain in the creation of a new forest.|
|Valid Value|Win2008, Win2008R2, Win2012, Win2012R2, WinThreshold, Default|
|Mandatory|No|

| Parameter | Restart |
|---|---|
|Type|switch|
|Description|Restart the machine when necessary (hostname change).|
|Valid Value|$true, $false|
|Mandatory|No|

