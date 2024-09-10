$modelname "gm_millenium/reservoir_03"
$staticprop
$casttextureshadows
$origin 0 0 0 -90
$model mesh "reservoir_03.smd"
$surfaceprop "metal"
$cdmaterials "models/gm_millenium/"
$collisionmodel "reservoir_03_phys.smd"
{
	$automass
	$concave
	$remove2d
	$maxconvexpieces 1000000
}
$sequence ref "reservoir_03.smd"
