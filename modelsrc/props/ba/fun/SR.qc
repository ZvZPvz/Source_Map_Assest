$modelname "props/ba/fun/SR"
$staticprop
$origin 0 0 0 -90
$model mesh "SR.smd"
$surfaceprop "paper"
$cdmaterials "models/ba/fun"
$collisionmodel "SR_phys.smd"
{
	$mass 10
	$remove2d
	$maxconvexpieces 1000000
}
$sequence ref "SR.smd"
