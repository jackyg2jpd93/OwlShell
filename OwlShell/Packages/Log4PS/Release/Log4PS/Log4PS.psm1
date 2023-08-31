using module ".\Core\Level.psm1"

<#
.SYNOPSIS
	Namespace for the Log4PS package
.DESCRIPTION
	Universal Logging Package for PowerShell
.NOTES
	- Author: OwlAuto
	- Since:  2023/08/03
#>

<#
.SYNOPSIS
	Namespace
.DESCRIPTION
	Provide integrated namespace to reduce excessive class imports within the operational environment
#>
class Log4PS {
	[PSCustomObject]$Core = [PSCustomObject]@{
		"Level" = [Level];
	}
}