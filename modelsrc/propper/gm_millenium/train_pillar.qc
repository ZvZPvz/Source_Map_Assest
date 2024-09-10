$modelname "gm_millenium/train_pillar"
$staticprop
$casttextureshadows
$origin 0 0 0 -90
$model mesh "train_pillar.smd"
$surfaceprop "plaster"
$cdmaterials "models/gm_millenium/"
$collisionmodel "train_pillar_phys.smd"
{
	$automass
	$concave
	$remove2d
	$maxconvexpieces 1000000
}
$sequence ref "train_pillar.smd"
