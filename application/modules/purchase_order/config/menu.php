<?php

// module name
$HmvcMenu["purchase_order"] = array(
    //set icon
    "icon"           => "<i class='fa fa-list'></i>", 

    // purchase_order
 
        'new_purchase'    => array( 
            "controller" => "purchase_order",
            "method"     => "form",
            "permission" => "create"
        ), 
        'purchases_list'  => array( 
            "controller" => "purchase_order",
            "method"     => "index",
            "permission" => "read"
        ), 
        'previous_purchases'  => array( 
            "controller" => "purchase_order",
            "method"     => "receive_list",
            "permission" => "read"
        ), 
  
);
   

 