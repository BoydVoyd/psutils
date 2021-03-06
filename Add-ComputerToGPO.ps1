<#	
	.NOTES
	===========================================================================
	Created on:		04-06-2017
	Last Edited:	04-06-2017
	Version:		1.0
	Created by:		Nathan Davis
	Organization:	Ingram Content Group
	Filename:		Add-ComputerToGPO.ps1
	Changes: 		
	===========================================================================
	.SYNOPSIS
		Add a computer to a GPO ACE.
	
	.DESCRIPTION
		Add a computer to a GPO ACE. Can also add users and groups with the correct parameter.

	.PARAMETER 
		GPO - The name of the GPO being modified. Devault is "Disable LLMNR".
        serverFile - A text file containing the names of the servers to be added. Default is .\servers.txt.
        logDir - Directory to put the error log. Default is the folder where the script is located.
		targetType - can be computer, group,  or user. Default is computer.

	.INPUTS
		Text file with the name of the servers to be added to the FPO ACE.

	.OUTPUTS
		Add-ComputerToGPO_errors.txt - Error log placed in the directory specified in the logDir parameter.
		
	.EXAMPLE
	./Add-ComputerToGPO.ps1
    ./Add-ComputerToGPO -GPO "Disable LLMNR" -serverFile "C:\scripts\data\servers.txt" -logDir "C:\scripts\logs"	
#>

Param(
    [string]$GPO='Disable LLMNR',
    [string]$serverFile='.\servers.txt',
    [string]$logDir=(Split-Path $MyInvocation.MyCommand.Path),
    [string]$targetType =  'computer'
)

Import-Module grouppolicy

$errorLog = $logDir + '\Add-ComputerToGPO_errors.txt'
$errors = @()

Try{
    $computers = Get-Content $serverFile -ErrorAction Stop
}
Catch{
    $errors += 'Server list not found.'
}

foreach($computer in $computers){
    Try{
        Set-GPPermissions -Name $GPO -Permissionlevel gpoapply -TargetName $computer -TargetType $targetType -ErrorAction Stop
    }
    Catch{
        $errors += $_.Exception.Message
    }
}

$errors | Out-File $errorLog