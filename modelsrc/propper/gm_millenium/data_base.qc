$modelname "gm_millenium/data_base"
$staticprop
$casttextureshadows
$origin 0 0 0 -90
$model mesh "data_base.smd"
$surfaceprop "plaster"
$cdmaterials "models/gm_millenium"
$collisionmodel "data_base_phys.smd"
{
	$mass 1
	$concave
	$remove2d
	$maxconvexpieces 1000000
}
$sequence ref "data_base.smd"
