$modelname "gm_millenium/data_base_tower"
$staticprop
$casttextureshadows
$origin 0 0 0 -90
$model mesh "data_base_tower.smd"
$surfaceprop "metal"
$cdmaterials "models/gm_millenium"
$collisionmodel "data_base_tower_phys.smd"
{
	$mass 1
	$concave
	$remove2d
	$maxconvexpieces 1000000
}
$sequence ref "data_base_tower.smd"
