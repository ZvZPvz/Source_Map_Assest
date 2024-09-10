$modelname "gm_millenium/water_frame"
$staticprop
$casttextureshadows
$origin 0 0 0 -90
$model mesh "water_frame.smd"
$surfaceprop "metal"
$cdmaterials "models/gm_millenium/"
$collisionmodel "water_frame_phys.smd"
{
	$automass
	$concave
	$remove2d
	$maxconvexpieces 1000000
}
$sequence ref "water_frame.smd"
