$modelname "gm_millenium/train_track_a6"
$staticprop
$casttextureshadows
$origin 0 0 0 -90
$model mesh "train_track_a6.smd"
$cdmaterials "models/gm_millenium"
$collisionmodel "train_track_a6_phys.smd"
{
	$mass 1
	$concave
	$remove2d
	$maxconvexpieces 1000000
}
$sequence ref "train_track_a6.smd"
