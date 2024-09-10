$modelname "gm_millenium/pool_ground"
$staticprop
$casttextureshadows
$origin 0 0 0 -90
$model mesh "pool_ground.smd"
$surfaceprop "plaster"
$cdmaterials "models/gm_millenium/"
$collisionmodel "pool_ground_phys.smd"
{
	$automass
	$concave
	$remove2d
	$maxconvexpieces 1000000
}
$sequence ref "pool_ground.smd"
