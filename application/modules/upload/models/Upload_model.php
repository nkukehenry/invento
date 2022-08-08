<?php defined('BASEPATH') or exit('No direct script access allowed');

class Upload_model extends CI_Model
{

	private $table = "customer";


	public function upload_data($data)
	{
		return $this->db->insert($this->table, $data);
	}
}
