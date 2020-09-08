# Configure Host

#region To-Do
<#
 - IPV6 Support
 - Subnet Mask Support Extended
 - DNs multi input parameter (e.g. -DNS 1.1.1.1,2.2.2.2 instead of -DNS1 1.1.1.1 -DNS2 2.2.2.2)
 - Modularity approach (e.g. Setting Hostname OR IP OR DNS)
 - Implement Logging
 - Implement verbosity 
#>
#endregion

#region Parameters
Param (
    $Hostname,
    $InterfaceIndex,
    $InterfaceName,
    $IP,
    $CIDRSubnetMask,
    $Gateway,
    $DNS1,
    $DNS2,
    [switch]$Restart
)

#endregion


function Main {
    
    #region Parameter Validation
    
    if (-not $Hostname){
        Write-Error "Missing a hostname. Specify the 'Hostname' parameter, and try again."
    }

    if (-not $InterfaceIndex -and -not $InterfaceName) {
        Write-Error "Missing an interface to configure. Specify the 'InterfaceIndex' or 'InterfaceName' Parameter, and try again"
    } elseif ($InterfaceIndex -and -not $InterfaceName) {
        # Translate InterfaceIndex to InterfaceName
        $InterfaceName = (Get-NetIPInterface -InterfaceIndex $InterfaceIndex -AddressFamily IPv4).ifAlias
    }

    if (-not $IP) {
        Write-Error "Missing IP Address. Specify the 'IP' parameter, and try again."
    }

    if (-not $CIDRSubnetMask) {
        Write-Error "Missing Subnet Mask. Specify the 'CIDRSubnetMask' parameter, and try again."
    }

    if (-not $Gateway) {
        Write-Error "Missing Gateway IP Address. Specify the 'Gateway' parameter, and try again."
    }

    if (-not $DNS1) {
        Write-Error "Missing DNS IP Address. Specify the 'DNS1' parameter, and try again."
    }

    #endregion

    #region Configure IP Address and Gateway

    # Check if DHCP is Disabled
    if ((Get-NetIPInterface -InterfaceAlias $InterfaceName -AddressFamily IPv4).Dhcp -eq "Disabled"){
        # Remove static configured IP Address and Gateway
        Remove-NetIPAddress -InterfaceAlias $InterfaceName -Confirm:$false
        Remove-NetRoute -InterfaceAlias $InterfaceName -Confirm:$false
    }

    # Set IP Address
    New-NetIPAddress -IPAddress $IP -PrefixLength $CIDRSubnetMask -InterfaceAlias $InterfaceName -DefaultGateway $gateway | Out-Null 

    #endregion

    #region Configure DNS Address(es)

    if ($DNS2){
        Set-DnsClientServerAddress -InterfaceAlias $InterfaceName -ServerAddresses ($DNS1,$DNS2)
    } else {
        Set-DnsClientServerAddress -InterfaceAlias $InterfaceName -ServerAddresses $DNS1
    }

    #endregion

    #region Configure Hostname (optional reboot)

    if ($Restart) {
        Rename-Computer -NewName $Hostname -Force -Restart | Out-Null
    } else {
        Rename-Computer -NewName $Hostname -Force | Out-Null
    }

    #endregion

}

Main


