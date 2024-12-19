$modelname "props/ba/fun/R"
$staticprop
$origin 0 0 0 -90
$model mesh "R.smd"
$surfaceprop "paper"
$cdmaterials "models/ba/fun"
$collisionmodel "R_phys.smd"
{
	$mass 10
	$remove2d
	$maxconvexpieces 1000000
}
$sequence ref "R.smd"
