class B {
	static [void] StaticMethod () {
		Write-Host -Object "B-Static"
	}
	
	[void] Method () {
		Write-Host -Object "Method"
	}
}