$modelname "props/ba/fun/SSR_small"
$staticprop
$origin 0 0 0 -90
$model mesh "SSR_small.smd"
$surfaceprop "paper"
$cdmaterials "models/ba/fun"
$collisionmodel "SSR_small_phys.smd"
{
	$mass 1
	$remove2d
	$maxconvexpieces 1000000
}
$sequence ref "SSR_small.smd"
