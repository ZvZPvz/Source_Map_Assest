$modelname "props/ba/fun/R_small"
$staticprop
$origin 0 0 0 -90
$model mesh "R_small.smd"
$surfaceprop "paper"
$cdmaterials "models/ba/fun"
$collisionmodel "R_small_phys.smd"
{
	$mass 1
	$remove2d
	$maxconvexpieces 1000000
}
$sequence ref "R_small.smd"
