$modelname "gm_millenium/train_track_a4"
$staticprop
$casttextureshadows
$origin 0 0 0 -90
$model mesh "train_track_a4.smd"
$surfaceprop "metal"
$cdmaterials "models/gm_millenium/"
$collisionmodel "train_track_a4_phys.smd"
{
	$automass
	$concave
	$remove2d
	$maxconvexpieces 1000000
}
$sequence ref "train_track_a4.smd"
