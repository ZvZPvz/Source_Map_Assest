$modelname "gm_millenium/ground_frame_edge128x64"
$staticprop
$casttextureshadows
$origin 0 0 0 -90
$model mesh "ground_frame_edge128x64.smd"
$surfaceprop "plaster"
$cdmaterials "models/gm_millenium/"
$collisionmodel "ground_frame_edge128x64_phys.smd"
{
	$automass
	$concave
	$remove2d
	$maxconvexpieces 1000000
}
$sequence ref "ground_frame_edge128x64.smd"
