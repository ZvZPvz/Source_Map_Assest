$modelname "gm_millenium/reservoir_02"
$staticprop
$casttextureshadows
$origin 0 0 0 -90
$model mesh "reservoir_02.smd"
$surfaceprop "metal"
$cdmaterials "models/gm_millenium/"
$collisionmodel "reservoir_02_phys.smd"
{
	$automass
	$concave
	$remove2d
	$maxconvexpieces 1000000
}
$sequence ref "reservoir_02.smd"
