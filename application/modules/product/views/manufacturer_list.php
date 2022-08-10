<div class="row">
    <div class="col-sm-12 col-md-12">
        <div class="panel panel-bd lobidrag">
            <div class="panel-heading">
                <div class="panel-title">
                    <h4> 
                        <a href="<?php echo base_url('product/product/manufacturer_form') ?>" class="btn btn-sm btn-info" title="Add"><i class="fa fa-plus"></i> <?php echo display('add') ?></a>  
                    </h4>
                </div>
            </div>
            <div class="panel-body">
 
                <div class="">
                    <table class="datatable2 table table-bordered table-hover">
                        <thead>
                            <tr>
                                <th><?php echo display('sl_no') ?></th>
                                <th>Manufacturer</th>
                                <th><?php echo display('isactive') ?></th>
                                <th><?php echo display('action') ?></th> 
                            </tr>
                        </thead>
                        <tbody>
                            <?php if (!empty($manufacturers)) ?>
                            <?php $sl = 1; ?>
                            <?php foreach ($manufacturers as $manufacturer) { ?>
                            <tr>
                                <td><?php echo $sl++; ?></td>
                                <td><?php echo $manufacturer->manufacturer_name; ?></td>
                                <td><?php echo (($manufacturer->isactive==1)?display('active'):display('inactive')); ?></td>
                                <td>
                                    <a href="<?php echo base_url("product/product/delete_manufacturer/$manufacturer->id") ?>" onclick="return confirm('<?php echo display("are_you_sure") ?>')" class="btn btn-danger btn-sm" data-toggle="tooltip" data-placement="right" title="Delete "><i class="fa fa-trash-o" aria-hidden="true"></i></a>
                              
                                    <a href="<?php echo base_url("product/product/manufacturer_form/$manufacturer->id") ?>"  class="btn btn-info btn-sm" data-toggle="tooltip" data-placement="right" title="Edit "><i class="fa fa-edit" aria-hidden="true"></i></a>
                                </td>
                            </tr>
                            <?php } ?> 
                        </tbody>
                    </table>
                    <?= $links ?>
                </div>
            </div> 
        </div>
    </div>
</div>

 