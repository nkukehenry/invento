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
