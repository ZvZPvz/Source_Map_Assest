$modelname "props/ba/fun/SR_small"
$staticprop
$origin 0 0 0 -90
$model mesh "SR_small.smd"
$surfaceprop "paper"
$cdmaterials "models/ba/fun"
$collisionmodel "SR_small_phys.smd"
{
	$mass 1
	$remove2d
	$maxconvexpieces 1000000
}
$sequence ref "SR_small.smd"
