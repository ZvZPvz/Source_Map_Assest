$modelname "gm_millenium/chair_corridor"
$staticprop
$casttextureshadows
$origin 0 0 0 -90
$model mesh "chair_corridor.smd"
$surfaceprop "metal"
$cdmaterials "models/gm_millenium"
$collisionmodel "chair_corridor_phys.smd"
{
	$mass 88
	$concave
	$remove2d
	$maxconvexpieces 1000000
}
$sequence ref "chair_corridor.smd"
