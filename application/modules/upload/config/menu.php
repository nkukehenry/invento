<?php

// module name
$HmvcMenu["Upload"] = array(
    //set icon
    "icon"           => "<i class='fa fa-users'></i>",

    //1st level menu name
    "upload_customers" => array(
        "controller" => "Upload",
        "method"     => "index",
        "permission" => "create"
    ),


);
