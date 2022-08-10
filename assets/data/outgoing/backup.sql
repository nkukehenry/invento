CALL get_store_stock('0',@store_id,@stock_date,@prod_id,@in_qty,@outqty,@rem,@cat_id,@brand_id,@model_id);
CALL get_store_stock('0',@store_id,@stock_date,@prod_id,@in_qty,@outqty,@rem,@cat_id,@brand_id,@model_id);
CALL get_store_stock('0',@store_id,@stock_date,@prod_id,@in_qty,@outqty,@rem,@cat_id,@brand_id,@model_id);
UPDATE `product` SET `product_id` = '6', `product_name` = 'VALLEYS-SUPER ECHO-30-Black', `product_code` = 'pro-1004', `category` = '5', `model` = '7', `unit` = '3', `brand` = '6', `product_details` = '', `purchase_price` = '0', `minimum_price` = '1200', `retail_price` = '0', `block_price` = '0', `isactive` = '1'
WHERE `product_id` IN('6');
UPDATE `product` SET `product_id` = '5', `product_name` = 'RIDGES-SUPER TILE-28-Maroon', `product_code` = 'pro-1003', `category` = '4', `model` = '6', `unit` = '3', `brand` = '4', `product_details` = '', `purchase_price` = '0', `minimum_price` = '700', `retail_price` = '0', `block_price` = '0', `isactive` = '1'
WHERE `product_id` IN('5');
UPDATE `product` SET `product_id` = '4', `product_name` = 'IRON SHEET-NORMAL CORRUGATION-30', `product_code` = 'pro-1002', `category` = '2', `model` = '7', `unit` = '3', `brand` = '7', `product_details` = '', `purchase_price` = '0', `minimum_price` = '7800', `retail_price` = '0', `block_price` = '0', `isactive` = '1'
WHERE `product_id` IN('4');
UPDATE `product` SET `product_id` = '3', `product_name` = 'IRON SHEET-SUPER TILE-28', `product_code` = 'pro-1001', `category` = '2', `model` = '6', `unit` = '3', `brand` = '4', `product_details` = '', `purchase_price` = '0', `minimum_price` = '600', `retail_price` = '0', `block_price` = '0', `isactive` = '1'
WHERE `product_id` IN('3');
CALL get_store_stock('0',@store_id,@stock_date,@prod_id,@in_qty,@outqty,@rem,@cat_id,@brand_id,@model_id);
CALL get_store_stock('0',@store_id,@stock_date,@prod_id,@in_qty,@outqty,@rem,@cat_id,@brand_id,@model_id);
UPDATE `product` SET `product_id` = '6', `product_name` = 'VALLEYS-SUPER ECHO-30-Black', `product_code` = 'pro-1004', `category` = '5', `model` = '7', `unit` = '3', `brand` = '6', `product_details` = '', `purchase_price` = '0', `minimum_price` = '1200', `retail_price` = '1200', `block_price` = '0', `isactive` = '1'
WHERE `product_id` IN('6');
UPDATE `product` SET `product_id` = '5', `product_name` = 'RIDGES-SUPER TILE-28-Maroon', `product_code` = 'pro-1003', `category` = '4', `model` = '6', `unit` = '3', `brand` = '4', `product_details` = '', `purchase_price` = '0', `minimum_price` = '700', `retail_price` = '700', `block_price` = '0', `isactive` = '1'
WHERE `product_id` IN('5');
UPDATE `product` SET `product_id` = '4', `product_name` = 'IRON SHEET-NORMAL CORRUGATION-30', `product_code` = 'pro-1002', `category` = '2', `model` = '7', `unit` = '3', `brand` = '7', `product_details` = '', `purchase_price` = '0', `minimum_price` = '7800', `retail_price` = '7800', `block_price` = '0', `isactive` = '1'
WHERE `product_id` IN('4');
UPDATE `product` SET `product_id` = '3', `product_name` = 'IRON SHEET-SUPER TILE-28', `product_code` = 'pro-1001', `category` = '2', `model` = '6', `unit` = '3', `brand` = '4', `product_details` = '', `purchase_price` = '0', `minimum_price` = '600', `retail_price` = '600', `block_price` = '0', `isactive` = '1'
WHERE `product_id` IN('3');
CALL get_store_stock('0',@store_id,@stock_date,@prod_id,@in_qty,@outqty,@rem,@cat_id,@brand_id,@model_id);
CALL get_store_stock('0',@store_id,@stock_date,@prod_id,@in_qty,@outqty,@rem,@cat_id,@brand_id,@model_id);
INSERT INTO `sales_parent` (`sale_id`, `invoice_no`, `customer_id`, `sale_type_id`, `store_id`, `salesman`, `pay_slip_no`, `sales_date`, `sales_time`, `gurrantor_1`, `gurrantor_2`, `advance_amnt`, `lease_id`, `inquiry_officer`, `remaining_amnt`, `installment_amnt`, `package_price`, `total_amnt`) VALUES ('20220808235748', '1000', '28', '1', NULL, '1', '5765757', '2022-08-08', '23:57:48', NULL, NULL, '', NULL, NULL, NULL, 0, 0, '6000.00');
INSERT INTO `acc_transaction` (`VNo`, `Vtype`, `VDate`, `COAID`, `Narration`, `Debit`, `Credit`, `StoreID`, `IsPosted`, `CreateBy`, `CreateDate`, `IsAppove`) VALUES ('1000', 'CIV', '2022-08-08 23:57:48', NULL, 'Cash in hand debit For Invoice No1000', '6000.00', 0, NULL, 1, '1', '2022-08-08 23:57:48', 1);
INSERT INTO `acc_transaction` (`VNo`, `Vtype`, `VDate`, `COAID`, `Narration`, `Debit`, `Credit`, `StoreID`, `IsPosted`, `CreateBy`, `CreateDate`, `IsAppove`) VALUES ('1000', 'CIV', '2022-08-08 23:57:48', 403, 'Cost of sale debit For Invoice No1000', NULL, 0, NULL, 1, '1', '2022-08-08 23:57:48', 1);
INSERT INTO `acc_transaction` (`VNo`, `Vtype`, `VDate`, `COAID`, `Narration`, `Debit`, `Credit`, `StoreID`, `IsPosted`, `CreateBy`, `CreateDate`, `IsAppove`) VALUES ('1000', 'CIV', '2022-08-08 23:57:48', 10107, 'Inventory credit For Invoice No1000', 0, NULL, NULL, 1, '1', '2022-08-08 23:57:48', 1);
INSERT INTO `acc_transaction` (`VNo`, `Vtype`, `VDate`, `COAID`, `Narration`, `Debit`, `Credit`, `StoreID`, `IsPosted`, `CreateBy`, `CreateDate`, `IsAppove`) VALUES ('1000', 'CIV', '2022-08-08 23:57:48', '1020301000001', 'Customer debit for Product For Invoice No1000', '6000.00', 0, NULL, 1, '1', '2022-08-08 23:57:48', 1);
INSERT INTO `acc_transaction` (`VNo`, `Vtype`, `VDate`, `COAID`, `Narration`, `Debit`, `Credit`, `StoreID`, `IsPosted`, `CreateBy`, `CreateDate`, `IsAppove`) VALUES ('1000', 'CIV', '2022-08-08 23:57:48', '1020301000001', 'Customer credit for Paid Amount For Invoice No1000', 0, '6000.00', NULL, 1, '1', '2022-08-08 23:57:48', 1);
INSERT INTO `payment_collection` (`sale_id`, `invoice_no`, `customer_id`, `receive_amnt`, `due_amnt`, `receive_by`, `receive_date`) VALUES ('20220808235748', '1000', '28', '6000.00', NULL, '1', '2022-08-08');
INSERT INTO `sale_details` (`sale_id`, `product_id`, `qty`, `sell_price`, `sale_type_id`, `lease_unit_price`) VALUES ('20220808235748', '3', '6', '600', '1', NULL);
INSERT INTO `sale_details` (`sale_id`, `product_id`, `qty`, `sell_price`, `sale_type_id`, `lease_unit_price`) VALUES ('20220808235748', '3', '4', '600', '1', NULL);
INSERT INTO `accesslog` (`action_page`, `action_done`, `remarks`, `user_name`, `entry_date`) VALUES ('Sales', 'create', 'invoice_no-1000 total amount-6000.00', '1', '2022-08-08 23:57:48');
UPDATE `user` SET `last_logout` = '2022-08-08 23:58:15'
WHERE `id` = '1';
UPDATE `user` SET `last_login` = '2022-08-10 20:19:28', `ip_address` = '::1'
WHERE `id` = '1';
CALL get_store_stock('0',@store_id,@stock_date,@prod_id,@in_qty,@outqty,@rem,@cat_id,@brand_id,@model_id);
CALL get_store_stock('0',@store_id,@stock_date,@prod_id,@in_qty,@outqty,@rem,@cat_id,@brand_id,@model_id);
CALL get_store_stock('0',@store_id,@stock_date,@prod_id,@in_qty,@outqty,@rem,@cat_id,@brand_id,@model_id);
CALL get_store_stock('0',@store_id,@stock_date,@prod_id,@in_qty,@outqty,@rem,@cat_id,@brand_id,@model_id);
UPDATE `customer` SET `customer_id` = '28', `isactive` = 0
WHERE `customer_id` = '28';
UPDATE `customer` SET `customer_id` = '27', `customer_code` = '65566566', `customer_name` = 'OCHOLA OKOTH', `force_rank` = 'IGP', `unit` = 'Uganda Police', `type` = '', `customer_phone` = '', `store_id` = '', `job_designation` = '', `customer_address` = 'Nagulu', `customer_cnic` = '', `business_address` = '', `isactive` = '1', `createby` = '1', `createdate` = '2022-08-10 20:37:55', `updateby` = '1', `updatedate` = '2022-08-10 20:37:55'
WHERE `customer_id` = '27';
INSERT INTO `accesslog` (`action_page`, `action_done`, `remarks`, `user_name`, `entry_date`) VALUES ('Customer', 'update', 'customer ID :27', '1', '2022-08-10 20:37:55');
UPDATE `customer` SET `customer_id` = '28', `isactive` = 1
WHERE `customer_id` = '28';
UPDATE `customer` SET `customer_id` = '27', `customer_code` = '65566566', `customer_name` = 'OCHOLA OKOTH', `force_rank` = 'IGP', `unit` = 'Uganda Police', `type` = '', `customer_phone` = '08678678687', `store_id` = '', `job_designation` = '', `customer_address` = 'Nagulu', `customer_cnic` = '', `business_address` = '', `isactive` = '1', `createby` = '1', `createdate` = '2022-08-10 20:38:35', `updateby` = '1', `updatedate` = '2022-08-10 20:38:35'
WHERE `customer_id` = '27';
INSERT INTO `accesslog` (`action_page`, `action_done`, `remarks`, `user_name`, `entry_date`) VALUES ('Customer', 'update', 'customer ID :27', '1', '2022-08-10 20:38:35');
UPDATE `store` SET `store_id` = '2', `store_name` = 'Henry', `store_code` = 'Mba', `store_phone` = '07897876700', `store_address` = 'Mbarara', `manager_name` = NULL, `createby` = '1', `createdate` = '2022-08-10 20:44:41', `isactive` = 1
WHERE `store_id` = '2';
INSERT INTO `accesslog` (`action_page`, `action_done`, `remarks`, `user_name`, `entry_date`) VALUES ('Store', 'update', 'Store ID :2', '1', '2022-08-10 20:44:41');
UPDATE `store` SET `store_id` = '2', `store_name` = 'Mbarara', `store_code` = 'Mba', `store_phone` = '07897876700', `store_address` = 'Mbarara', `manager_name` = 'Henry', `createby` = '1', `createdate` = '2022-08-10 20:45:13', `isactive` = 1
WHERE `store_id` = '2';
INSERT INTO `accesslog` (`action_page`, `action_done`, `remarks`, `user_name`, `entry_date`) VALUES ('Store', 'update', 'Store ID :2', '1', '2022-08-10 20:45:13');
CALL get_store_stock('0',@store_id,@stock_date,@prod_id,@in_qty,@outqty,@rem,@cat_id,@brand_id,@model_id);
CALL get_store_stock('0',@store_id,@stock_date,@prod_id,@in_qty,@outqty,@rem,@cat_id,@brand_id,@model_id);
CALL get_store_stock('0',@store_id,@stock_date,@prod_id,@in_qty,@outqty,@rem,@cat_id,@brand_id,@model_id);
INSERT INTO `sales_parent` (`sale_id`, `invoice_no`, `customer_id`, `sale_type_id`, `store_id`, `salesman`, `pay_slip_no`, `sales_date`, `sales_time`, `gurrantor_1`, `gurrantor_2`, `advance_amnt`, `lease_id`, `inquiry_officer`, `remaining_amnt`, `installment_amnt`, `package_price`, `total_amnt`, `destination`) VALUES ('20220810210925', '1000', '27', '1', NULL, '1', '65666577', '2022-08-10', '21:09:25', NULL, NULL, '', NULL, NULL, NULL, 0, 0, '240000.00', '2');
INSERT INTO `acc_transaction` (`VNo`, `Vtype`, `VDate`, `COAID`, `Narration`, `Debit`, `Credit`, `StoreID`, `IsPosted`, `CreateBy`, `CreateDate`, `IsAppove`) VALUES ('1000', 'CIV', '2022-08-10 21:09:25', NULL, 'Cash in hand debit For Invoice No1000', '240000.00', 0, NULL, 1, '1', '2022-08-10 21:09:25', 1);
INSERT INTO `acc_transaction` (`VNo`, `Vtype`, `VDate`, `COAID`, `Narration`, `Debit`, `Credit`, `StoreID`, `IsPosted`, `CreateBy`, `CreateDate`, `IsAppove`) VALUES ('1000', 'CIV', '2022-08-10 21:09:25', 403, 'Cost of sale debit For Invoice No1000', NULL, 0, NULL, 1, '1', '2022-08-10 21:09:25', 1);
INSERT INTO `acc_transaction` (`VNo`, `Vtype`, `VDate`, `COAID`, `Narration`, `Debit`, `Credit`, `StoreID`, `IsPosted`, `CreateBy`, `CreateDate`, `IsAppove`) VALUES ('1000', 'CIV', '2022-08-10 21:09:25', 10107, 'Inventory credit For Invoice No1000', 0, NULL, NULL, 1, '1', '2022-08-10 21:09:25', 1);
INSERT INTO `acc_transaction` (`VNo`, `Vtype`, `VDate`, `COAID`, `Narration`, `Debit`, `Credit`, `StoreID`, `IsPosted`, `CreateBy`, `CreateDate`, `IsAppove`) VALUES ('1000', 'CIV', '2022-08-10 21:09:25', NULL, 'Customer debit for Product For Invoice No1000', '240000.00', 0, NULL, 1, '1', '2022-08-10 21:09:25', 1);
INSERT INTO `acc_transaction` (`VNo`, `Vtype`, `VDate`, `COAID`, `Narration`, `Debit`, `Credit`, `StoreID`, `IsPosted`, `CreateBy`, `CreateDate`, `IsAppove`) VALUES ('1000', 'CIV', '2022-08-10 21:09:25', NULL, 'Customer credit for Paid Amount For Invoice No1000', 0, '240000.00', NULL, 1, '1', '2022-08-10 21:09:25', 1);
INSERT INTO `payment_collection` (`sale_id`, `invoice_no`, `customer_id`, `receive_amnt`, `due_amnt`, `receive_by`, `receive_date`) VALUES ('20220810210925', '1000', '27', '240000.00', NULL, '1', '2022-08-10');
INSERT INTO `sale_details` (`sale_id`, `product_id`, `qty`, `sell_price`, `sale_type_id`, `lease_unit_price`) VALUES ('20220810210925', '3', '40', '6000', '1', NULL);
INSERT INTO `accesslog` (`action_page`, `action_done`, `remarks`, `user_name`, `entry_date`) VALUES ('Sales', 'create', 'invoice_no-1000 total amount-240000.00', '1', '2022-08-10 21:09:26');
UPDATE `user` SET `last_logout` = '2022-08-10 21:10:43'
WHERE `id` = '1';
UPDATE `user` SET `last_login` = '2022-08-10 21:10:58', `ip_address` = '::1'
WHERE `id` = '3';
CALL get_store_stock('0',@store_id,@stock_date,@prod_id,@in_qty,@outqty,@rem,@cat_id,@brand_id,@model_id);
CALL get_store_stock('0',@store_id,@stock_date,@prod_id,@in_qty,@outqty,@rem,@cat_id,@brand_id,@model_id);
CALL get_store_stock('0',@store_id,@stock_date,@prod_id,@in_qty,@outqty,@rem,@cat_id,@brand_id,@model_id);
INSERT INTO `sales_parent` (`sale_id`, `invoice_no`, `customer_id`, `sale_type_id`, `store_id`, `salesman`, `pay_slip_no`, `sales_date`, `sales_time`, `gurrantor_1`, `gurrantor_2`, `advance_amnt`, `lease_id`, `inquiry_officer`, `remaining_amnt`, `installment_amnt`, `package_price`, `total_amnt`, `destination`) VALUES ('20220810211248', '1000', '27', '1', '2', '3', '50000888', '2022-08-10', '21:12:48', NULL, NULL, '', NULL, NULL, NULL, 0, 0, '3900000.00', '2');
INSERT INTO `acc_transaction` (`VNo`, `Vtype`, `VDate`, `COAID`, `Narration`, `Debit`, `Credit`, `StoreID`, `IsPosted`, `CreateBy`, `CreateDate`, `IsAppove`) VALUES ('1000', 'CIV', '2022-08-10 21:12:48', NULL, 'Cash in hand debit For Invoice No1000', '3900000.00', 0, '2', 1, '3', '2022-08-10 21:12:48', 1);
INSERT INTO `acc_transaction` (`VNo`, `Vtype`, `VDate`, `COAID`, `Narration`, `Debit`, `Credit`, `StoreID`, `IsPosted`, `CreateBy`, `CreateDate`, `IsAppove`) VALUES ('1000', 'CIV', '2022-08-10 21:12:48', 403, 'Cost of sale debit For Invoice No1000', NULL, 0, '2', 1, '3', '2022-08-10 21:12:48', 1);
INSERT INTO `acc_transaction` (`VNo`, `Vtype`, `VDate`, `COAID`, `Narration`, `Debit`, `Credit`, `StoreID`, `IsPosted`, `CreateBy`, `CreateDate`, `IsAppove`) VALUES ('1000', 'CIV', '2022-08-10 21:12:48', 10107, 'Inventory credit For Invoice No1000', 0, NULL, '2', 1, '3', '2022-08-10 21:12:48', 1);
INSERT INTO `acc_transaction` (`VNo`, `Vtype`, `VDate`, `COAID`, `Narration`, `Debit`, `Credit`, `StoreID`, `IsPosted`, `CreateBy`, `CreateDate`, `IsAppove`) VALUES ('1000', 'CIV', '2022-08-10 21:12:48', NULL, 'Customer debit for Product For Invoice No1000', '3900000.00', 0, '2', 1, '3', '2022-08-10 21:12:48', 1);
INSERT INTO `acc_transaction` (`VNo`, `Vtype`, `VDate`, `COAID`, `Narration`, `Debit`, `Credit`, `StoreID`, `IsPosted`, `CreateBy`, `CreateDate`, `IsAppove`) VALUES ('1000', 'CIV', '2022-08-10 21:12:48', NULL, 'Customer credit for Paid Amount For Invoice No1000', 0, '3900000.00', '2', 1, '3', '2022-08-10 21:12:48', 1);
INSERT INTO `payment_collection` (`sale_id`, `invoice_no`, `customer_id`, `receive_amnt`, `due_amnt`, `receive_by`, `receive_date`) VALUES ('20220810211248', '1000', '27', '3900000.00', NULL, '3', '2022-08-10');
INSERT INTO `sale_details` (`sale_id`, `product_id`, `qty`, `sell_price`, `sale_type_id`, `lease_unit_price`) VALUES ('20220810211248', '4', '50', '78000', '1', NULL);
INSERT INTO `accesslog` (`action_page`, `action_done`, `remarks`, `user_name`, `entry_date`) VALUES ('Sales', 'create', 'invoice_no-1000 total amount-3900000.00', '3', '2022-08-10 21:12:48');
CALL get_store_stock('0',@store_id,@stock_date,@prod_id,@in_qty,@outqty,@rem,@cat_id,@brand_id,@model_id);
INSERT INTO `sales_parent` (`sale_id`, `invoice_no`, `customer_id`, `sale_type_id`, `store_id`, `salesman`, `pay_slip_no`, `sales_date`, `sales_time`, `gurrantor_1`, `gurrantor_2`, `advance_amnt`, `lease_id`, `inquiry_officer`, `remaining_amnt`, `installment_amnt`, `package_price`, `total_amnt`, `destination`) VALUES ('20220810211457', '1001', '27', '1', '2', '3', '5600000', '2022-08-10', '21:14:57', NULL, NULL, '', NULL, NULL, NULL, 0, 0, '420000.00', 'ADJUMANI');
INSERT INTO `acc_transaction` (`VNo`, `Vtype`, `VDate`, `COAID`, `Narration`, `Debit`, `Credit`, `StoreID`, `IsPosted`, `CreateBy`, `CreateDate`, `IsAppove`) VALUES ('1001', 'CIV', '2022-08-10 21:14:57', NULL, 'Cash in hand debit For Invoice No1001', '420000.00', 0, '2', 1, '3', '2022-08-10 21:14:57', 1);
INSERT INTO `acc_transaction` (`VNo`, `Vtype`, `VDate`, `COAID`, `Narration`, `Debit`, `Credit`, `StoreID`, `IsPosted`, `CreateBy`, `CreateDate`, `IsAppove`) VALUES ('1001', 'CIV', '2022-08-10 21:14:57', 403, 'Cost of sale debit For Invoice No1001', NULL, 0, '2', 1, '3', '2022-08-10 21:14:57', 1);
INSERT INTO `acc_transaction` (`VNo`, `Vtype`, `VDate`, `COAID`, `Narration`, `Debit`, `Credit`, `StoreID`, `IsPosted`, `CreateBy`, `CreateDate`, `IsAppove`) VALUES ('1001', 'CIV', '2022-08-10 21:14:57', 10107, 'Inventory credit For Invoice No1001', 0, NULL, '2', 1, '3', '2022-08-10 21:14:57', 1);
INSERT INTO `acc_transaction` (`VNo`, `Vtype`, `VDate`, `COAID`, `Narration`, `Debit`, `Credit`, `StoreID`, `IsPosted`, `CreateBy`, `CreateDate`, `IsAppove`) VALUES ('1001', 'CIV', '2022-08-10 21:14:57', NULL, 'Customer debit for Product For Invoice No1001', '420000.00', 0, '2', 1, '3', '2022-08-10 21:14:57', 1);
INSERT INTO `acc_transaction` (`VNo`, `Vtype`, `VDate`, `COAID`, `Narration`, `Debit`, `Credit`, `StoreID`, `IsPosted`, `CreateBy`, `CreateDate`, `IsAppove`) VALUES ('1001', 'CIV', '2022-08-10 21:14:57', NULL, 'Customer credit for Paid Amount For Invoice No1001', 0, '420000.00', '2', 1, '3', '2022-08-10 21:14:57', 1);
INSERT INTO `payment_collection` (`sale_id`, `invoice_no`, `customer_id`, `receive_amnt`, `due_amnt`, `receive_by`, `receive_date`) VALUES ('20220810211457', '1001', '27', '420000.00', NULL, '3', '2022-08-10');
INSERT INTO `sale_details` (`sale_id`, `product_id`, `qty`, `sell_price`, `sale_type_id`, `lease_unit_price`) VALUES ('20220810211457', '3', '70', '6000', '1', NULL);
INSERT INTO `accesslog` (`action_page`, `action_done`, `remarks`, `user_name`, `entry_date`) VALUES ('Sales', 'create', 'invoice_no-1001 total amount-420000.00', '3', '2022-08-10 21:14:57');
UPDATE `user` SET `last_logout` = '2022-08-10 21:15:30'
WHERE `id` = '3';
UPDATE `user` SET `last_login` = '2022-08-10 21:15:39', `ip_address` = '::1'
WHERE `id` = '1';
CALL get_store_stock('0',@store_id,@stock_date,@prod_id,@in_qty,@outqty,@rem,@cat_id,@brand_id,@model_id);
CALL get_store_stock('0',@store_id,@stock_date,@prod_id,@in_qty,@outqty,@rem,@cat_id,@brand_id,@model_id);
CALL get_store_stock('0',@store_id,@stock_date,@prod_id,@in_qty,@outqty,@rem,@cat_id,@brand_id,@model_id);
CALL get_store_stock('0',@store_id,@stock_date,@prod_id,@in_qty,@outqty,@rem,@cat_id,@brand_id,@model_id);
INSERT INTO `product_manufacturers` (`id`, `manufacturer_name`, `isactive`) VALUES ('', 'Roofings', 1);
INSERT INTO `product_manufacturers` (`id`, `manufacturer_name`, `isactive`) VALUES ('', 'Roofings', 1);
INSERT INTO `product_manufacturers` (`id`, `manufacturer_name`, `isactive`) VALUES ('', 'Steel n TUbe', 1);
DELETE FROM `product_manufacturers`
WHERE `id` = '1';
UPDATE `product_manufacturers` SET `id` = '8', `manufacturer_name` = 'Steel n TUbe', `isactive` = 1
WHERE `id` = '8';
UPDATE `product_manufacturers` SET `id` = '7', `manufacturer_name` = 'Roofings One', `isactive` = 1
WHERE `id` = '7';
UPDATE `product_manufacturers` SET `id` = '7', `manufacturer_name` = 'Roofings', `isactive` = 1
WHERE `id` = '7';
UPDATE `product_manufacturers` SET `id` = '8', `manufacturer_name` = 'Steel & Tube', `isactive` = 1
WHERE `id` = '8';
INSERT INTO `product` (`product_id`, `product_name`, `product_code`, `model`, `category`, `brand`, `unit`, `product_details`, `purchase_price`, `block_price`, `minimum_price`, `retail_price`, `manufacturer_id`, `createby`, `createdate`, `updateby`, `updatedate`, `isactive`) VALUES ('', 'IRON SHEET-Steel & Tube-SUPER-SUPER TILE-28-Maroon', 'pro-1005', '6', '2', '4', '3', '', '0', '0', '0', '0', '8', '1', '2022-08-10 21:57:14', '', '', 1);
INSERT INTO `product` (`product_id`, `product_name`, `product_code`, `model`, `category`, `brand`, `unit`, `product_details`, `purchase_price`, `block_price`, `minimum_price`, `retail_price`, `manufacturer_id`, `createby`, `createdate`, `updateby`, `updatedate`, `isactive`) VALUES ('', 'IRON SHEET-Steel & Tube-SUPER-SUPER TILE-28-Maroon', 'pro-1005', '6', '2', '4', '3', 'uuiiiiiiiiiiiiiiiii', '0', '0', '0', '0', '8', '1', '2022-08-10 21:57:40', '', '', 1);
INSERT INTO `product` (`product_id`, `product_name`, `product_code`, `model`, `category`, `brand`, `unit`, `product_details`, `purchase_price`, `block_price`, `minimum_price`, `retail_price`, `manufacturer_id`, `createby`, `createdate`, `updateby`, `updatedate`, `isactive`) VALUES ('', 'IRON SHEET-Steel & Tube-SUPER-SUPER TILE-28-Black', 'pro-1005', '6', '2', '4', '3', '', '0', '0', '0', '0', '8', '1', '2022-08-10 21:58:28', '', '', 1);
INSERT INTO `accesslog` (`action_page`, `action_done`, `remarks`, `user_name`, `entry_date`) VALUES ('Product', 'create', 'product ID :7', '1', '2022-08-10 21:58:28');
INSERT INTO `customer` (`customer_code`, `force_rank`, `unit`, `customer_name`, `customer_phone`) VALUES ('57578578578', NULL, 'Research', NULL, '58585785');
INSERT INTO `customer` (`customer_code`, `force_rank`, `unit`, `customer_name`, `customer_phone`) VALUES ('5.10009E+11', NULL, 'CID', NULL, '78976666');
INSERT INTO `customer` (`customer_code`, `force_rank`, `unit`, `customer_name`, `customer_phone`) VALUES ('57578578578', NULL, 'Research', NULL, '58585785');
INSERT INTO `customer` (`customer_code`, `force_rank`, `unit`, `customer_name`, `customer_phone`) VALUES ('5.10009E+11', NULL, 'CID', NULL, '78976666');
INSERT INTO `customer` (`customer_code`, `force_rank`, `unit`, `customer_name`, `customer_phone`) VALUES ('57578578578', 'AIGP', 'Research', 'Mukisa Robert', '58585785');
INSERT INTO `customer` (`customer_code`, `force_rank`, `unit`, `customer_name`, `customer_phone`) VALUES ('5.10009E+11', 'SSP', 'CID', 'Mugisha Isaac', '78976666');
INSERT INTO `customer` (`customer_code`, `force_rank`, `unit`, `customer_name`, `customer_phone`) VALUES ('57578578578', 'AIGP', 'Research', 'Mukisa Robert', '58585785');
INSERT INTO `customer` (`customer_code`, `force_rank`, `unit`, `customer_name`, `customer_phone`) VALUES ('5.10009E+11', 'SSP', 'CID', 'Mugisha Isaac', '78976666');
DELETE FROM `customer`
WHERE `customer_id` = '29';
INSERT INTO `accesslog` (`action_page`, `action_done`, `remarks`, `user_name`, `entry_date`) VALUES ('Customer', 'delete', 'customer ID :29', '1', '2022-08-10 22:21:48');
UPDATE `customer` SET `customer_id` = '30', `isactive` = 1
WHERE `customer_id` = '30';
DELETE FROM `customer`
WHERE `customer_id` = '30';
INSERT INTO `accesslog` (`action_page`, `action_done`, `remarks`, `user_name`, `entry_date`) VALUES ('Customer', 'delete', 'customer ID :30', '1', '2022-08-10 22:21:59');
INSERT INTO `customer` (`customer_code`, `force_rank`, `unit`, `customer_name`, `customer_phone`, `isactive`) VALUES ('57578578578', 'AIGP', 'Research', 'Mukisa Robert', '58585785', 1);
INSERT INTO `customer` (`customer_code`, `force_rank`, `unit`, `customer_name`, `customer_phone`, `isactive`) VALUES ('5.10009E+11', 'SSP', 'CID', 'Mugisha Isaac', '78976666', 1);
DELETE FROM `customer`
WHERE `customer_id` = '34';
INSERT INTO `accesslog` (`action_page`, `action_done`, `remarks`, `user_name`, `entry_date`) VALUES ('Customer', 'delete', 'customer ID :34', '1', '2022-08-10 22:22:47');
DELETE FROM `customer`
WHERE `customer_id` = '33';
INSERT INTO `accesslog` (`action_page`, `action_done`, `remarks`, `user_name`, `entry_date`) VALUES ('Customer', 'delete', 'customer ID :33', '1', '2022-08-10 22:22:51');
INSERT INTO `customer` (`customer_code`, `force_rank`, `unit`, `customer_name`, `customer_phone`, `isactive`) VALUES ('57578578578', 'AIGP', 'Research', 'Mukisa Robert', '58585785', 1);
INSERT INTO `customer` (`customer_code`, `force_rank`, `unit`, `customer_name`, `customer_phone`, `isactive`) VALUES ('510009000000', 'SSP', 'CID', 'Mugisha Isaac', '78976666', 1);
CALL get_store_stock('0',@store_id,@stock_date,@prod_id,@in_qty,@outqty,@rem,@cat_id,@brand_id,@model_id);
CALL get_store_stock('0',@store_id,@stock_date,@prod_id,@in_qty,@outqty,@rem,@cat_id,@brand_id,@model_id);
CALL get_store_stock('0',@store_id,@stock_date,@prod_id,@in_qty,@outqty,@rem,@cat_id,@brand_id,@model_id);
CALL get_store_stock('0',@store_id,@stock_date,@prod_id,@in_qty,@outqty,@rem,@cat_id,@brand_id,@model_id);
