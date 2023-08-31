using module ".\Handler\ClassHandler.psm1"
using module ".\Handler\ErrorHandler.psm1"

<#
.SYNOPSIS
	Namespace for the Cmn4Lib package
.DESCRIPTION
	This module serves as a foundational toolkit for program architecture,
	offering a diverse range of utility classes and versatile methods designed to underpin the operation of software systems
	It addresses crucial aspects such as error handling and streamlines workflow design
	The primary goal of this module is to consolidate commonly used functionalities,
	enabling developers to minimize redundant code through the extraction and encapsulation of shared components
	By doing so, it enhances code efficiency, promotes maintainability, and fosters a more modular and organized development process
.NOTES
	- Author: OwlAuto
	- Since:  2023/08/22
#>

<#
.SYNOPSIS
	Namespace
.DESCRIPTION
	Provide integrated namespace to reduce excessive class imports within the operational environment
#>
class Cmn4Lib {
	[PSCustomObject]$Handler = [PSCustomObject]@{
		'ClassHandler' = [PSCustomObject]@{
			'CLBase' = [CLBase];
		};
		'ErrorHandler' = [PSCustomObject]@{
			'MultiErr' = [MultiErr];
		};
	}
}