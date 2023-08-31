using module ".\Core\B.psm1"

class A {
	[PSCustomObject]$Core = [PSCustomObject]@{
		"B" = [B];
	}
}