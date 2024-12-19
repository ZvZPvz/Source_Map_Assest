$modelname "gm_millenium/light_01"
$staticprop
$casttextureshadows
$origin 0 0 0 -90
$model mesh "light_01.smd"
$surfaceprop "metal"
$cdmaterials "models/gm_millenium/lights"
$cdmaterials "models/gm_millenium"
$collisionmodel "light_01.smd"
{
	$automass
	$concave
	$remove2d
	$maxconvexpieces 1000000
}
$sequence ref "light_01.smd"
