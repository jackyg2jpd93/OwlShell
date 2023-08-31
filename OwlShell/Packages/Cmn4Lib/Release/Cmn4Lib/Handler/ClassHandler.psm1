using module ".\ErrorHandler.psm1"

<#
.SYNOPSIS
	Class handling module
.DESCRIPTION
	This module serves as a comprehensive toolkit for class management,
	offering an assortment of inheritable classes and a wide array of methods tailored for creating various auxiliary classes
	Its primary objective is to streamline the process of class creation by providing developers with a range of pre-defined structures and functionalities
	This class utility module aims to enhance code reusability and maintainability by encapsulating common class-related tasks and promoting a unified approach to class handling
.NOTES
	- Author: OwlAuto
	- Since:  2023/08/30
#>

<#
.SYNOPSIS
	Class creation utility
.DESCRIPTION
	This class can be inherited to simplify the general class creation process and provide functionalities simulating classes from compiled languages
#>
class CLBase {
	<#
	.SYNOPSIS
		Public Method
	.DESCRIPTION
		Provide the property name, the script for getting the property value, and the script for setting the property value to create a new class property
	.PARAMETER name
		The name of the property to be added
	.PARAMETER getter
		Define the command to be executed when accessing this property
	.PARAMETER setter
		Define the command to be executed when setting this property
		If parameters are needed, please pass them using "param()" format
	.NOTES
		- throws: [ArgumentException]
	#>
	[void] NewProp ([string]$name, [scriptblock]$getter, [scriptblock]$setter) {
		#Create an instance of the MultiErr class
		[MultiErr]$me = [MultiErr]::new()
		#Check: Property name
		$me.StrWhiteSpaceValidator($name, 'Property name cannot be empty')
		#Check: The script of getter
		$me.StrWhiteSpaceValidator($getter, 'The script of getter cannot be empty')
		#Check: The script of setter
		$me.StrWhiteSpaceValidator($setter, 'The script of setter cannot be empty')
		#Trigger error validation
		$me.Flush()
		#Append Property
		$this | Add-Member -MemberType 'ScriptProperty' -Name $name -Value $getter -SecondValue $setter
	}
	
	<#
	.SYNOPSIS
		Public Method
	.DESCRIPTION
		Provide the property name, and the script for getting the property value to create a new read-only class property
	.PARAMETER name
		The name of the property to be added
	.PARAMETER getter
		Define the command to be executed when accessing this property
	.NOTES
		- throws: [ArgumentException]
	#>
	[void] NewReadonlyProp ([string]$name, [scriptblock]$getter) {
		#Construct setter script that returns read-only error message
		[scriptblock]$setter = {
			throw [InvalidOperationException]::new('This is a readonly property')
		}
		#Create a new class property
		$this.NewProp($name, $getter, $setter)
	}
}