$modelname "props/ba/fun/SSR"
$staticprop
$origin 0 0 0 -90
$model mesh "SSR.smd"
$surfaceprop "paper"
$cdmaterials "models/ba/fun"
$collisionmodel "SSR_phys.smd"
{
	$mass 10
	$remove2d
	$maxconvexpieces 1000000
}
$sequence ref "SSR.smd"
