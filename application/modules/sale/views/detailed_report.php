<div class="row">
    <div class="col-sm-12 col-md-12">
        <div class="panel panel-bd lobidrag">
            <div class="panel-heading">
                <div class="panel-title">
                    
               
                </div>
            </div>
            <div class="panel-body">
                    <form  style="margin-bottom: 50px" action="<?=base_url('sale/sale/detailed')?>" method="post">

                     <div class="row" style="margin-bottom: 10px">

                        <div class="col-md-3">
                            <label>From Date:</label>
                            <input type="text" value="<?=$search->from_date?>" class="datepicker form-control" name="from_date">
                        </div>

                        <div class="col-md-3">
                            <label>To Date:</label>
                            <input type="text"  value="<?=$search->to_date?>" class="datepicker  form-control" name="to_date">
                        </div>


                        <div class="col-md-3">
                            <label>Receipt Number:</label>
                            <input type="text"  value="<?=$search->receipt?>" class=" form-control" name="receipt">
                        </div>


                        <div class="col-md-3">
                            <label>Customer Gender:</label>
                            <select class=" form-control" name="gender">> 
                                <option value="">All</option>
                                <option value="MALE" <?=($search->gender=="MALE")?"selected":""?> >MALE</option>
                                <option value="FEMALE" <?=($search->gender=="FEMALE")?"selected":""?> >FEMALE</option>
                            </select>
                        </div>


                      </div>

                      <div class="row" style="margin-bottom: 10px">

                        <div class="col-md-3">
                            <label>Customer Rank:</label>
                            <select class=" form-control" name="rank">> 
                                <option value="">All</option>
                                 <?php foreach ($ranks as $rank) :
                                $srank = $search->rank; ?>
                                <option value="<?php echo $rank->force_rank; ?>" <?php if ($srank == $rank->force_rank) {
                                                                                echo "selected";
                                   } ?>><?php echo $rank->force_rank; ?></option>
                            <?php endforeach; ?>
                            </select>
                        </div>

                        <div class="col-md-3">
                            <label>Customer Unit:</label>
                            <select class=" form-control" name="unit">> 
                                <option value="">All</option>

                                 <?php foreach ($units as $rank) :

                                     $srank = $search->unit; ?>

                                    <option value="<?php echo $rank->unit; ?>" 
                                    <?php if ($srank == $rank->unit) { echo "selected";} ?>>
                                    <?php echo $rank->unit; ?>
                                    </option>
                            <?php endforeach; ?>
                            </select>
                        </div>



                        <div class="col-md-3">
                            <label>Store:</label>
                            <select class=" form-control" name="store_id">> 
                                <option value="">SELECT</option>
                                <?php foreach ($stores as $store) :

                                     $thisstore = $search->store_id; ?>

                                    <option value="<?php echo $store->store_id; ?>" 
                                    <?php if ($thisstore == $store->store_id) { echo "selected";} ?>>
                                    <?php echo $store->store_name; ?>
                                    </option>
                            <?php endforeach; ?>
                            </select>
                        </div>

                        <div class="col-md-3">
                            <br>
                            <input type="submit" name="submit" value="Apply filter" class="btn btn-success">
                        </div>


                     </div>
                        
                    </form>


 
                <div class="">
                    <table class=" table table-bordered table-hover">
                        <thead>
                            <tr>
                                <th><?php echo display('sl_no') ?></th>
                                <th><?php echo display('date') ?></th>
                                <th><?php echo display('invoice_no') ?></th>
                                <th>Pay Slip</th>
                                <th>Destination</th>
                                 <th>Customer</th>
                                <th><?php echo display('total') ?></th>
                                <th><?php echo display('action') ?></th> 
                            </tr>
                        </thead>
                        <tbody>
                            <?php if (!empty($sales)) ?>
                            <?php $sl = 1; ?>
                            <?php foreach ($sales as $sales) {

                            $customer = get_customer($sales->customer_id);

                             ?>
                            <tr>
                                <td><?php echo $sl++; ?></td>
                                <td><?php echo $sales->sales_date; ?></td>
                                <td><?php echo $sales->invoice_no; ?></td>
                                <td><?php echo $sales->pay_slip_no; ?></td>
                                <td><?php echo $sales->destination; ?></td>
                                <td><?php echo $customer->customer_name; ?></td>
                                
                                <td>UGX <?php echo number_format($sales->total_amnt); ?></td>
                                <td>
                                <?php if($this->permission->method('sale','read')->access()): ?>
                                    <a href="<?php echo base_url("sale/sale/view/$sales->sale_id") ?>" class="btn btn-success btn-sm" data-toggle="tooltip" data-placement="left" title="View"><i class="fa fa-eye" aria-hidden="true"></i></a>
                                <?php endif; ?>
                                <?php if($this->permission->method('sale','delete')->access()): ?>
                                    <a href="<?php echo base_url("sale/sale/delete/$sales->sale_id") ?>" onclick="return confirm('<?php echo display("are_you_sure") ?>')" class="btn btn-danger btn-sm" data-toggle="tooltip" data-placement="right" title="Delete "><i class="fa fa-trash-o" aria-hidden="true"></i></a>
                                <?php endif; ?>
                                 <?php /* if($this->permission->method('sale','update')->access()): ?>
                                   
                                   
                                    <a href="<?php echo base_url("sale/sale/sales_up_form/$sales->sale_id") ?>"  class="btn btn-info btn-sm"  title="Update "><i class="fa fa-edit" aria-hidden="true"></i></a>
                                <?php endif;*/ ?>
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

 