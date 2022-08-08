<div class="row">
    <div class="col-sm-12 col-md-12">
        <div class="panel panel-bd lobidrag">
            <div class="panel-heading">
                <div class="panel-title">
                    <h4>
                        <a href="<?php echo base_url('product/product/index') ?>" class="btn btn-sm btn-success" title="List"> <i class="fa fa-list"></i> <?php echo display('list') ?></a> 
                        <?php if($products->product_id): ?>
                        <a href="<?php echo base_url('product/product/form') ?>" class="btn btn-sm btn-info" title="Add"><i class="fa fa-plus"></i> <?php echo display('add') ?></a> 
                        <?php endif; ?>
                    </h4>
                </div>
            </div>
            <div class="panel-body">

                <?= form_open_multipart('product/product/form') ?>
                    <?php echo form_hidden('product_id', $products->product_id) ?>
                     <div class="form-group row">
                        <label for="product_code" class="col-sm-3 col-form-label"><?php echo display('product_code') ?> *</label>
                        <div class="col-sm-9">
                                    <input name="product_code" class="form-control" type="text" placeholder="<?php echo display('product_code') ?>" id="product_code" value="<?php if(empty($products->product_code)){
                                        echo $product_code;
                                    }else{
                                       echo $products->product_code; 
                                    } ?>" required>
                        </div>
                    </div>


                    <div class="form-group row">
                        <label for="product_name" class="col-sm-3 col-form-label"><?php echo display('product_name') ?> *</label>
                        <div class="col-sm-9">
                                    
                                    <textarea name="product_name" id="product_name" class="form-control"  readonly ><?php echo $products->product_name; ?></textarea>
                        </div>
                    </div> 
                    <!-- <div class="form-group row">
                        <label for="category_name" class="col-sm-3 col-form-label"><?php echo display('category_name') ?> *</label>
                        <div class="col-sm-9">
                                  
                                    <?php echo form_dropdown('category_name',$category,(!empty($products->category)?$products->category:null), 'class="form-control superSelect category"  ') ?>
                        </div>
                    </div>  -->


                     <div class="form-group row">
                        <label for="category_name" class="col-sm-3 col-form-label"><?php echo display('category_name') ?> *</label>
                        <div class="col-sm-9">
                            <select name="category_name" class="form-control category superSelect">
                                <option value="" selected="selected"></option>
                                <?php foreach ($categories as $cat): ?>
                                 <option value="<?=$cat->category_id?>" <?=($models->category_id==$cat->category_id)?"selected='selected'":""?>><?=$cat->category_name?></option>
                               <?php endforeach; ?>
                            </select>
                        </div>
                    </div> 
         
         
                     <div class="form-group row">
                        <label for="brand_name" class="col-sm-3 col-form-label brand_label"><?php echo display('brand_name') ?> *</label>
                        <div class="col-sm-9">
                                    <?php echo form_dropdown('brand_name',$brand,(!empty($products->brand)?$products->brand:null), 'class="form-control superSelect brand"  ') ?>
                        </div>
                    </div> 

                   <div class="form-group row">
                        <label for="model_name" class="col-sm-3 col-form-label model_label"><?php echo display('model_name') ?> *</label>
                        <div class="col-sm-9">
                                     <?php echo form_dropdown('model_name',$model,(!empty($products->model)?$products->model:null), 'class="form-control superSelect model" ') ?>
                        </div>
                    </div> 

                    <div class="form-group row">
                        <label for="color_name" class="col-sm-3 col-form-label"><?php echo display('color_name') ?> *</label>
                        <div class="col-sm-9">
                                     <?php echo form_dropdown('color_id',[],(!empty($products->color_id)?$products->color_id:null), 'class="form-control color superSelect"') ?>
                        </div>
                    </div> 
                   
                    
                     <div class="form-group row">
                        <label for="unit_name" class="col-sm-3 col-form-label"><?php echo display('um') ?> *</label>
                        <div class="col-sm-9">
                                     <?php echo form_dropdown('unit_name',$unit,(!empty($products->unit)?$products->unit:null), 'class="form-control unit"') ?>
                        </div>
                    </div> 
                     
                    <div class="form-group row">
                        <label for="product_details" class="col-sm-3 col-form-label"><?php echo display('product_details') ?> </label>
                        <div class="col-sm-9">
                                    <textarea name="product_details" class="form-control" type="text" placeholder="<?php echo display('product_details') ?>" id="product_detailse"><?php echo $products->product_details; ?></textarea>
                        </div>
                    </div> 
                 
                   <div class="form-group row">
                       
                        <div class="col-sm-9">
                                    <input name="purchase_price" class="form-control" type="hidden" placeholder="<?php echo display('purchase_price') ?>" id="purchase_price" value="<?php
                                    if(!empty($products->purchase_price)){
                                        echo $products->purchase_price;
                                    }else{
                                        echo 0;
                                    }

                                      ?>" >
                        </div>
                    </div> 
                    <div class="form-group row">
                        
                        <div class="col-sm-9">
                                    <input name="minimum_price" class="form-control" type="hidden" placeholder="<?php echo display('minimum_price') ?>" id="minimum_price" value="<?php 
                               if(!empty($products->minimum_price)){
                                echo $products->minimum_price;
                                } else{
                                    echo 0;
                                }
                            ?>" >
                        </div>
                    </div> 
                      <div class="form-group row">
                      
                        <div class="col-sm-9">
                                    <input name="retail_price" class="form-control" type="hidden" placeholder="<?php echo display('retail_price') ?>" id="retail_price" value="<?php
                                 if(!empty($products->retail_price)){
                                     echo $products->retail_price;
                                 }else{
                                    echo 0;
                                 }

                                     ?>" >
                        </div>
                    </div> 
                      <div class="form-group row">
                     
                        <div class="col-sm-9">
                                    <input name="block_price" class="form-control" type="hidden" placeholder="<?php echo display('block_price') ?>" id="block_price" value="<?php 
                                  if(!empty($products->block_price)){
                                     echo $products->block_price;
                                 }else{
                                    echo 0;
                                 }
                                    ?>" >
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

<script type="text/javascript">
 var selectedOptions = [];
     
function fillProductName(){

    $("select.superSelect").each(function(){
        var value = $(this).children("option").filter(":selected").text();


        var index = selectedOptions.indexOf($.trim(value),0)

        if($.trim(value) && $.trim(value)!=="Select Option" && $.trim(value)!=="N/A" && index== -1){
            selectedOptions.push(value);
        }

    });

    $("#product_name").html(selectedOptions.join('-'));

}


$("select.superSelect").change(function () { fillProductName(); });


 $("select.category").change(function(){

    const categoryId = this.value;

    console.log("ID:"+categoryId);

        //labels
     $.get(`<?=base_url()?>product/category_details/${categoryId}`, function(data, status){
        var item = JSON.parse(data);
         $('.model_label').html(item.model_label);
         $('.brand_label').html(item.brand_label);

     });

        //colors
     $.get(`<?=base_url()?>product/product_colors/${categoryId}`, function(data, status){

      console.log(data);

       var color_options ="";

       
        var colors = JSON.parse(data);

        if(colors.length == 0){
             color_options += "<option value='1' selected>N/A</option>";
          }

       colors.forEach(function(item){
            color_options += `<option value="${item.color_id}">${item.color_name}</option>`;
        });

      
        $('.color')
        .find('option')
        .remove()
        .end().append(color_options);

     });
        
        //models
     $.get(`<?=base_url()?>product/model_categories/${categoryId}`, function(data, status){
        
         var options = "";

         var jsondata =  JSON.parse(data);

        jsondata.forEach(function(item){
            options += `<option value="${item.model_id}">${item.model_name}</option>`;
        });

        if(jsondata.length == 0){
             options += "<option value='1' selected>N/A</option>";
          }

        console.log(options);

         $('.model')
        .find('option')
        .remove()
        .end().append(options);
     });

     //brands

     $.get(`<?=base_url()?>product/brand_categories/${categoryId}`, function(data, status){
        
        var options = "";

        var jsondata = JSON.parse(data)

        jsondata.forEach(function(item){
            options += `<option value="${item.brand_id}">${item.brand_name}</option>`;
        });

        if(jsondata.length == 0){
             options += "<option value='1' selected>N/A</option>";
          }

        console.log(options);

        $('.brand')
        .find('option')
        .remove()
        .end()
        .append(options);
     });

     //units
     $.get(`<?=base_url()?>product/unit_categories/${categoryId}`, function(data, status){
        
        var options = "";

        var jsondata = JSON.parse(data)

        jsondata.forEach(function(item){
            options += `<option value="${item.unit_id}">${item.unit_name}</option>`;
        });

        
        if(jsondata.length == 0){
             options += "<option value='1' selected>N/A</option>";
          }


         $('.unit')
        .find('option')
        .remove()
        .end().append(options);
     });


   fillProductName(); 


 });

</script>