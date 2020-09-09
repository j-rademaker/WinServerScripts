# Configure Domain Controller Script

#region To-Do
<#
 - Domain & Forest Mode separation
 - DNS Delegation
 - Implement 15 character limit for NetBIOS parameter
#>
#endregion

#region Parameters
Param (
    $FQDN,
    $NetBIOS,
    [Security.SecureString]$SafeModePassword,
    $ForestMode,
    $DomainMode,
    [switch]$Restart
)

#endregion


function Main {
    
    #region Parameter Validation
    
    if (-not $FQDN){
        Write-Error "Missing a Fully Qualified Domain Name (FQDN). Specify the 'FQDN' parameter, and try again."
        Exit
    }

    if (-not $NetBIOS){
        Write-Error "Missing a NetBIOS name. Specify the 'NetBIOS' parameter, and try again."
        Exit
    }

    if (-not $SafeModePassword){
        $SafeModePassword = Read-Host -AsSecureString -Prompt "Missing a Safe Mode Administrator Password. Please enter a Password"
    }

    if (-not $ForestMode){
        $ForestMode = "Default"
    }

    if (-not $DomainMode){
        $DomainMode = "Default"
    }

    #endregion
    
    #region Install Preqrequisite Features

    $PrerequisiteFeatures = "ad-domain-services","dns","gpmc","RSAT-AD-PowerShell"
    
    ForEach ($Feature in $PrerequisiteFeatures) {
        if ((Get-WindowsFeature -Name $Feature).InstallState -eq 'Available'){
            Install-WindowsFeature -Name $Feature
        }
    }

    #endregion

    #region Configure Domain

    Import-Module ADDSDeployment

    try {
        Get-ADForest -Identity $FQDN
    } catch {
        if ($Restart){
            Install-ADDSForest -ForestMode $ForestMode -DomainName $FQDN -DomainNetbiosName $NetBios -DomainMode $DomainMode -SafeModeAdministratorPassword $SafeModePassword -InstallDns -Force
        } elseif (-not $Restart) {
            Install-ADDSForest -ForestMode $ForestMode -DomainName $FQDN -DomainNetbiosName $NetBios -DomainMode $DomainMode -SafeModeAdministratorPassword $SafeModePassword -InstallDns -NoRebootOnCompletion -Force
        }
    }

    #endregion

}

Main
