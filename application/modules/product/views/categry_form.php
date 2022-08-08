<div class="row">
    <div class="col-sm-12 col-md-12">
        <div class="panel panel-bd lobidrag">
            <div class="panel-heading">
                <div class="panel-title">
                    <h4>
                        <a href="<?php echo base_url('product/product/category_index') ?>" class="btn btn-sm btn-success" title="List"> <i class="fa fa-list"></i> <?php echo display('list') ?></a> 
                        <?php if($categorys->category_id): ?>
                        <a href="<?php echo base_url('product/product/categry_form') ?>" class="btn btn-sm btn-info" title="Add"><i class="fa fa-plus"></i> <?php echo display('add') ?></a> 
                        <?php endif; ?>
                    </h4>
                </div>
            </div>
            <div class="panel-body">

                <?= form_open_multipart('product/product/categry_form') ?>
                    <?php echo form_hidden('category_id', $categorys->category_id) ?>
                    <div class="form-group row">
                        <label for="category_name" class="col-sm-3 col-form-label"><?php echo display('category_name') ?> *</label>
                        <div class="col-sm-9">
                                    <input name="category_name" class="form-control" type="text" placeholder="<?php echo display('category_name') ?>" id="category_name" value="<?php echo $categorys->category_name; ?>">
                        </div>
                    </div>

                     <div class="form-group row">
                        <label for="category_name" class="col-sm-3 col-form-label">Brand Label *</label>
                        <div class="col-sm-9">
                                <input name="brand_label" class="form-control" type="text" placeholder="Model label"  value="<?php echo $categorys->brand_label; ?>">
                        </div>
                    </div>

                    <div class="form-group row">
                        <label for="category_name" class="col-sm-3 col-form-label">Model label *</label>
                        <div class="col-sm-9">
                                <input name="model_label" class="form-control" type="text" placeholder="Model label"  value="<?php echo $categorys->model_label; ?>">
                        </div>
                    </div>

                    <div class="form-group row">
                        <label for="uses_color" class="col-sm-3 col-form-label">Uses Colors*</label>
                        <div class="col-sm-9">
                                <select name="uses_color" id="uses_color" class="form-control">
                                    <option <?=($cat->uses_color = 0)?'selected':''?>value="0">No</option>
                                    <option <?=($cat->uses_color = 1)?'selected':''?> value="1">Yes</option>
                                </select>
                        </div>
                    </div>

                    <div class="form-group row">
                        <label for="uses_color" class="col-sm-3 col-form-label">Parent Category</label>
                        <div class="col-sm-9">
                                <select name="parent_category_id" id="uses_color" class="form-control">
                                    <option value="0" selected="selected">None</option>
                                    <?php 
                                    foreach ($all_categorys as $cat):
                                        if($cat->parent_category_id !== $categorys->parent_category_id):
                                     ?>
                                        <option <?=($cat->category_id = $categorys->parent_category_id)?'selected="selected"':''?> value="<?=$cat->category_id?>"><?=$cat->category_name?></option>

                                    <?php 

                                        endif;
                                        endforeach;
                                     ?>
                                </select>
                        </div>
                    </div>
         
                    <div class="form-group text-right">
                        <button type="submit" class="btn btn-success w-md m-b-5"><?php echo display('save') ?></button>
                    </div>
                <?php echo form_close() ?>

            </div>  
        </div>
    </div>
</div>