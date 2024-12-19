$modelname "gm_millenium/light_corridor"
$staticprop
$casttextureshadows
$origin 0 0 0 -90
$model mesh "light_corridor.smd"
$surfaceprop "metal"
$cdmaterials "models/gm_millenium/lights"
$cdmaterials "models/gm_millenium"
$collisionmodel "light_corridor_phys.smd"
{
	$mass 1
	$concave
	$remove2d
	$maxconvexpieces 1000000
}
$sequence ref "light_corridor.smd"
