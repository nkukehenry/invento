<?php
defined('BASEPATH') or exit('No direct script access allowed');

class Upload extends MX_Controller
{

	public function __construct()
	{
		parent::__construct();

		$this->load->model(array(
			'upload_model'
		));
	}

	public function index()
	{
		if ($this->input->post('file')) {
			$file = $_FILES['file']['tmp_name'];
			$handle = fopen($file, "r");
			$c = 0; //
			while (($filesop = fgetcsv($handle, 1000, ",")) !== false) {
				//insert array
				$data = array(
					"customer_code" => $filesop[0],
					"force_rank" => $filesop[1],
					"customer_name" => $filesop[2],
					"customer_phone" => $filesop[3],
					"unit" => $filesop[4],
					"customer_address" => $filesop[5],
					"created_by" => $this->session->userdata('id'),
					"isactive" => 1,


				);

				if ($c <> 0) {
					//SKIP THE FIRST ROW
					$this->Upload_model->upload_data($data);
				}
				$c = $c + 1;
			}
			$data['message'] = "Sucessfully import data !";
		}

		$data['module'] = "upload";
		$data['page']   = "form";
		echo Modules::run('template/layout', $data);
	}
}
