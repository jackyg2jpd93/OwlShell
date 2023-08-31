using namespace System.Management.Automation
using namespace System.IO

<#
*@Title：Log4PS
*@Description：Universal log recording module
*@Author：OwlAuto
*@Since：2023/08/01
#>
[Flags()] enum LogPolicy {
    <#
    *Log operation policy enumeration
    #>
    #Allow log writing to file
    File    = 1
    #Allow log display on console
    Console = 2
    #Allow log sending to custom handler
    Custom  = 4
}

class LogLevel {
    <#
    *Log level class
    #>
    #Log level identifier (FATAL)
    static [hashtable]$fatal = @{
        "int"   = 50;
        "str"   = "FATAL";
        "color" = @{
            "ForegroundColor" = [ConsoleColor]::White;
            "BackgroundColor" = [ConsoleColor]::Red;
        };
    }
    #Log level identifier (ERROR)
    static [hashtable]$error = @{
        "int"   = 40;
        "str"   = "ERROR";
        "color" = @{
            "ForegroundColor" = [ConsoleColor]::Red;
        };
    }
    #Log level identifier (WARN)
    static [hashtable]$warn = @{
        "int"   = 30;
        "str"   = "WARN";
        "color" = @{
            "ForegroundColor" = [ConsoleColor]::Yellow;
        };
    }
    #Log level identifier (INFO)
    static [hashtable]$info = @{
        "int"   = 20;
        "str"   = "INFO";
        "color" = @{
            "ForegroundColor" = [ConsoleColor]::Cyan;
        };
    }
    #Log level identifier (TRACE)
    static [hashtable]$trace = @{
        "int"   = 10;
        "str"   = "TRACE";
        "color" = @{
            "ForegroundColor" = [ConsoleColor]::DarkGray;
        };
    }
    
    static [void] GetColorExample() {
        <#
        *Log level color example
        #>
        #Construct a test message hash table
        [hashtable]$fatalHash = [LogLevel]::fatal.color
        [hashtable]$errorHash = [LogLevel]::error.color
        [hashtable]$warnHash = [LogLevel]::warn.color
        [hashtable]$infoHash = [LogLevel]::info.color
        [hashtable]$traceHash = [LogLevel]::trace.color
        #Print message
        Write-Host -Object "yyyy/MM/dd HH:mm:ss - [Fatal] - Hello World~!!!!!" @fatalHash
        Write-Host -Object "yyyy/MM/dd HH:mm:ss - [Error] - Hello World~!!!!!" @errorHash
        Write-Host -Object "yyyy/MM/dd HH:mm:ss - [Warn ] - Hello World~!!!!!" @warnHash
        Write-Host -Object "yyyy/MM/dd HH:mm:ss - [Info ] - Hello World~!!!!!" @infoHash
        Write-Host -Object "yyyy/MM/dd HH:mm:ss - [Trace] - Hello World~!!!!!" @traceHash
    }
}

class LogManager {
    <#
    *Log management class
    #>
    #System log level
    hidden [hashtable]$logLevel = [LogLevel]::trace
    #Log file name
    hidden [string]$fileName = [datetime]::Now.ToString("yyyy_MM_dd") + "_ExecutionLog.log"
    #Log file path
    hidden [string]$logPath = $PSScriptRoot
    #Log date format
    hidden [string]$dateFormat = "yyyy/MM/dd HH:mm:ss"
    #Custom handler
    hidden [PSMethod]$customHandler
    #Log operation policy
    hidden [LogPolicy]$logPolicy = [LogPolicy]::File + [LogPolicy]::Console
    
    LogManager () {
        <#
        *Constructor
        #>
    }
    
    LogManager ([string]$logPath) {
        <#
        *Constructor
        *Specify log file path
        *@param [string] $logPath
        *@throws [ArgumentException]
        #>
        #Set log file path
        $this.SetLogFilePath($logPath)
    }
    
    LogManager ([string]$logPath, [hashtable]$logLevel) {
        <#
        *Constructor
        *Specify log file path, System log level
        *@param [string] $logPath
        *@param [hashtable] $logLevel
        *@throws [ArgumentException]
        #>
        #Set log file path
        $this.SetLogFilePath($logPath)
        #Set system log level
        $this.SetSysLogLevel($logLevel)
    }
    
    LogManager ([string]$logPath, [string]$logLevel) {
        <#
        *Constructor
        *Specify log file path, System log level
        *@param [string] $logPath
        *@param [string] $logLevel
        *@throws [ArgumentException]
        #>
        #Set log file path
        $this.SetLogFilePath($logPath)
        #Set system log level
        $this.SetSysLogLevel($logLevel)
    }
    
    [hashtable] GetSysLogLevel () {
        <#
        *Get system log level
        *@return [hashtable]
        #>
        return $this.logLevel
    }
    
    [string] GetLogFileName () {
        <#
        *Get log file name
        *@return [string]
        #>
        return $this.fileName
    }
    
    [string] GetLogFilePath () {
        <#
        *Get log file path
        *@return [string]
        #>
        return $this.logPath
    }
    
    [string] GetDateFormat () {
        <#
        *Get log date format
        *@return [string]
        #>
        return $this.dateFormat
    }
    
    [PSMethod] GetCustomHandler () {
        <#
        *Get custom handler
        *@return [PSMethod]
        #>
        return $this.customHandler
    }
    
    [LogPolicy] GetLogPolicy () {
        <#
        *Get log operation policy
        *@return [LogPolicy]
        #>
        return $this.logPolicy
    }
    
    [void] SetSysLogLevel ([hashtable]$logLevel) {
        <#
        *Set system log level
        *@param [hashtable] $logLevel
        *@throws [ArgumentException]
        #>
        #Check: Log level
        if (!$logLevel) {
            throw [ArgumentException]::new("Log level input error")
        }
        #Set
        $this.logLevel = $logLevel
    }
    
    [void] SetSysLogLevel ([string]$logLevel) {
        <#
        *Set system log level
        *@param [string] $logLevel
        *@throws [ArgumentException]
        #>
        #Get log level
        [hashtable]$level = [LogLevel]::$logLevel
        #Set system log level
        $this.SetSysLogLevel($level)
    }
    
    [void] SetLogFileName ([string]$fileName) {
        <#
        *Set log file name
        *@param [string] $fileName
        *@throws [ArgumentException]
        #>
        #Check: File name
        if ([string]::IsNullOrWhiteSpace($fileName)) {
            throw [ArgumentException]::new("File name cannot be empty")
        }
        #Set
        $this.fileName = $fileName
    }
    
    [void] SetLogFilePath ([string]$logPath) {
        <#
        *Set log file path
        *@param [string] $logPath
        *@throws [ArgumentException]
        #>
        #Check: File path
        if ([string]::IsNullOrWhiteSpace($logPath)) {
            throw [ArgumentException]::new("File path cannot be empty")
        }
        #Set
        $this.logPath = $logPath
    }
    
    [void] SetDateFormat ([string]$format) {
        <#
        *Set log date format
        *@param [string] $format
        *@throws [ArgumentException]
        #>
        #Check: Date format
        if ([string]::IsNullOrWhiteSpace($format)) {
            throw [ArgumentException]::new("Date format cannot be empty")
        }
        #Set
        $this.dateFormat = $format
    }
    
    [void] SetCustomHandler ([PSMethod]$customHandler) {
        <#
        *Set custom handler
        *@param [PSMethod] $customHandler
        *@throws [ArgumentException]
        #>
        #Check: Custom handler
        if (!$customHandler) {
            throw [ArgumentException]::new("Custom handler cannot be empty")
        }
        #Set
        $this.customHandler = $customHandler
    }
    
    [void] SetLogPolicy ([LogPolicy]$logPolicy) {
        <#
        *Set log operation policy
        *@param [LogPolicy] $logPolicy
        *@throws [ArgumentException]
        #>
        #Check: Operation policy
        if (!$logPolicy) {
            throw [ArgumentException]::new("Operation policy cannot be empty")
        }
        #Set
        $this.logPolicy = $logPolicy
    }
}

class Logger {
    <#
    *Log handler class
    #>
    #Log management instance
    hidden [LogManager]$logMgr
    #System log level (numeric)
    hidden [int]$sysLogIntLevel
    #Log file name
    hidden [string]$fileName
    #Log file path
    hidden [string]$logPath
    #Log date format
    hidden [string]$dateFormat
    #Custom handler
    hidden [PSMethod]$customHandler
    #Log operation policy
    hidden [LogPolicy]$logPolicy
    #Full file path
    hidden [string]$logFullPath
    
    Logger () {
        <#
        *Constructor
        #>
        #Set log management instance
        $this.logMgr = [LogManager]::new()
        #Initialize log handler class
        $this.InitLogger()
    }
    
    Logger ([LogManager]$logMgr) {
        <#
        *Constructor
        *Specify log management instanc
        *@param [LogManager] $logMgr
        *@throws [ArgumentException]
        #>
        #Check: Log management instance
        if (!$logMgr) {
            throw [ArgumentException]::new("Log management instance cannot be empty")
        }
        #Set log management instance
        $this.logMgr = $logMgr
        #Initialize log handler class
        $this.InitLogger()
    }
    
    [void] Log ([hashtable]$logLevel, [string]$msg) {
        <#
        *Log the message
        *@param [hashtable] $logLevel
        *@param [string] $msg
        *@throws [ArgumentException]
        #>
        #Check: Log level
        if (!$logLevel) {
            throw [ArgumentException]::new("Log level input error")
        }
        #Check: Log display
        if ($this.sysLogIntLevel -gt $logLevel.int) {
            return
        }
        #Construct log message
        [string]$text = @(
            [datetime]::Now.ToString($this.dateFormat),
            ("[" + $logLevel.str.PadRight(5, " ") + "]"),
            $msg
        ) -join " - "
        #Check: Allow log display on console
        if ($this.logPolicy.HasFlag([LogPolicy]::Console)) {
            #Get color settings
            [hashtable]$colorHash = $logLevel.color
            #Display on console
            Write-Host -Object $text @colorHash
        }
        #Check: Allow log writing to file
        if ($this.logPolicy.HasFlag([LogPolicy]::File)) {
            #Write to file
            Add-Content -Path $this.logFullPath -Value $text -Encoding "UTF8"
        }
        #Check: Allow log sending to custom handler
        if ($this.logPolicy.HasFlag([LogPolicy]::Custom)) {
            $this.customHandler.Invoke($text)
        }
    }
    
    [void] Fatal ([string]$msg) {
        <#
        *Log the message (Fatal)
        *@param [string] $msg
        #>
        $this.Log([LogLevel]::fatal, $msg)
    }
    
    [void] Error ([string]$msg) {
        <#
        *Log the message (Error)
        *@param [string] $msg
        #>
        $this.Log([LogLevel]::error, $msg)
    }
    
    [void] Warn ([string]$msg) {
        <#
        *Log the message (Warn)
        *@param [string] $msg
        #>
        $this.Log([LogLevel]::warn, $msg)
    }
    
    [void] Info ([string]$msg) {
        <#
        *Log the message (Info)
        *@param [string] $msg
        #>
        $this.Log([LogLevel]::info, $msg)
    }
    
    [void] Trace ([string]$msg) {
        <#
        *Log the message (Trace)
        *@param [string] $msg
        #>
        $this.Log([LogLevel]::trace, $msg)
    }
    
    hidden [void] InitLogger () {
        <#
        *Initialize log handler class
        #>
        #Get system log level
        $this.sysLogIntLevel = $this.logMgr.GetSysLogLevel().int
        #Get log file name
        $this.fileName = $this.logMgr.GetLogFileName()
        #Get log file path
        $this.logPath = $this.logMgr.GetLogFilePath()
        #Get log date format
        $this.dateFormat = $this.logMgr.GetDateFormat()
        #Get custom handler
        $this.customHandler = $this.logMgr.GetCustomHandler()
        #Get log operation policy
        $this.logPolicy = $this.logMgr.GetLogPolicy()
        #Construct full file path
        $this.logFullPath = [Path]::Combine($this.logPath, $this.fileName)
    }
}