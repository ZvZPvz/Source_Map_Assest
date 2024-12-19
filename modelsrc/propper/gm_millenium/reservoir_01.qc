$modelname "gm_millenium/reservoir_01"
$staticprop
$origin 0 0 0 -90
$model mesh "reservoir_01.smd"
$surfaceprop "glass"
$cdmaterials "models/gm_millenium/"
$collisionmodel "reservoir_01_phys.smd"
{
	$automass
	$concave
	$remove2d
	$maxconvexpieces 1000000
}
$sequence ref "reservoir_01.smd"
