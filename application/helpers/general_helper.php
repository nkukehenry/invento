<?php
if (!defined('BASEPATH')) exit('No direct script access allowed');
//http://stackoverflow.com/questions/22441026/php-array-to-jstree
function array2jstree($ar)
{
    $out = '';
    foreach ($ar as $k => $v) {
        $out .= "<li>$k";
        if (is_array($v)) {
            $out .= array2jstree($v);
        } else {
            $out .= "<ul><li class=\"jstree-nochildren\">$v</li></ul>";
        }
        $out .= '</li>';
    }
    return "<ul>$out</ul>";
}
//http://stackoverflow.com/questions/22689364/multi-dimensional-array-php-codeigniter/22689902#22689902
function tree_from_rows($rows)
{
    $tree = array();
    foreach ($rows as $row) {
        $ref = & $tree;
        foreach ($row as $value) {
            if (!empty($value)) {
                if (!array_key_exists($value, $ref)) {
                    $ref[$value] = array();
                }
                $ref = & $ref[$value];
            }
        }
    }
    return $tree;
}

function dd($data){

    print_r($data);
    exit();
    
}

function get_category($category_id){

 $CI =& get_instance();
 $CI->db->where('category_id',$category_id);
 return $CI->db->get('product_category')->row();
 
}

function get_customer($id){

 $CI =& get_instance();
 $CI->db->where('customer_id',$id);
 return $CI->db->get('customer')->row();
}