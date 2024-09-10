$modelname "gm_millenium/pool_frame2"
$staticprop
$casttextureshadows
$origin 0 0 0 -90
$model mesh "pool_frame2.smd"
$surfaceprop "plaster"
$cdmaterials "models/gm_millenium/"
$collisionmodel "pool_frame2_phys.smd"
{
	$automass
	$concave
	$remove2d
	$maxconvexpieces 1000000
}
$sequence ref "pool_frame2.smd"
