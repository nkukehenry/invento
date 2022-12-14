<div class="row">
    <div class="col-sm-12 col-md-12">
        <div class="panel panel-bd lobidrag">
            <div class="panel-heading">
                <div class="panel-title">
                    <h4>
                        <a href="<?php echo base_url('customer/customer/index') ?>" class="btn btn-sm btn-success" title="List"> <i class="fa fa-list"></i> <?php echo display('list') ?></a>
                        <?php if ($customers->customer_id) : ?>
                            <a href="<?php echo base_url('customer/customer/form') ?>" class="btn btn-sm btn-info" title="Add"><i class="fa fa-plus"></i> <?php echo display('add') ?></a>
                        <?php endif; ?>
                    </h4>
                </div>
            </div>
            <div class="panel-body">

                <?= form_open_multipart('customer/customer/form') ?>
                <?php echo form_hidden('customer_id', $customers->customer_id) ?>
                <div class="form-group row">
                    <label for="customer_code" class="col-sm-3 col-form-label">Force / File Number*</label>
                    <div class="col-sm-9">
                        <input name="customer_code" class="form-control" type="text" placeholder="File / Force Number" id="customer_code" value="<?php echo $customers->customer_code; ?>" required>
                        <span id="cus_code"></span>
                    </div>
                </div>

                <div class="form-group row">
                    <label for="name" class="col-sm-3 col-form-label">Rank*</label>
                    <div class="col-sm-9">
                        <select class="form-control" name="rank" required>
                            <?php foreach ($ranks as $rank) :
                                $srank = $rank->force_rank; ?>
                                <option value="<?php echo $rank->force_rank; ?>" <?php if ($srank == $rank->force_rank) {
                                                                                        echo "selected";
                                                                                    } ?>><?php echo $rank->force_rank; ?></option>
                            <?php endforeach; ?>
                        </select>

                    </div>
                </div>

                <div class="form-group row">
                    <label for="name" class="col-sm-3 col-form-label"><?php echo display('customer_name') ?> *</label>
                    <div class="col-sm-9">
                        <input name="name" class="form-control" type="text" placeholder="<?php echo display('name') ?>" id="name" value="<?php echo $customers->customer_name; ?>">
                    </div>
                </div>

                 <div class="form-group row">
                    <label for="name" class="col-sm-3 col-form-label">Gender*</label>
                    <div class="col-sm-9">
                        <select class="form-control" name="gender" required>
                            <option>SELECT</option>
                            <option value="MALE" <?=($customers->gender=="MALE")?"selected":""?> >MALE</option>
                            <option value="FEMALE" <?=($customers->gender=="FEMALE")?"selected":""?> >FEMALE</option>
                        </select>

                    </div>
                </div>

                <div class="form-group row">
                    <label for="customer_phone" class="col-sm-3 col-form-label"><?php echo display('phone') ?> *</label>
                    <div class="col-sm-9">
                        <input name="customer_phone" class="form-control" type="text" placeholder="<?php echo display('phone') ?>" id="customer_phone" value="<?php echo $customers->customer_phone; ?>">
                    </div>
                </div>

                <div class="form-group row">
                    <label for="name" class="col-sm-3 col-form-label">Unit*</label>
                    <div class="col-sm-9">
                        <select class="form-control" name="unit" required>
                            <?php foreach ($units as $rank) :
                                $srank = $customers->unit; ?>
                                <option value="<?php echo $rank->unit; ?>" <?php if ($srank == $rank->unit) {
                                                                                echo "selected";
                                                                            } ?>><?php echo $rank->unit; ?></option>
                            <?php endforeach; ?>
                        </select>

                    </div>
                </div>


                <div class="form-group row" style="display:none">
                    <label for="customer_type" class="col-sm-3 col-form-label"><?php echo display('customer_type') ?>*</label>
                    <div class="col-sm-9">

                        <select name="customer_type" onchange="" class="form-control">

                            <option value="">Select Customer Type</option>

                            <option value="1" <?php if ($customers->type == 1 && issset($customers->customer_id)) {
                                                    echo 'selected';
                                                } ?>><?php echo display('cash') ?></option>

                            <option value="2" <?php if ($customers->type == 2 && issset($customers->customer_id)) {
                                                    echo 'selected';
                                                } ?>><?php echo display('credit') ?></option>

                            <option value="3" <?php if ($customers->type == 3 && issset($customers->customer_id)) {
                                                    echo 'selected';
                                                } ?>><?php echo display('lease') ?></option>

                        </select>
                    </div>
                </div>

                <div class="form-group row" style="display:none;">
                    <label for="customer_phone" class="col-sm-3 col-form-label"><?php echo display('phone') ?> *</label>
                    <div class="col-sm-9">
                        <input name="store_id" class="form-control" type="hidden" placeholder="" value="">
                    </div>
                </div>

                <div class="form-group row" style="display:none;">
                    <label for="customer_cnic" class="col-sm-3 col-form-label"><?php echo display('customer_cnic') ?>*</label>
                    <div class="col-sm-9">
                        <input type="number" name="customer_cnic" class="form-control" placeholder="<?php echo display('customer_cnic') ?>" id="customer_cnic" value="<?php echo $customers->customer_cnic ?>">
                    </div>
                </div>
                <div class="form-group row" style="display:none;">
                    <label for="job_designation" class="col-sm-3 col-form-label"><?php echo display('designation') ?></label>
                    <div class="col-sm-9">
                        <input name="job_designation" class="form-control" type="text" placeholder="<?php echo display('designation') ?>" id="job_designation" value="<?php echo $customers->job_designation ?>">
                    </div>
                </div>

                <div class="form-group row" style="display: none;">
                    <label for="customer_address" class="col-sm-3 col-form-label"><?php echo display('address') ?></label>
                    <div class="col-sm-9">
                        <textarea name="customer_address" class="form-control" type="customer_address" placeholder="<?php echo display('address') ?>" id="customer_address"><?php echo $customers->customer_address; ?></textarea>
                    </div>
                </div>

                <div class="form-group row" style="display:none;">
                    <label for="business_address" class="col-sm-3 col-form-label"><?php echo display('business_address') ?></label>
                    <div class="col-sm-9">
                        <textarea name="business_address" class="form-control" type="business_address" placeholder="<?php echo display('business_address') ?>" id="business_address"><?php echo $customers->business_address; ?></textarea>
                    </div>
                </div>

                <div class="form-group row">
                    <label for="status" class="col-sm-3 col-form-label"><?php echo display('isactive') ?> *</label>
                    <div class="col-sm-9">
                        <label class="radio-inline">
                            <?php echo form_radio('isactive', '1', (($customers->isactive == 1 || !$customers) ? 1 : 0), 'id="isactive"'); ?>Active
                        </label>
                        <label class="radio-inline">
                            <?php echo form_radio('isactive', '0', (($customers->isactive == "0") ? 1 : 0), 'id="isactive"'); ?>Inactive
                        </label>
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