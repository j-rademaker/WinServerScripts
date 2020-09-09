# Configure Host Script

#region To-Do
<#
 - IPV6 Support
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
    $SubnetMask,
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

    if (-not $CIDRSubnetMask -and -not $SubnetMask) {
        Write-Error "Missing Subnet Mask. Specify the 'CIDRSubnetMask' or 'SubnetMask' parameter, and try again."
    } elseif ($SubnetMask -and -not$CIDRSubnetMask) {
        switch ($SubnetMask){
        "255.255.255.255" { $CIDRSubnetMask = 32 }
        "255.255.255.254" { $CIDRSubnetMask = 31 }
        "255.255.255.252" { $CIDRSubnetMask = 30 }
        "255.255.255.248" { $CIDRSubnetMask = 29 }
        "255.255.255.240" { $CIDRSubnetMask = 28 }
        "255.255.255.224" { $CIDRSubnetMask = 27 }
        "255.255.255.192" { $CIDRSubnetMask = 26 }
        "255.255.255.128" { $CIDRSubnetMask = 25 }
        "255.255.255.0" { $CIDRSubnetMask = 24 }
        "255.255.254.0" { $CIDRSubnetMask = 23 }
        "255.255.252.0" { $CIDRSubnetMask = 22 }
        "255.255.248.0" { $CIDRSubnetMask = 21 }
        "255.255.240.0" { $CIDRSubnetMask = 20 }
        "255.255.224.0" { $CIDRSubnetMask = 19 }
        "255.255.192.0" { $CIDRSubnetMask = 18 }
        "255.255.128.0" { $CIDRSubnetMask = 17 }
        "255.255.0.0" { $CIDRSubnetMask = 16 }
        "255.254.0.0" { $CIDRSubnetMask = 15 }
        "255.252.0.0" { $CIDRSubnetMask = 14 }
        "255.248.0.0" { $CIDRSubnetMask = 13 }
        "255.240.0.0" { $CIDRSubnetMask = 12 }
        "255.224.0.0" { $CIDRSubnetMask = 11 }
        "255.192.0.0" { $CIDRSubnetMask = 10 }
        "255.128.0.0" { $CIDRSubnetMask = 9 }
        "255.0.0.0" { $CIDRSubnetMask = 8 }
        "254.0.0.0" { $CIDRSubnetMask = 7 }
        "252.0.0.0" { $CIDRSubnetMask = 6 }
        "248.0.0.0" { $CIDRSubnetMask = 5 }
        "240.0.0.0" { $CIDRSubnetMask = 4 }
        "224.0.0.0" { $CIDRSubnetMask = 3 }
        "192.0.0.0" { $CIDRSubnetMask = 2 }
        "128.0.0.0" { $CIDRSubnetMask = 1 }
        "0.0.0.0" { $CIDRSubnetMask = 0 }
        default { Write-Error "Unsupported Subnet Mask value, defaulting to 255.255.255.0"
                $CIDRSubnetMask = 24
            }
        }
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

