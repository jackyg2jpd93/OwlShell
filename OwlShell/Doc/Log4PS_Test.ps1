using module "D:\OwlAuto\OwlShell\Packages\Log4PS\Log4PS.psm1"
$m = [Log4PS]::new()
$l = $m.Core.Level::new('error', 50)