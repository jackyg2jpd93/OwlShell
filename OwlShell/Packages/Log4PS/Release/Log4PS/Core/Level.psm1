using module ".\Common.psm1"

<#
.SYNOPSIS
	Level
.DESCRIPTION
	Define specific log level names, values, and information for Log4PS
.NOTES
	- Author: OwlAuto
	- Since:  2023/08/03
#>

<#
.SYNOPSIS
	Define the default log levels
.DESCRIPTION
	Log levels inherit from IComparable, allowing any two levels to be compared for their numerical significance
	This class defines commonly used log levels in advance, and you can also create custom log levels through this class
#>
class Level : ClassHandler, IComparable {
	#Log level name
	hidden [string]$_levelName
	#Log level value
	hidden [int]$_levelValue
	#Log level display name
	hidden [string]$_levelDisplayName
	
	<#
	.SYNOPSIS
		Constructor
	.DESCRIPTION
		Specify the log level name, log level value, and log level display name
	.PARAMETER levelName
		Set the textual representation of the log level
	.PARAMETER level
		Set the numerical log level, where a higher value indicates greater importance
	.PARAMETER displayName
		Set the display name of the log level, which can be freely named and different from the textual representation
	.NOTES
		- throws: [ArgumentException]
	#>
	Level ([string]$levelName, [int]$level, [string]$displayName) {
		#Init
		$this._Init($levelName, $level, $displayName)
	}
	
	<#
	.SYNOPSIS
		Constructor
	.DESCRIPTION
		Specify the log name and log level
	.PARAMETER levelName
		Set the textual representation of the log level
	.PARAMETER level
		Set the numerical log level, where a higher value indicates greater importance
	.NOTES
		- throws: [ArgumentException]
	#>
	Level ([string]$levelName, [int]$level) {
		#Init
		$this._Init($levelName, $level, $levelName)
	}
	
	<#
	.SYNOPSIS
		Public Method
	.DESCRIPTION
		Get the string name of this log level
	.OUTPUTS
		[string]
	#>
	[string] ToString () {
		return $this._levelName
	}
	
	<#
	.SYNOPSIS
		Public Method
	.DESCRIPTION
		Compare the numeric values of two log levels to determine if they are equal
	.PARAMETER obj
		Another log level object used for comparison
	.OUTPUTS
		[bool]
	.NOTES
		- throws: [ArgumentException]
	#>
	[bool] Equals ([Object]$obj) {
		#Check: Log level object
		if ($obj -isnot [Level]) {
			throw [ArgumentException]::new('The input value is not an instance of a log level')
		}
		return $this._levelValue -eq $obj._levelValue
	}
	
	<#
	.SYNOPSIS
		Public Method
	.DESCRIPTION
		Returns a hash code
	.OUTPUTS
		[int]
	#>
	[int] GetHashCode () {
		return $this._levelValue
	}
	
	<#
	.SYNOPSIS
		Public Method
	.DESCRIPTION
		Perform a comparison of the numerical values between two log level objects and indicate the relative relationship of their sizes
	.PARAMETER obj
		Another log level object used for comparison
	.OUTPUTS
		[int]
	.NOTES
		- throws: [ArgumentException]
	#>
	[int] CompareTo ([Object]$obj) {
		#Check: Log level object
		if ($obj -isnot [Level]) {
			throw [ArgumentException]::new('The input value is not an instance of a log level')
		}
		#Compare log level values
		if ($this._levelValue -gt $obj._levelValue) {
			return 1
		} elseif ($this._levelValue -eq $obj._levelValue) {
			return 0
		}
		return -1
	}
	
	<#
	.SYNOPSIS
		Private Method
	.DESCRIPTION
		Initialize the class and specify the log level name, log level value, and log level display name
	.PARAMETER levelName
		Set the textual representation of the log level
	.PARAMETER level
		Set the numerical log level, where a higher value indicates greater importance
	.PARAMETER displayName
		Set the display name of the log level, which can be freely named and different from the textual representation
	.NOTES
		- throws: [ArgumentException]
	#>
	hidden [void] _Init ([string]$levelName, [int]$level, [string]$displayName) {
		#Check: Log level name
		if ([string]::IsNullOrWhiteSpace($levelName)) {
			throw [ArgumentException]::new('Log level name cannot be empty')
		}
		#Check: Log level display name
		if ([string]::IsNullOrWhiteSpace($displayName)) {
			throw [ArgumentException]::new('Log level display name cannot be empty')
		}
		#Store the text in the system cache pool
		$this._levelName = [string]::Intern($levelName)
		#Set log level value
		$this._levelValue = $level
		#Set log level display name
		$this._levelDisplayName = $displayName
	}
}