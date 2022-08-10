<div class="row">
    <div class="col-sm-12 col-md-12">
        <div class="panel panel-bd lobidrag">
         
            <div class="panel-body">

                <?= form_open_multipart('customer/customer/import') ?>
                    <?php echo form_hidden('id', $manufacturers->id) ?>
                    <div class="form-group row">
                        <label for="customers" class="col-sm-3 col-form-label">
                            Choose File *
                        </label>
                        <div class="col-sm-9">
                            <input name="file" class="form-control" type="file">
                            <span>File No. | Rank | Unit | Name | Phone </span>
                        </div>
                    </div>
         
                    <div class="form-group text-right">
                        <button type="submit" name="submit" class="btn btn-success w-md m-b-5">Import Data</button>
                    </div>
                <?php echo form_close() ?>

            </div>  
        </div>
    </div>
</div>