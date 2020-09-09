# Join Domain Script

#region To-Do
<#
 - Extend Credential support
#>
#endregion

#region Parameters
Param (
    $FQDN,
    [System.Management.Automation.PSCredential]$Credential,
    [switch]$Restart
)

#endregion


function Main {
    
    #region Parameter Validation

    if (-not $FQDN) {
        Write-Error "Missing a Fully Qualified Domain Name (FQDN). Specify the 'FQDN' parameter, and try again."
        Exit
    }

    if (-not $Credential){
        $Credential = Get-Credential
    }

    #endregion
    
    #region Join Domain

        # Verifying if host is currently part of domain
        if (-not (Get-WmiObject -Class Win32_ComputerSystem).PartOfDomain){
            # Add computer to domain
            Add-Computer -DomainName $FQDN -Credential $Credential -Force

            if ($Restart){
                Restart-Computer -Force | Out-Null
            }
        }

    #endregion

}

Main
