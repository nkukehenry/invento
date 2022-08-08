<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <!-- The above 3 meta tags *must* come first in the head; any other head content must come *after* these tags -->
    <title>Upload</title>
    <!-- Latest compiled and minified CSS -->

</head>

<body>


    <div class="row">
        <div class="col-sm-12 col-md-12">
            <div class="panel panel-bd lobidrag">
                <div class="panel-heading">
                    <div class="panel-title">
                        <h4><?php echo (!empty($title) ? $title : null) ?></h4>
                    </div>
                </div>
                <div class="panel-body">

                    <form action="<?php echo base_url()?>Upload/Upload/in" method="post" enctype="multipart/form-data">
                 
                    <div class="form-group row">
                        <label for="store_name" class="col-sm-3 col-form-label">File*</label>
                        <div class="col-sm-9">
                            <input name="file" class="form-control" type="file" placeholder="Employee CSV" required>
                        </div>
                    </div>



                    <div class="form-group text-right">
                        <button type="reset" class="btn btn-primary w-md m-b-5"><?php echo display('reset') ?></button>
                        <button type="submit" class="btn btn-success w-md m-b-5"><?php echo display('save') ?></button>
                    </div>
                    <?php echo form_close() ?>

                </div>
            </div>
        </div>
    </div>

</body>

</html>