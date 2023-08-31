using namespace System.Text

<#
.SYNOPSIS
	Error handling module
.DESCRIPTION
	We are in the process of developing an all-encompassing error management module
	This module aims to provide a wide array of error handling techniques tailored for various scenarios
	Additionally, it will cover prevalent error categories that developers commonly encounter
	Alongside these, the module will integrate relevant components to ensure a cohesive and streamlined approach to programming
.NOTES
	- Author: OwlAuto
	- Since:  2023/08/30
#>

<#
.SYNOPSIS
	Error handling at the same level
.DESCRIPTION
	Provide efficient handling methods for multiple similar-level error validation conditions and reduce unnecessary memory usage
#>
class MultiErr {
	#Base error type
	hidden [type]$_base = [ArgumentException]
	#String concatenator
	hidden [StringBuilder]$_sb
	
	<#
	.SYNOPSIS
		Constructor
	.DESCRIPTION
		Default class constructor (parameterless)
	#>
	MultiErr () {}
	
	<#
	.SYNOPSIS
		Constructor
	.DESCRIPTION
		Specify base error type
	.PARAMETER e
		Set base error type
	#>
	MultiErr ([type]$e) {
		#Check: Whether base error type is specified
		if ($e) {
			#Set base error type
			$this._base = $e
		}
	}
	
	<#
	.SYNOPSIS
		Public Method
	.DESCRIPTION
		Append error message
	.PARAMETER msg
		Specify the error message to be added
	#>
	[void] Append ([string]$msg) {
		#Check: Valid String
		if ([string]::IsNullOrWhiteSpace($msg)) {
			return
		}
		#Initialize String Concatenator
		$this._InitSB()
		#Concatenate Error Messages
		$this._sb.AppendLine($msg)
	}
	
	<#
	.SYNOPSIS
		Public Method
	.DESCRIPTION
		Check the specified condition state to determine whether to write an error message
	.PARAMETER condition
		The condition to be checked
	.PARAMETER msg
		Error message to be appended when the condition is met
	#>
	[void] Validate ([bool]$condition, [string]$msg) {
		#Check: Condition
		if ($condition) {
			#Append error message
			$this.Append($msg)
		}
	}
	
	<#
	.SYNOPSIS
		Public Method
	.DESCRIPTION
		Validate using the [string]::IsNullOrEmpty method
	.PARAMETER str
		String to be tested
	.PARAMETER msg
		Error message to be appended when the condition is met
	#>
	[void] StrEmptyValidator ([string]$str, [string]$msg) {
		#Validate the condition
		$this.Validate([string]::IsNullOrEmpty($str), $msg)
	}
	
	<#
	.SYNOPSIS
		Public Method
	.DESCRIPTION
		Validate using the [string]::IsNullOrWhiteSpace method
	.PARAMETER str
		String to be tested
	.PARAMETER msg
		Error message to be appended when the condition is met
	#>
	[void] StrWhiteSpaceValidator ([string]$str, [string]$msg) {
		#Validate the condition
		$this.Validate([string]::IsNullOrWhiteSpace($str), $msg)
	}
	
	<#
	.SYNOPSIS
		Public Method
	.DESCRIPTION
		Trigger error validation
		If a base error has been created and the error message is not empty, throw an error of that type
	.NOTES
		- throws: [type]
	#>
	[void] Flush () {
		#Check: Is String Concatenator Initialized
		if (!$this._sb) {
			return
		}
		#Throw an error
		throw $this._base::new($this._sb.ToString())
	}
	
	<#
	.SYNOPSIS
		Private Method
	.DESCRIPTION
		Check if the String Concatenator is initialized; if not, initialize it
	#>
	hidden [void] _InitSB () {
		#Check: Is String Concatenator Initialized
		if ($this._sb) {
			return
		}
		#Initialize String Concatenator
		$this._sb = [StringBuilder]::new()
	}
}