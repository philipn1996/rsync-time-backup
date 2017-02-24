<?php
##CONFIG
$ROUTER_ADDRESS="localhost"
$ROUTER_PORT=2222

$NAS_ADDRESS="localhost"
$NAS_PORT=2223
##

$success="<p style='color:green'>";
$error="<p style='color:red'>";
$closing="</p>";

$connection=ssh2_connect($ROUTER_ADDRESS, $ROUTER_PORT);
$state=ssh2_fingerprint($connection);
if($state) echo "$success Router online: $state";
else echo "$error Router offline!";
echo $closing;
#echo "</br>";

$connection=ssh2_connect($NAS_ADDRESS, $NAS_PORT);
$state=ssh2_fingerprint($connection);
if($state) echo "$success NAS online: $state";
else echo "$error NAS offline!";
echo $closing;
#echo "</br>";

?>
