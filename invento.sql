-- phpMyAdmin SQL Dump
-- version 5.1.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Aug 10, 2022 at 10:28 PM
-- Server version: 10.4.22-MariaDB
-- PHP Version: 7.4.27

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `invento`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_store_stock` (IN `s_id` INT, OUT `store_id` INT, OUT `stock_date` DATE, OUT `prod_id` BIGINT, OUT `in_qty` INT, OUT `out_qty` INT, OUT `rem` VARCHAR(20), OUT `CatID` INT, OUT `BrandID` INT, OUT `ModelID` INT)  BEGIN 

  DECLARE done INT DEFAULT FALSE;
   DECLARE sql_qr text;
  
   
  DECLARE cursorForStore CURSOR FOR SELECT store.store_id FROM store WHERE isactive=1;
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
  
  DROP TABLE IF EXISTS tmp_store_stock; 
 CREATE TABLE `tmp_store_stock` ( `StoreID` int(11) NOT NULL, `Stock_Date` datetime NOT NULL, `ProdID` bigint(20) NOT NULL, `InQty` int(11) NOT NULL, `OutQty` int(11) NOT NULL, `category_id` varchar(11) NOT NULL, `brand_id` varchar(11)  NOT NULL, `model_id` varchar(11) NOT NULL , `Remarks` varchar(50) COLLATE utf8_unicode_ci NOT NULL) ENGINE=InnoDB DEFAULT CHARSET=utf8 ; 
  
 OPEN cursorForStore;
   read_loop: LOOP
        FETCH cursorForStore INTO s_id;
        IF done THEN
          LEAVE read_loop;
        END IF;
         INSERT INTO tmp_store_stock 
           SELECT StoreID, stockDate, ProdID, SUM(RecQty) AS InQty, SUM(RetQty) AS OutQty, CatID, BrandID, ModelID, remarks FROM(
                SELECT purchase_receive_details.store_id AS StoreID, purchase_receive.receive_date AS stockDate, purchase_receive_details.product_id AS ProdID, purchase_receive_details.receive_qty AS RecQty, 0 AS RetQty, ( SELECT category FROM product WHERE product.product_id=purchase_receive_details.product_id) AS CatID, ( SELECT brand FROM product WHERE product.product_id=purchase_receive_details.product_id) AS BrandID, ( SELECT model FROM product WHERE product.product_id=purchase_receive_details.product_id) AS ModelID, 'purchase_receive' AS remarks FROM purchase_receive_details INNER JOIN purchase_receive ON (purchase_receive_details.receive_id =purchase_receive.receive_id) WHERE purchase_receive_details.store_id=s_id 
                UNION ALL
                SELECT stock_movement.for_store_id AS StoreID, stock_movement.receive_datetime AS stockDate, stock_movement_details.product_id AS ProdID,stock_movement_details.received_qty AS RecQty, 0 AS RetQty, ( SELECT category FROM product WHERE product.product_id=stock_movement_details.product_id) AS CatID, ( SELECT brand FROM product WHERE product.product_id=stock_movement_details.product_id) AS BrandID, ( SELECT model FROM product WHERE product.product_id=stock_movement_details.product_id) AS ModelID, 'Stock Receive' AS remarks FROM stock_movement INNER JOIN stock_movement_details ON (stock_movement_details.movement_id=stock_movement.movement_id) WHERE stock_movement.for_store_id=s_id AND stock_movement_details.received_qty<>0 GROUP BY ProdID 
                UNION ALL
                 SELECT sales_return.store_id AS StoreID,sales_return.return_date AS stockDate, sales_return_details.product_id AS ProdID,sales_return_details.qty AS RecQty, 0 AS RetQty, ( SELECT category FROM product WHERE product.product_id=sales_return_details.product_id) AS CatID, ( SELECT brand FROM product WHERE product.product_id=sales_return_details.product_id) AS BrandID, ( SELECT model FROM product WHERE product.product_id=sales_return_details.product_id) AS ModelID, 'Sales Return' AS remarks FROM sales_return INNER JOIN sales_return_details ON (sales_return_details.sreturn_id=sales_return.sreturn_id) WHERE sales_return.store_id=s_id
                UNION ALL
                 SELECT purchase_return_details.store_id AS StoreID, purchase_return.return_date AS stockDate, purchase_return_details.product_id AS ProdID, 0 AS RecQty, purchase_return_details.qty AS RetQty, ( SELECT category FROM product WHERE product.product_id=purchase_return_details.product_id) AS CatID, ( SELECT brand FROM product WHERE product.product_id=purchase_return_details.product_id) AS BrandID, ( SELECT model FROM product WHERE product.product_id=purchase_return_details.product_id) AS ModelID, 'Purchase Return' AS remarks FROM purchase_return_details INNER JOIN purchase_return ON (purchase_return_details.preturn_id=purchase_return.preturn_id)  WHERE purchase_return_details.store_id=s_id
                UNION ALL
                SELECT stock_movement.from_store_id AS StoreID, stock_movement.issue_datetime AS stockDate, stock_movement_details.product_id AS ProdID, 0 AS RecQty, stock_movement_details.issue_qty AS RetQty, ( SELECT category FROM product WHERE product.product_id=stock_movement_details.product_id) AS CatID, ( SELECT brand FROM product WHERE product.product_id=stock_movement_details.product_id) AS BrandID, ( SELECT model FROM product WHERE product.product_id=stock_movement_details.product_id) AS ModelID, 'Stock Issue' AS remarks FROM stock_movement INNER JOIN stock_movement_details ON (stock_movement_details.movement_id=stock_movement.movement_id) WHERE stock_movement.for_store_id=s_id AND stock_movement_details.received_qty<>0 AND  stock_movement_details.issue_qty<>0 GROUP BY ProdID 
             UNION ALL
    SELECT sales_parent.store_id AS StoreID, sales_parent.sales_date AS stockDate, sale_details.product_id AS ProdID, 0 AS RecQty, sale_details.qty AS RetQty, ( SELECT category FROM product WHERE product.product_id=sale_details.product_id) AS CatID, ( SELECT brand FROM product WHERE product.product_id=sale_details.product_id) AS BrandID, ( SELECT model FROM product WHERE product.product_id=sale_details.product_id) AS ModelID, 'Sold' AS remarks FROM sales_parent INNER JOIN sale_details ON (sale_details.sale_id=sales_parent.sale_id) WHERE sales_parent.store_id=s_id
            ) AS tbl GROUP BY StoreID, ProdID 
        ;       
    END LOOP;
    CLOSE cursorForStore;
   



END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `accesslog`
--

CREATE TABLE `accesslog` (
  `sl_no` bigint(20) NOT NULL,
  `action_page` varchar(50) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL,
  `action_done` text CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL,
  `remarks` text CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `user_name` varchar(50) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL,
  `entry_date` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `accesslog`
--

INSERT INTO `accesslog` (`sl_no`, `action_page`, `action_done`, `remarks`, `user_name`, `entry_date`) VALUES
(1, 'Store', 'create', 'Store ID :1', '1', '2022-07-31 21:46:51'),
(2, 'Store', 'create', 'Store ID :2', '1', '2022-07-31 21:47:14'),
(3, 'Product', 'create', 'product ID :1', '1', '2022-07-31 21:49:06'),
(4, 'Supplier', 'create', 'Supplier ID :1', '1', '2022-07-31 21:49:48'),
(5, 'purchase order', 'create', 'Orde Id-20220731215056 total amount-300000.00', '1', '2022-07-31 21:50:56'),
(6, 'purchase order receive', 'create', 'Order Id- total amount-300000.00', '1', '2022-07-31 21:52:54'),
(7, 'User', 'create', 'User ID :2', '1', '2022-07-31 21:56:18'),
(8, 'User', 'create', 'User ID :3', '1', '2022-07-31 21:57:13'),
(9, 'purchase Receive', 'update', 'Receive Id-20220731215056 total amount-300000', '3', '2022-07-31 21:58:46'),
(10, 'Role', 'update', 'Role id :7', '1', '2022-08-02 21:13:44'),
(11, 'purchase order', 'create', 'Orde Id-20220803213446 total amount-5600000.00', '1', '2022-08-03 21:34:47'),
(12, 'purchase Receive', 'update', 'Receive Id- total amount-560000.00', '1', '2022-08-03 21:36:53'),
(13, 'purchase order', 'delete', 'Orde Id-20220803213446', '1', '2022-08-03 21:37:08'),
(14, 'purchase order', 'create', 'Orde Id-20220803213739 total amount-600000.00', '1', '2022-08-03 21:37:39'),
(15, 'purchase order receive', 'create', 'Order Id- total amount-180000.00', '1', '2022-08-03 21:39:46'),
(16, 'Stockmovment', 'create', 'Stockmovment ID :1', '1', '2022-08-07 08:33:46'),
(17, 'Stockmovment', 'delete', 'Stockmovment ID :1', '1', '2022-08-07 08:33:58'),
(18, 'Stockmovment', 'delete', 'Stockmovment ID :1', '1', '2022-08-07 08:34:02'),
(19, 'purchase order receive', 'create', 'Order Id- total amount-180000.00', '1', '2022-08-07 08:34:51'),
(20, 'purchase order', 'delete', 'Orde Id-20220803213739', '1', '2022-08-07 08:41:59'),
(21, 'Product', 'update', 'product ID :1', '1', '2022-08-07 12:51:40'),
(22, 'Product', 'create', 'product ID :2', '1', '2022-08-07 13:03:58'),
(23, 'Product', 'update', 'product ID :1', '1', '2022-08-07 13:05:26'),
(24, 'purchase order', 'create', 'Orde Id-20220807130740 total amount-120000000.00', '1', '2022-08-07 13:07:41'),
(25, 'purchase order', 'create', 'Orde Id-20220807135913 total amount-30000.00', '1', '2022-08-07 13:59:13'),
(26, 'purchase order receive', 'create', 'Order Id- total amount-30000.00', '1', '2022-08-07 13:59:42'),
(27, 'purchase order', 'create', 'Orde Id-20220807145331 total amount-10000.00', '1', '2022-08-07 14:53:31'),
(28, 'purchase order receive', 'create', 'Order Id- total amount-10000.00', '1', '2022-08-07 14:53:45'),
(29, 'Supplier', 'delete', 'Supplier ID :1', '1', '2022-08-07 15:00:21'),
(30, 'Supplier', 'create', 'Supplier ID :2', '1', '2022-08-07 15:02:26'),
(31, 'Supplier', 'create', 'Supplier ID :3', '1', '2022-08-07 15:02:55'),
(32, 'Supplier', 'create', 'Supplier ID :4', '1', '2022-08-07 15:03:12'),
(33, 'Supplier', 'create', 'Supplier ID :5', '1', '2022-08-07 15:03:32'),
(34, 'Supplier', 'create', 'Supplier ID :6', '1', '2022-08-07 15:03:45'),
(35, 'Supplier', 'create', 'Supplier ID :7', '1', '2022-08-07 15:03:58'),
(36, 'Supplier', 'create', 'Supplier ID :8', '1', '2022-08-07 15:04:10'),
(37, 'Product', 'create', 'product ID :3', '1', '2022-08-07 15:32:54'),
(38, 'purchase order', 'create', 'Orde Id-20220807153707 total amount-10000000.00', '1', '2022-08-07 15:37:07'),
(39, 'purchase order receive', 'create', 'Order Id- total amount-10000000.00', '1', '2022-08-07 15:37:36'),
(40, 'Product', 'create', 'product ID :4', '1', '2022-08-07 15:40:45'),
(41, 'purchase order', 'create', 'Orde Id-20220807154155 total amount-9000000.00', '1', '2022-08-07 15:41:55'),
(42, 'purchase order receive', 'create', 'Order Id- total amount-7000000.00', '1', '2022-08-07 15:42:27'),
(43, 'Sales', 'create', 'invoice_no-1000 total amount-3000.00', '1', '2022-08-07 15:43:52'),
(44, 'Product', 'create', 'product ID :5', '1', '2022-08-07 19:54:25'),
(45, 'Product', 'create', 'product ID :6', '1', '2022-08-07 20:10:54'),
(46, 'purchase order', 'create', 'Orde Id-20220807205857 total amount-10000000.00', '1', '2022-08-07 20:58:57'),
(47, 'purchase order receive', 'create', 'Order Id- total amount-10000000.00', '1', '2022-08-07 20:59:22'),
(48, 'Sales', 'create', 'invoice_no-1000 total amount-3000000.00', '1', '2022-08-07 21:06:43'),
(49, 'Customer', 'create', '28', '1', '2022-08-08 20:23:50'),
(50, 'Sales', 'create', 'invoice_no-1000 total amount-6000.00', '1', '2022-08-08 23:57:48'),
(51, 'Customer', 'update', 'customer ID :27', '1', '2022-08-10 20:37:55'),
(52, 'Customer', 'update', 'customer ID :27', '1', '2022-08-10 20:38:35'),
(53, 'Store', 'update', 'Store ID :2', '1', '2022-08-10 20:44:41'),
(54, 'Store', 'update', 'Store ID :2', '1', '2022-08-10 20:45:13'),
(55, 'Sales', 'create', 'invoice_no-1000 total amount-240000.00', '1', '2022-08-10 21:09:26'),
(56, 'Sales', 'create', 'invoice_no-1000 total amount-3900000.00', '3', '2022-08-10 21:12:48'),
(57, 'Sales', 'create', 'invoice_no-1001 total amount-420000.00', '3', '2022-08-10 21:14:57'),
(58, 'Product', 'create', 'product ID :7', '1', '2022-08-10 21:58:28'),
(59, 'Customer', 'delete', 'customer ID :29', '1', '2022-08-10 22:21:48'),
(60, 'Customer', 'delete', 'customer ID :30', '1', '2022-08-10 22:21:59'),
(61, 'Customer', 'delete', 'customer ID :34', '1', '2022-08-10 22:22:47'),
(62, 'Customer', 'delete', 'customer ID :33', '1', '2022-08-10 22:22:51');

-- --------------------------------------------------------

--
-- Table structure for table `acc_coa`
--

CREATE TABLE `acc_coa` (
  `HeadCode` varchar(50) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `HeadName` varchar(100) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `PHeadName` varchar(50) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `HeadLevel` int(11) NOT NULL,
  `IsActive` tinyint(1) NOT NULL,
  `IsTransaction` tinyint(1) NOT NULL,
  `IsGL` tinyint(1) NOT NULL,
  `HeadType` char(1) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `IsBudget` tinyint(1) NOT NULL,
  `IsDepreciation` tinyint(1) NOT NULL,
  `DepreciationRate` decimal(18,2) NOT NULL,
  `CreateBy` varchar(50) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `CreateDate` datetime NOT NULL,
  `UpdateBy` varchar(50) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `UpdateDate` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `acc_coa`
--

INSERT INTO `acc_coa` (`HeadCode`, `HeadName`, `PHeadName`, `HeadLevel`, `IsActive`, `IsTransaction`, `IsGL`, `HeadType`, `IsBudget`, `IsDepreciation`, `DepreciationRate`, `CreateBy`, `CreateDate`, `UpdateBy`, `UpdateDate`) VALUES
('1020301000001', '837883-AGABA ANDREW', 'Customer Receivable', 4, 1, 1, 0, 'A', 0, 0, '0.00', '1', '2022-08-08 20:23:50', '', '0000-00-00 00:00:00'),
('4021403', 'AC', 'Repair and Maintenance', 3, 1, 1, 0, 'E', 0, 0, '0.00', 'admin', '2015-10-15 19:33:55', '', '2015-10-15 00:00:00'),
('50202', 'Account Payable', 'Current Liabilities', 2, 1, 0, 1, 'L', 0, 0, '0.00', 'admin', '2015-10-15 19:50:43', '', '2015-10-15 00:00:00'),
('10203', 'Account Receivable', 'Current Asset', 2, 1, 0, 0, 'A', 0, 0, '0.00', '', '2015-10-15 00:00:00', 'admin', '2013-09-18 15:29:35'),
('1020201', 'Advance', 'Advance, Deposit And Pre-payments', 3, 1, 0, 1, 'A', 0, 0, '0.00', 'Zoherul', '2015-05-31 13:29:12', 'admin', '2015-12-31 16:46:32'),
('102020103', 'Advance House Rent', 'Advance', 4, 1, 1, 0, 'A', 0, 0, '0.00', 'admin', '2016-10-02 16:55:38', 'admin', '2016-10-02 16:57:32'),
('10202', 'Advance, Deposit And Pre-payments', 'Current Asset', 2, 1, 0, 0, 'A', 0, 0, '0.00', '', '2015-10-15 00:00:00', 'admin', '2015-12-31 16:46:24'),
('4020602', 'Advertisement and Publicity', 'Promonational Expence', 3, 1, 1, 0, 'E', 0, 0, '0.00', 'admin', '2015-10-15 18:51:44', '', '2015-10-15 00:00:00'),
('1010410', 'Air Cooler', 'Others Assets', 3, 1, 1, 0, 'A', 0, 0, '0.00', 'admin', '2016-05-23 12:13:55', '', '2015-10-15 00:00:00'),
('4020603', 'AIT Against Advertisement', 'Promonational Expence', 3, 1, 1, 0, 'E', 0, 0, '0.00', 'admin', '2015-10-15 18:52:09', '', '2015-10-15 00:00:00'),
('1', 'Assets', 'COA', 0, 1, 0, 0, 'A', 0, 0, '0.00', '', '2015-10-15 00:00:00', '', '2015-10-15 00:00:00'),
('1010204', 'Attendance Machine', 'Office Equipment', 3, 1, 1, 0, 'A', 0, 0, '0.00', 'admin', '2015-10-15 15:49:31', '', '2015-10-15 00:00:00'),
('40216', 'Audit Fee', 'Other Expenses', 2, 1, 1, 1, 'E', 0, 0, '0.00', 'admin', '2017-07-18 12:54:30', '', '2015-10-15 00:00:00'),
('102010202', 'Bank AlFalah', 'Cash At Bank', 4, 1, 1, 1, 'A', 0, 0, '0.00', 'admin', '2015-10-15 15:32:37', 'admin', '2015-10-15 15:32:52'),
('4021002', 'Bank Charge', 'Financial Expenses', 3, 1, 1, 0, 'E', 0, 0, '0.00', 'admin', '2015-10-15 19:21:03', '', '2015-10-15 00:00:00'),
('30203', 'Bank Interest', 'Other Income', 2, 1, 1, 1, 'I', 0, 0, '0.00', 'Obaidul', '2015-01-03 14:49:54', 'admin', '2016-09-25 11:04:19'),
('40100003', 'Bombo-Bombo', 'Store Expenses', 2, 1, 1, 0, 'E', 0, 0, '0.00', '1', '2022-07-31 21:46:51', '', '0000-00-00 00:00:00'),
('1010104', 'Book Shelf', 'Furniture & Fixturers', 3, 1, 1, 0, 'A', 0, 0, '0.00', 'admin', '2015-10-15 15:46:11', '', '2015-10-15 00:00:00'),
('1010407', 'Books and Journal', 'Others Assets', 3, 1, 1, 0, 'A', 0, 0, '0.00', 'admin', '2016-03-27 10:45:37', '', '2015-10-15 00:00:00'),
('10201020301', 'Branch 1', 'Standard Bank', 5, 1, 1, 1, 'A', 0, 0, '0.00', '2', '2018-07-19 13:44:33', '', '2015-10-15 00:00:00'),
('4020604', 'Business Development Expenses', 'Promonational Expence', 3, 1, 1, 0, 'E', 0, 0, '0.00', 'admin', '2015-10-15 18:52:29', '', '2015-10-15 00:00:00'),
('4020606', 'Campaign Expenses', 'Promonational Expence', 3, 1, 1, 0, 'E', 0, 0, '0.00', 'admin', '2015-10-15 18:52:57', 'admin', '2016-09-19 14:52:48'),
('4020502', 'Campus Rent', 'House Rent', 3, 1, 1, 0, 'E', 0, 0, '0.00', 'admin', '2015-10-15 18:46:53', 'admin', '2017-04-27 17:02:39'),
('40212', 'Car Running Expenses', 'Other Expenses', 2, 1, 0, 1, 'E', 0, 0, '0.00', 'admin', '2015-10-15 19:28:43', '', '2015-10-15 00:00:00'),
('10201', 'Cash & Cash Equivalent', 'Current Asset', 2, 1, 0, 0, 'A', 0, 0, '0.00', '', '2015-10-15 00:00:00', 'admin', '2015-10-15 15:57:55'),
('1020102', 'Cash At Bank', 'Cash & Cash Equivalent', 3, 1, 0, 0, 'A', 0, 0, '0.00', '2', '2018-07-19 13:43:59', 'admin', '2015-10-15 15:32:42'),
('1020101', 'Cash In Hand', 'Cash & Cash Equivalent', 3, 1, 1, 1, 'A', 0, 0, '0.00', '2', '2018-07-31 12:56:28', 'admin', '2016-05-23 12:05:43'),
('30101', 'Cash Sale', 'Store Income', 1, 1, 1, 1, 'I', 0, 0, '0.00', '2', '2018-07-08 07:51:26', '', '2015-10-15 00:00:00'),
('1020101000001', 'Cash-Bombo-Bombo', 'Cash In Hand', 4, 1, 1, 0, 'A', 0, 0, '0.00', '1', '2022-07-31 21:46:51', '', '0000-00-00 00:00:00'),
('1020101000002', 'Cash-Mbarara-Mbarara', 'Cash In Hand', 4, 1, 1, 0, 'A', 0, 0, '0.00', '1', '2022-07-31 21:47:14', '', '0000-00-00 00:00:00'),
('1010207', 'CCTV', 'Office Equipment', 3, 1, 1, 0, 'A', 0, 0, '0.00', 'admin', '2015-10-15 15:51:24', '', '2015-10-15 00:00:00'),
('102020102', 'CEO Current A/C', 'Advance', 4, 1, 1, 0, 'A', 0, 0, '0.00', 'admin', '2016-09-25 11:54:54', '', '2015-10-15 00:00:00'),
('1010101', 'Class Room Chair', 'Furniture & Fixturers', 3, 1, 1, 0, 'A', 0, 0, '0.00', 'admin', '2015-10-15 15:45:29', '', '2015-10-15 00:00:00'),
('4021407', 'Close Circuit Cemera', 'Repair and Maintenance', 3, 1, 1, 0, 'E', 0, 0, '0.00', 'admin', '2015-10-15 19:35:35', '', '2015-10-15 00:00:00'),
('4020601', 'Commision on Admission', 'Promonational Expence', 3, 1, 1, 0, 'E', 0, 0, '0.00', 'admin', '2015-10-15 18:51:21', 'admin', '2016-09-19 14:42:54'),
('1010206', 'Computer', 'Office Equipment', 3, 1, 1, 0, 'A', 0, 0, '0.00', 'admin', '2015-10-15 15:51:09', '', '2015-10-15 00:00:00'),
('4021410', 'Computer (R)', 'Repair and Maintenance', 3, 1, 1, 0, 'E', 0, 0, '0.00', 'Zoherul', '2016-03-24 12:38:52', 'Zoherul', '2016-03-24 12:41:40'),
('1010102', 'Computer Table', 'Furniture & Fixturers', 3, 1, 1, 0, 'A', 0, 0, '0.00', 'admin', '2015-10-15 15:45:44', '', '2015-10-15 00:00:00'),
('301020401', 'Continuing Registration fee - UoL (Income)', 'Registration Fee (UOL) Income', 4, 1, 1, 0, 'I', 0, 0, '0.00', 'admin', '2015-10-15 17:40:40', '', '2015-10-15 00:00:00'),
('4020904', 'Contratuall Staff Salary', 'Salary & Allowances', 3, 1, 1, 0, 'E', 0, 0, '0.00', 'admin', '2015-10-15 19:12:34', '', '2015-10-15 00:00:00'),
('403', 'Cost of Sale', 'Expence', 0, 1, 1, 0, 'E', 0, 0, '0.00', '2', '2018-07-08 10:37:16', '', '2015-10-15 00:00:00'),
('4020709', 'Cultural Expense', 'Miscellaneous Expenses', 3, 1, 1, 0, 'E', 0, 0, '0.00', 'nasmud', '2017-04-29 12:45:10', '', '2015-10-15 00:00:00'),
('102', 'Current Asset', 'Assets', 1, 1, 0, 0, 'A', 0, 0, '0.00', '', '2015-10-15 00:00:00', 'admin', '2018-07-07 11:23:00'),
('502', 'Current Liabilities', 'Liabilities', 1, 1, 0, 0, 'L', 0, 0, '0.00', 'anwarul', '2014-08-30 13:18:20', 'admin', '2015-10-15 19:49:21'),
('1020301', 'Customer Receivable', 'Account Receivable', 3, 1, 0, 1, 'A', 0, 0, '0.00', 'admin', '2015-10-15 15:34:31', 'admin', '2018-07-07 12:31:42'),
('40100002', 'cw-Chichawatni', 'Store Expenses', 2, 1, 1, 0, 'E', 0, 0, '0.00', '2', '2018-08-02 16:30:41', '', '2015-10-15 00:00:00'),
('1020202', 'Deposit', 'Advance, Deposit And Pre-payments', 3, 1, 0, 0, 'A', 0, 0, '0.00', 'admin', '2015-10-15 15:40:42', '', '2015-10-15 00:00:00'),
('4020605', 'Design & Printing Expense', 'Promonational Expence', 3, 1, 1, 0, 'E', 0, 0, '0.00', 'admin', '2015-10-15 18:55:00', '', '2015-10-15 00:00:00'),
('4020404', 'Dish Bill', 'Utility Expenses', 3, 1, 1, 0, 'E', 0, 0, '0.00', 'admin', '2015-10-15 18:58:21', '', '2015-10-15 00:00:00'),
('40215', 'Dividend', 'Other Expenses', 2, 1, 1, 1, 'E', 0, 0, '0.00', 'admin', '2016-09-25 14:07:55', '', '2015-10-15 00:00:00'),
('4020403', 'Drinking Water Bill', 'Utility Expenses', 3, 1, 1, 0, 'E', 0, 0, '0.00', 'admin', '2015-10-15 18:58:10', '', '2015-10-15 00:00:00'),
('1010211', 'DSLR Camera', 'Office Equipment', 3, 1, 1, 0, 'A', 0, 0, '0.00', 'admin', '2015-10-15 15:53:17', 'admin', '2016-01-02 16:23:25'),
('4020908', 'Earned Leave', 'Salary & Allowances', 3, 1, 1, 0, 'E', 0, 0, '0.00', 'admin', '2015-10-15 19:13:38', '', '2015-10-15 00:00:00'),
('4020607', 'Education Fair Expenses', 'Promonational Expence', 3, 1, 1, 0, 'E', 0, 0, '0.00', 'admin', '2015-10-15 18:53:42', '', '2015-10-15 00:00:00'),
('1010602', 'Electric Equipment', 'Electrical Equipment', 3, 1, 1, 0, 'A', 0, 0, '0.00', 'admin', '2016-03-27 10:44:51', '', '2015-10-15 00:00:00'),
('1010203', 'Electric Kettle', 'Office Equipment', 3, 1, 1, 0, 'A', 0, 0, '0.00', 'admin', '2015-10-15 15:49:07', '', '2015-10-15 00:00:00'),
('10106', 'Electrical Equipment', 'Non Current Assets', 2, 1, 0, 1, 'A', 0, 0, '0.00', 'admin', '2016-03-27 10:43:44', '', '2015-10-15 00:00:00'),
('4020407', 'Electricity Bill', 'Utility Expenses', 3, 1, 1, 0, 'E', 0, 0, '0.00', 'admin', '2015-10-15 18:59:31', '', '2015-10-15 00:00:00'),
('10202010501', 'employ', 'Salary', 5, 1, 0, 0, 'A', 0, 0, '0.00', 'admin', '2018-07-05 11:47:10', '', '2015-10-15 00:00:00'),
('40201', 'Entertainment', 'Other Expenses', 2, 1, 1, 1, 'E', 0, 0, '0.00', 'admin', '2013-07-08 16:21:26', 'anwarul', '2013-07-17 14:21:47'),
('2', 'Equity', 'COA', 0, 1, 0, 0, 'L', 0, 0, '0.00', '', '2015-10-15 00:00:00', '', '2015-10-15 00:00:00'),
('4', 'Expence', 'COA', 0, 1, 0, 0, 'E', 0, 0, '0.00', '', '2015-10-15 00:00:00', '', '2015-10-15 00:00:00'),
('4020903', 'Faculty,Staff Salary & Allowances', 'Salary & Allowances', 3, 1, 1, 0, 'E', 0, 0, '0.00', 'admin', '2015-10-15 19:12:21', '', '2015-10-15 00:00:00'),
('4021404', 'Fax Machine', 'Repair and Maintenance', 3, 1, 1, 0, 'E', 0, 0, '0.00', 'admin', '2015-10-15 19:34:15', '', '2015-10-15 00:00:00'),
('4020905', 'Festival & Incentive Bonus', 'Salary & Allowances', 3, 1, 1, 0, 'E', 0, 0, '0.00', 'admin', '2015-10-15 19:12:48', '', '2015-10-15 00:00:00'),
('1010103', 'File Cabinet', 'Furniture & Fixturers', 3, 1, 1, 0, 'A', 0, 0, '0.00', 'admin', '2015-10-15 15:46:02', '', '2015-10-15 00:00:00'),
('40210', 'Financial Expenses', 'Other Expenses', 2, 1, 0, 1, 'E', 0, 0, '0.00', 'anwarul', '2013-08-20 12:24:31', 'admin', '2015-10-15 19:20:36'),
('1010403', 'Fire Extingushier', 'Others Assets', 3, 1, 1, 0, 'A', 0, 0, '0.00', 'admin', '2016-03-27 10:39:32', '', '2015-10-15 00:00:00'),
('4021408', 'Furniture', 'Repair and Maintenance', 3, 1, 1, 0, 'E', 0, 0, '0.00', 'admin', '2015-10-15 19:35:47', '', '2015-10-15 00:00:00'),
('10101', 'Furniture & Fixturers', 'Non Current Assets', 2, 1, 0, 1, 'A', 0, 0, '0.00', 'anwarul', '2013-08-20 16:18:15', 'anwarul', '2013-08-21 13:35:40'),
('4020406', 'Gas Bill', 'Utility Expenses', 3, 1, 1, 0, 'E', 0, 0, '0.00', 'admin', '2015-10-15 18:59:20', '', '2015-10-15 00:00:00'),
('20201', 'General Reserve', 'Reserve & Surplus', 2, 1, 1, 0, 'L', 0, 0, '0.00', 'admin', '2016-09-25 14:07:12', 'admin', '2016-10-02 17:48:49'),
('10105', 'Generator', 'Non Current Assets', 2, 1, 1, 1, 'A', 0, 0, '0.00', 'Zoherul', '2016-02-27 16:02:35', 'admin', '2016-05-23 12:05:18'),
('4021414', 'Generator Repair', 'Repair and Maintenance', 3, 1, 1, 0, 'E', 0, 0, '0.00', 'Zoherul', '2016-06-16 10:21:05', '', '2015-10-15 00:00:00'),
('40213', 'Generator Running Expenses', 'Other Expenses', 2, 1, 0, 1, 'E', 0, 0, '0.00', 'admin', '2015-10-15 19:29:29', '', '2015-10-15 00:00:00'),
('10103', 'Groceries and Cutleries', 'Non Current Assets', 2, 1, 1, 1, 'A', 0, 0, '0.00', '2', '2018-07-12 10:02:55', '', '2015-10-15 00:00:00'),
('1010408', 'Gym Equipment', 'Others Assets', 3, 1, 1, 0, 'A', 0, 0, '0.00', 'admin', '2016-03-27 10:46:03', '', '2015-10-15 00:00:00'),
('4020907', 'Honorarium', 'Salary & Allowances', 3, 1, 1, 0, 'E', 0, 0, '0.00', 'admin', '2015-10-15 19:13:26', '', '2015-10-15 00:00:00'),
('40205', 'House Rent', 'Other Expenses', 2, 1, 0, 1, 'E', 0, 0, '0.00', 'anwarul', '2013-08-24 10:26:56', '', '2015-10-15 00:00:00'),
('40100001', 'HP-Hasilpur', 'Academic Expenses', 2, 1, 1, 0, 'E', 0, 0, '0.00', '2', '2018-07-29 03:44:23', '', '2015-10-15 00:00:00'),
('4020702', 'HR Recruitment Expenses', 'Miscellaneous Expenses', 3, 1, 1, 0, 'E', 0, 0, '0.00', 'admin', '2016-09-25 12:55:49', '', '2015-10-15 00:00:00'),
('4020703', 'Incentive on Admission', 'Miscellaneous Expenses', 3, 1, 1, 0, 'E', 0, 0, '0.00', 'admin', '2016-09-25 12:56:09', '', '2015-10-15 00:00:00'),
('3', 'Income', 'COA', 0, 1, 0, 0, 'I', 0, 0, '0.00', '', '2015-10-15 00:00:00', '', '2015-10-15 00:00:00'),
('30204', 'Income from Photocopy & Printing', 'Other Income', 2, 1, 1, 1, 'I', 0, 0, '0.00', 'Zoherul', '2015-07-14 10:29:54', 'admin', '2016-09-25 11:04:28'),
('5020302', 'Income Tax Payable', 'Liabilities for Expenses', 3, 1, 0, 1, 'L', 0, 0, '0.00', 'admin', '2016-09-19 11:18:17', 'admin', '2016-09-28 13:18:35'),
('102020302', 'Insurance Premium', 'Prepayment', 4, 1, 1, 0, 'A', 0, 0, '0.00', 'admin', '2016-09-19 13:10:57', '', '2015-10-15 00:00:00'),
('4021001', 'Interest on Loan', 'Financial Expenses', 3, 1, 1, 0, 'E', 0, 0, '0.00', 'admin', '2015-10-15 19:20:53', 'admin', '2016-09-19 14:53:34'),
('4020401', 'Internet Bill', 'Utility Expenses', 3, 1, 1, 0, 'E', 0, 0, '0.00', 'admin', '2015-10-15 18:56:55', 'admin', '2015-10-15 18:57:32'),
('10107', 'Inventory', 'Non Current Assets', 1, 1, 0, 0, 'A', 0, 0, '0.00', '2', '2018-07-07 15:21:58', '', '2015-10-15 00:00:00'),
('10205010101', 'Jahangir', 'Hasan', 1, 1, 0, 0, 'A', 0, 0, '0.00', '2', '2018-07-07 10:40:56', '', '2015-10-15 00:00:00'),
('1010210', 'LCD TV', 'Office Equipment', 3, 1, 1, 0, 'A', 0, 0, '0.00', 'admin', '2015-10-15 15:52:27', '', '2015-10-15 00:00:00'),
('30103', 'Lease Sale', 'Store Income', 1, 1, 1, 1, 'I', 0, 0, '0.00', '2', '2018-07-08 07:51:52', '', '2015-10-15 00:00:00'),
('5', 'Liabilities', 'COA', 0, 1, 0, 0, 'L', 0, 0, '0.00', 'admin', '2013-07-04 12:32:07', 'admin', '2015-10-15 19:46:54'),
('50203', 'Liabilities for Expenses', 'Current Liabilities', 2, 1, 0, 0, 'L', 0, 0, '0.00', 'admin', '2015-10-15 19:50:59', '', '2015-10-15 00:00:00'),
('4020707', 'Library Expenses', 'Miscellaneous Expenses', 3, 1, 1, 0, 'E', 0, 0, '0.00', 'admin', '2017-01-10 15:34:54', '', '2015-10-15 00:00:00'),
('4021409', 'Lift', 'Repair and Maintenance', 3, 1, 1, 0, 'E', 0, 0, '0.00', 'admin', '2015-10-15 19:36:12', '', '2015-10-15 00:00:00'),
('50101', 'Long Term Borrowing', 'Non Current Liabilities', 2, 1, 0, 1, 'L', 0, 0, '0.00', 'admin', '2013-07-04 12:32:26', 'admin', '2015-10-15 19:47:40'),
('4020608', 'Marketing & Promotion Exp.', 'Promonational Expence', 3, 1, 1, 0, 'E', 0, 0, '0.00', 'admin', '2015-10-15 18:53:59', '', '2015-10-15 00:00:00'),
('40100004', 'Mbarara-Mbarara', 'Store Expenses', 2, 1, 1, 0, 'E', 0, 0, '0.00', '1', '2022-07-31 21:47:14', '', '0000-00-00 00:00:00'),
('4020901', 'Medical Allowance', 'Salary & Allowances', 3, 1, 1, 0, 'E', 0, 0, '0.00', 'admin', '2015-10-15 19:11:33', '', '2015-10-15 00:00:00'),
('1010411', 'Metal Ditector', 'Others Assets', 3, 1, 1, 0, 'A', 0, 0, '0.00', 'Zoherul', '2016-08-22 10:55:22', '', '2015-10-15 00:00:00'),
('4021413', 'Micro Oven', 'Repair and Maintenance', 3, 1, 1, 0, 'E', 0, 0, '0.00', 'Zoherul', '2016-05-12 14:53:51', '', '2015-10-15 00:00:00'),
('30202', 'Miscellaneous (Income)', 'Other Income', 2, 1, 1, 1, 'I', 0, 0, '0.00', 'anwarul', '2014-02-06 15:26:31', 'admin', '2016-09-25 11:04:35'),
('4020909', 'Miscellaneous Benifit', 'Salary & Allowances', 3, 1, 1, 0, 'E', 0, 0, '0.00', 'admin', '2015-10-15 19:13:53', '', '2015-10-15 00:00:00'),
('4020701', 'Miscellaneous Exp', 'Miscellaneous Expenses', 3, 1, 1, 0, 'E', 0, 0, '0.00', 'admin', '2016-09-25 12:54:39', '', '2015-10-15 00:00:00'),
('40207', 'Miscellaneous Expenses', 'Other Expenses', 2, 1, 0, 1, 'E', 0, 0, '0.00', 'anwarul', '2014-04-26 16:49:56', 'admin', '2016-09-25 12:54:19'),
('1010401', 'Mobile Phone', 'Others Assets', 3, 1, 1, 0, 'A', 0, 0, '0.00', 'admin', '2016-01-29 10:43:30', '', '2015-10-15 00:00:00'),
('102020101', 'Mr Ashiqur Rahman', 'Advance', 4, 1, 1, 0, 'A', 0, 0, '0.00', 'admin', '2015-12-31 16:47:23', 'admin', '2016-09-25 11:55:13'),
('1010212', 'Network Accessories', 'Office Equipment', 3, 1, 1, 0, 'A', 0, 0, '0.00', 'admin', '2016-01-02 16:23:32', '', '2015-10-15 00:00:00'),
('4020408', 'News Paper Bill', 'Utility Expenses', 3, 1, 1, 0, 'E', 0, 0, '0.00', 'admin', '2016-01-02 15:55:57', '', '2015-10-15 00:00:00'),
('101', 'Non Current Assets', 'Assets', 1, 1, 0, 0, 'A', 0, 0, '0.00', '', '2015-10-15 00:00:00', 'admin', '2015-10-15 15:29:11'),
('501', 'Non Current Liabilities', 'Liabilities', 1, 1, 0, 0, 'L', 0, 0, '0.00', 'anwarul', '2014-08-30 13:18:20', 'admin', '2015-10-15 19:49:21'),
('1010404', 'Office Decoration', 'Others Assets', 3, 1, 1, 0, 'A', 0, 0, '0.00', 'admin', '2016-03-27 10:40:02', '', '2015-10-15 00:00:00'),
('10102', 'Office Equipment', 'Non Current Assets', 2, 1, 0, 1, 'A', 0, 0, '0.00', 'anwarul', '2013-12-06 18:08:00', 'admin', '2015-10-15 15:48:21'),
('4021401', 'Office Repair & Maintenance', 'Repair and Maintenance', 3, 1, 1, 0, 'E', 0, 0, '0.00', 'admin', '2015-10-15 19:33:15', '', '2015-10-15 00:00:00'),
('30201', 'Office Stationary (Income)', 'Other Income', 2, 1, 1, 1, 'I', 0, 0, '0.00', 'anwarul', '2013-07-17 15:21:06', 'admin', '2016-09-25 11:04:50'),
('402', 'Other Expenses', 'Expence', 1, 1, 0, 0, 'E', 0, 0, '0.00', '2', '2018-07-07 14:00:16', 'admin', '2015-10-15 18:37:42'),
('302', 'Other Income', 'Income', 1, 1, 0, 0, 'I', 0, 0, '0.00', '2', '2018-07-07 13:40:57', 'admin', '2016-09-25 11:04:09'),
('40211', 'Others (Non Academic Expenses)', 'Other Expenses', 2, 1, 0, 1, 'E', 0, 0, '0.00', 'Obaidul', '2014-12-03 16:05:42', 'admin', '2015-10-15 19:22:09'),
('30205', 'Others (Non-Academic Income)', 'Other Income', 2, 1, 0, 1, 'I', 0, 0, '0.00', 'admin', '2015-10-15 17:23:49', 'admin', '2015-10-15 17:57:52'),
('10104', 'Others Assets', 'Non Current Assets', 2, 1, 0, 1, 'A', 0, 0, '0.00', 'admin', '2016-01-29 10:43:16', '', '2015-10-15 00:00:00'),
('4020910', 'Outstanding Salary', 'Salary & Allowances', 3, 1, 1, 0, 'E', 0, 0, '0.00', 'Zoherul', '2016-04-24 11:56:50', '', '2015-10-15 00:00:00'),
('4021405', 'Oven', 'Repair and Maintenance', 3, 1, 1, 0, 'E', 0, 0, '0.00', 'admin', '2015-10-15 19:34:31', '', '2015-10-15 00:00:00'),
('4021412', 'PABX-Repair', 'Repair and Maintenance', 3, 1, 1, 0, 'E', 0, 0, '0.00', 'Zoherul', '2016-04-24 14:40:18', '', '2015-10-15 00:00:00'),
('4020902', 'Part-time Staff Salary', 'Salary & Allowances', 3, 1, 1, 0, 'E', 0, 0, '0.00', 'admin', '2015-10-15 19:12:06', '', '2015-10-15 00:00:00'),
('1010202', 'Photocopy & Fax Machine', 'Office Equipment', 3, 1, 1, 0, 'A', 0, 0, '0.00', 'admin', '2015-10-15 15:47:27', 'admin', '2016-05-23 12:14:40'),
('4021411', 'Photocopy Machine Repair', 'Repair and Maintenance', 3, 1, 1, 0, 'E', 0, 0, '0.00', 'Zoherul', '2016-04-24 12:40:02', 'admin', '2017-04-27 17:03:17'),
('3020503', 'Practical Fee', 'Others (Non-Academic Income)', 3, 1, 1, 1, 'I', 0, 0, '0.00', 'admin', '2017-07-22 18:00:37', '', '2015-10-15 00:00:00'),
('1020203', 'Prepayment', 'Advance, Deposit And Pre-payments', 3, 1, 0, 1, 'A', 0, 0, '0.00', 'admin', '2015-10-15 15:40:51', 'admin', '2015-12-31 16:49:58'),
('1010201', 'Printer', 'Office Equipment', 3, 1, 1, 0, 'A', 0, 0, '0.00', 'admin', '2015-10-15 15:47:15', '', '2015-10-15 00:00:00'),
('40202', 'Printing and Stationary', 'Other Expenses', 2, 1, 1, 1, 'E', 0, 0, '0.00', 'admin', '2013-07-08 16:21:45', 'admin', '2016-09-19 14:39:32'),
('3020502', 'Professional Training Course(Oracal-1)', 'Others (Non-Academic Income)', 3, 1, 1, 0, 'I', 0, 0, '0.00', 'nasim', '2017-06-22 13:28:05', '', '2015-10-15 00:00:00'),
('30207', 'Professional Training Course(Oracal)', 'Other Income', 2, 1, 0, 1, 'I', 0, 0, '0.00', 'nasim', '2017-06-22 13:24:16', 'nasim', '2017-06-22 13:25:56'),
('1010208', 'Projector', 'Office Equipment', 3, 1, 1, 0, 'A', 0, 0, '0.00', 'admin', '2015-10-15 15:51:44', '', '2015-10-15 00:00:00'),
('40206', 'Promonational Expence', 'Other Expenses', 2, 1, 0, 1, 'E', 0, 0, '0.00', 'anwarul', '2013-07-11 13:48:57', 'anwarul', '2013-07-17 14:23:03'),
('40214', 'Repair and Maintenance', 'Other Expenses', 2, 1, 0, 1, 'E', 0, 0, '0.00', 'admin', '2015-10-15 19:32:46', '', '2015-10-15 00:00:00'),
('202', 'Reserve & Surplus', 'Equity', 1, 1, 0, 1, 'L', 0, 0, '0.00', 'admin', '2016-09-25 14:06:34', 'admin', '2016-10-02 17:48:57'),
('20102', 'Retained Earnings', 'Share Holders Equity', 2, 1, 1, 1, 'L', 0, 0, '0.00', 'admin', '2016-05-23 11:20:40', 'admin', '2016-09-25 14:05:06'),
('4020708', 'River Cruse', 'Miscellaneous Expenses', 3, 1, 1, 0, 'E', 0, 0, '0.00', 'admin', '2017-04-24 15:35:25', '', '2015-10-15 00:00:00'),
('102020105', 'Salary', 'Advance', 4, 1, 0, 0, 'A', 0, 0, '0.00', 'admin', '2018-07-05 11:46:44', '', '2015-10-15 00:00:00'),
('40209', 'Salary & Allowances', 'Other Expenses', 2, 1, 0, 1, 'E', 0, 0, '0.00', 'anwarul', '2013-12-12 11:22:58', '', '2015-10-15 00:00:00'),
('404', 'Sale Discount', 'Expence', 1, 1, 1, 0, 'E', 0, 0, '0.00', '2', '2018-07-19 10:15:11', '', '2015-10-15 00:00:00'),
('1010406', 'Security Equipment', 'Others Assets', 3, 1, 1, 0, 'A', 0, 0, '0.00', 'admin', '2016-03-27 10:41:30', '', '2015-10-15 00:00:00'),
('20101', 'Share Capital', 'Share Holders Equity', 2, 1, 0, 1, 'L', 0, 0, '0.00', 'anwarul', '2013-12-08 19:37:32', 'admin', '2015-10-15 19:45:35'),
('201', 'Share Holders Equity', 'Equity', 1, 1, 0, 0, 'L', 0, 0, '0.00', '', '2015-10-15 00:00:00', 'admin', '2015-10-15 19:43:51'),
('50201', 'Short Term Borrowing', 'Current Liabilities', 2, 1, 0, 1, 'L', 0, 0, '0.00', 'admin', '2015-10-15 19:50:30', '', '2015-10-15 00:00:00'),
('5020200001', 'Smart Power & Techologies', 'Account Payable', 3, 1, 1, 0, 'L', 0, 0, '0.00', 'admin', '2016-09-25 11:45:12', '', '2015-10-15 00:00:00'),
('40208', 'Software Development Expenses', 'Other Expenses', 2, 1, 0, 1, 'E', 0, 0, '0.00', 'anwarul', '2013-11-21 14:13:01', 'admin', '2015-10-15 19:02:51'),
('4020906', 'Special Allowances', 'Salary & Allowances', 3, 1, 1, 0, 'E', 0, 0, '0.00', 'admin', '2015-10-15 19:13:13', '', '2015-10-15 00:00:00'),
('50102', 'Sponsors Loan', 'Non Current Liabilities', 2, 1, 0, 1, 'L', 0, 0, '0.00', 'admin', '2015-10-15 19:48:02', '', '2015-10-15 00:00:00'),
('4020706', 'Sports Expense', 'Miscellaneous Expenses', 3, 1, 1, 0, 'E', 0, 0, '0.00', 'nasmud', '2016-11-09 13:16:53', '', '2015-10-15 00:00:00'),
('102010203', 'Standard Bank', 'Cash At Bank', 4, 1, 1, 1, 'A', 0, 0, '0.00', 'admin', '2015-10-15 15:33:33', 'admin', '2015-10-15 15:33:48'),
('102010204', 'State Bank', 'Cash At Bank', 4, 1, 1, 1, 'A', 0, 0, '0.00', 'admin', '2015-12-31 16:44:14', '', '2015-10-15 00:00:00'),
('401', 'Store Expenses', 'Expence', 1, 1, 0, 0, 'E', 0, 0, '0.00', '2', '2018-07-07 13:38:59', 'admin', '2015-10-15 17:58:46'),
('301', 'Store Income', 'Income', 1, 1, 0, 0, 'I', 0, 0, '0.00', '2', '2018-07-07 13:40:37', 'admin', '2015-09-17 17:00:02'),
('3020501', 'Students Info. Correction Fee', 'Others (Non-Academic Income)', 3, 1, 1, 0, 'I', 0, 0, '0.00', 'admin', '2015-10-15 17:24:45', '', '2015-10-15 00:00:00'),
('1010601', 'Sub Station', 'Electrical Equipment', 3, 1, 1, 0, 'A', 0, 0, '0.00', 'admin', '2016-03-27 10:44:11', '', '2015-10-15 00:00:00'),
('5020200009', 'sup-1-MS ROOFINGS', 'Account Payable', 3, 1, 1, 0, 'L', 0, 0, '0.00', '1', '2022-08-07 15:02:26', '', '0000-00-00 00:00:00'),
('5020200008', 'sup-1-Mukawno', 'Account Payable', 3, 1, 1, 0, 'L', 0, 0, '0.00', '1', '2022-07-31 21:49:48', '', '0000-00-00 00:00:00'),
('5020200010', 'sup-2-MS UGANDA BAATI LTD', 'Account Payable', 3, 1, 1, 0, 'L', 0, 0, '0.00', '1', '2022-08-07 15:02:55', '', '0000-00-00 00:00:00'),
('5020200011', 'sup-3-MS MMI STEEL MILLSLTS/KIBOKO', 'Account Payable', 3, 1, 1, 0, 'L', 0, 0, '0.00', '1', '2022-08-07 15:03:12', '', '0000-00-00 00:00:00'),
('5020200006', 'sup-4-Eco star', 'Account Payable', 3, 1, 1, 0, 'L', 0, 0, '0.00', '2', '2018-07-27 10:15:58', '', '2015-10-15 00:00:00'),
('5020200012', 'sup-4-MS GOOD WILL UGANDA LTD', 'Account Payable', 3, 1, 1, 0, 'L', 0, 0, '0.00', '1', '2022-08-07 15:03:32', '', '0000-00-00 00:00:00'),
('5020200013', 'sup-5-MS HIMA CEMENT LTD', 'Account Payable', 3, 1, 1, 0, 'L', 0, 0, '0.00', '1', '2022-08-07 15:03:45', '', '0000-00-00 00:00:00'),
('5020200007', 'sup-5-New', 'Account Payable', 3, 1, 1, 0, 'L', 0, 0, '0.00', '2', '2018-08-02 16:23:42', '', '2015-10-15 00:00:00'),
('5020200002', 'sup-5-Sharif', 'Account Payable', 3, 1, 1, 0, 'L', 0, 0, '0.00', '2', '2018-07-12 10:04:21', '', '2015-10-15 00:00:00'),
('5020200014', 'sup-6-MS TORORO CEMENT LTD', 'Account Payable', 3, 1, 1, 0, 'L', 0, 0, '0.00', '1', '2022-08-07 15:03:58', '', '0000-00-00 00:00:00'),
('5020200003', 'sup-6-Talha', 'Account Payable', 3, 1, 1, 0, 'L', 0, 0, '0.00', '2', '2018-07-14 10:16:52', '', '2015-10-15 00:00:00'),
('5020200015', 'sup-7-MS KAMPALA CEMENT LTD', 'Account Payable', 3, 1, 1, 0, 'L', 0, 0, '0.00', '1', '2022-08-07 15:04:10', '', '0000-00-00 00:00:00'),
('5020200004', 'sup-7-MS. Tel&Co.', 'Account Payable', 3, 1, 1, 0, 'L', 0, 0, '0.00', '2', '2018-07-19 05:06:18', '', '2015-10-15 00:00:00'),
('5020200005', 'sup-8-july', 'Account Payable', 3, 1, 1, 0, 'L', 0, 0, '0.00', '2', '2018-07-27 09:41:53', '', '2015-10-15 00:00:00'),
('4020704', 'TB Care Expenses', 'Miscellaneous Expenses', 3, 1, 1, 0, 'E', 0, 0, '0.00', 'admin', '2016-10-08 13:03:04', '', '2015-10-15 00:00:00'),
('30206', 'TB Care Income', 'Other Income', 2, 1, 1, 1, 'I', 0, 0, '0.00', 'admin', '2016-10-08 13:00:56', '', '2015-10-15 00:00:00'),
('4020501', 'TDS on House Rent', 'House Rent', 3, 1, 1, 0, 'E', 0, 0, '0.00', 'admin', '2015-10-15 18:44:07', 'admin', '2016-09-19 14:40:16'),
('502030201', 'TDS Payable House Rent', 'Income Tax Payable', 4, 1, 1, 0, 'L', 0, 0, '0.00', 'admin', '2016-09-19 11:19:42', 'admin', '2016-09-28 13:19:37'),
('502030203', 'TDS Payable on Advertisement Bill', 'Income Tax Payable', 4, 1, 1, 0, 'L', 0, 0, '0.00', 'admin', '2016-09-28 13:20:51', '', '2015-10-15 00:00:00'),
('502030202', 'TDS Payable on Salary', 'Income Tax Payable', 4, 1, 1, 0, 'L', 0, 0, '0.00', 'admin', '2016-09-28 13:20:17', '', '2015-10-15 00:00:00'),
('4021402', 'Tea Kettle', 'Repair and Maintenance', 3, 1, 1, 0, 'E', 0, 0, '0.00', 'admin', '2015-10-15 19:33:45', '', '2015-10-15 00:00:00'),
('4020402', 'Telephone Bill', 'Utility Expenses', 3, 1, 1, 0, 'E', 0, 0, '0.00', 'admin', '2015-10-15 18:57:59', '', '2015-10-15 00:00:00'),
('1010209', 'Telephone Set & PABX', 'Office Equipment', 3, 1, 1, 0, 'A', 0, 0, '0.00', 'admin', '2015-10-15 15:51:57', 'admin', '2016-10-02 17:10:40'),
('102020104', 'Test', 'Advance', 4, 1, 1, 0, 'A', 0, 0, '0.00', 'admin', '2018-07-05 11:42:48', '', '2015-10-15 00:00:00'),
('40203', 'Travelling & Conveyance', 'Other Expenses', 2, 1, 1, 1, 'E', 0, 0, '0.00', 'admin', '2013-07-08 16:22:06', 'admin', '2015-10-15 18:45:13'),
('4021406', 'TV', 'Repair and Maintenance', 3, 1, 1, 0, 'E', 0, 0, '0.00', 'admin', '2015-10-15 19:35:07', '', '2015-10-15 00:00:00'),
('1010205', 'UPS', 'Office Equipment', 3, 1, 1, 0, 'A', 0, 0, '0.00', 'admin', '2015-10-15 15:50:38', '', '2015-10-15 00:00:00'),
('40204', 'Utility Expenses', 'Other Expenses', 2, 1, 0, 1, 'E', 0, 0, '0.00', 'anwarul', '2013-07-11 16:20:24', 'admin', '2016-01-02 15:55:22'),
('4020503', 'VAT on House Rent Exp', 'House Rent', 3, 1, 1, 0, 'E', 0, 0, '0.00', 'admin', '2015-10-15 18:49:22', 'admin', '2016-09-25 14:00:52'),
('5020301', 'VAT Payable', 'Liabilities for Expenses', 3, 1, 0, 1, 'L', 0, 0, '0.00', 'admin', '2015-10-15 19:51:11', 'admin', '2016-09-28 13:23:53'),
('1010409', 'Vehicle A/C', 'Others Assets', 3, 1, 1, 0, 'A', 0, 0, '0.00', 'Zoherul', '2016-05-12 12:13:21', '', '2015-10-15 00:00:00'),
('1010405', 'Voltage Stablizer', 'Others Assets', 3, 1, 1, 0, 'A', 0, 0, '0.00', 'admin', '2016-03-27 10:40:59', '', '2015-10-15 00:00:00'),
('1010105', 'Waiting Sofa - Steel', 'Furniture & Fixturers', 3, 1, 1, 0, 'A', 0, 0, '0.00', 'admin', '2015-10-15 15:46:29', '', '2015-10-15 00:00:00'),
('4020405', 'WASA Bill', 'Utility Expenses', 3, 1, 1, 0, 'E', 0, 0, '0.00', 'admin', '2015-10-15 18:58:51', '', '2015-10-15 00:00:00'),
('1010402', 'Water Purifier', 'Others Assets', 3, 1, 1, 0, 'A', 0, 0, '0.00', 'admin', '2016-01-29 11:14:11', '', '2015-10-15 00:00:00'),
('4020705', 'Website Development Expenses', 'Miscellaneous Expenses', 3, 1, 1, 0, 'E', 0, 0, '0.00', 'admin', '2016-10-15 12:42:47', '', '2015-10-15 00:00:00');

-- --------------------------------------------------------

--
-- Table structure for table `acc_customer_income`
--

CREATE TABLE `acc_customer_income` (
  `ID` int(11) NOT NULL,
  `Customer_Id` varchar(50) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `VNo` varchar(50) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `Date` date NOT NULL,
  `Amount` decimal(10,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `acc_glsummarybalance`
--

CREATE TABLE `acc_glsummarybalance` (
  `ID` int(11) NOT NULL,
  `COAID` varchar(50) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL,
  `Debit` decimal(18,2) DEFAULT NULL,
  `Credit` decimal(18,2) DEFAULT NULL,
  `FYear` int(11) DEFAULT NULL,
  `CreateBy` varchar(50) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL,
  `CreateDate` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `acc_income_expence`
--

CREATE TABLE `acc_income_expence` (
  `ID` int(11) NOT NULL,
  `VNo` varchar(50) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `Student_Id` varchar(50) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `Date` date NOT NULL,
  `Paymode` varchar(50) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `Perpose` varchar(50) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `Narration` text CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `StoreID` int(11) NOT NULL,
  `COAID` varchar(50) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `Amount` decimal(10,2) NOT NULL,
  `IsApprove` tinyint(4) NOT NULL,
  `CreateBy` varchar(50) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `CreateDate` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `acc_temp`
--

CREATE TABLE `acc_temp` (
  `COAID` varchar(50) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `Name` varchar(50) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `Debit` decimal(18,2) NOT NULL,
  `Credit` decimal(18,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `acc_transaction`
--

CREATE TABLE `acc_transaction` (
  `ID` int(11) NOT NULL,
  `VNo` varchar(50) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL,
  `Vtype` varchar(50) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL,
  `VDate` date DEFAULT NULL,
  `COAID` varchar(50) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `Narration` text CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL,
  `Debit` decimal(18,2) DEFAULT NULL,
  `Credit` decimal(18,2) DEFAULT NULL,
  `StoreID` int(11) NOT NULL,
  `IsPosted` char(10) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL,
  `CreateBy` varchar(50) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL,
  `CreateDate` datetime DEFAULT NULL,
  `UpdateBy` varchar(50) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL,
  `UpdateDate` datetime DEFAULT NULL,
  `IsAppove` char(10) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `acc_transaction`
--

INSERT INTO `acc_transaction` (`ID`, `VNo`, `Vtype`, `VDate`, `COAID`, `Narration`, `Debit`, `Credit`, `StoreID`, `IsPosted`, `CreateBy`, `CreateDate`, `UpdateBy`, `UpdateDate`, `IsAppove`) VALUES
(357, '20220731215056', 'PO', '2022-07-31', '10107', 'PO Receive Receive No 20220731215254', '300000.00', '0.00', 2, '1', '1', '2022-07-31 00:00:00', NULL, NULL, '1'),
(358, '20220803213739', 'PO', '2022-08-03', '10107', 'PO Receive Receive No 20220803213946', '180000.00', '0.00', 1, '1', '1', '2022-08-03 00:00:00', NULL, NULL, '1'),
(359, '20220803213739', 'PO', '2022-08-07', '10107', 'PO Receive Receive No 20220807083451', '180000.00', '0.00', 1, '1', '1', '2022-08-07 00:00:00', NULL, NULL, '1'),
(360, '20220807135913', 'PO', '2022-08-07', '10107', 'PO Receive Receive No 20220807135941', '30000.00', '0.00', 1, '1', '1', '2022-08-07 00:00:00', NULL, NULL, '1'),
(361, '20220807145331', 'PO', '2022-08-07', '10107', 'PO Receive Receive No 20220807145345', '10000.00', '0.00', 2, '1', '1', '2022-08-07 00:00:00', NULL, NULL, '1'),
(362, '20220807153707', 'PO', '2022-08-07', '10107', 'PO Receive Receive No 20220807153736', '10000000.00', '0.00', 2, '1', '1', '2022-08-07 00:00:00', NULL, NULL, '1'),
(363, '20220807154155', 'PO', '2022-08-07', '10107', 'PO Receive Receive No 20220807154227', '7000000.00', '0.00', 2, '1', '1', '2022-08-07 00:00:00', NULL, NULL, '1'),
(364, '20220807205857', 'PO', '2022-08-07', '10107', 'PO Receive Receive No 20220807205922', '10000000.00', '0.00', 2, '1', '1', '2022-08-07 00:00:00', NULL, NULL, '1'),
(365, '1000', 'CIV', '2022-08-10', '403', 'Cost of sale debit For Invoice No1000', NULL, '0.00', 2, '1', '3', '2022-08-10 21:12:48', NULL, NULL, '1'),
(366, '1000', 'CIV', '2022-08-10', '10107', 'Inventory credit For Invoice No1000', '0.00', NULL, 2, '1', '3', '2022-08-10 21:12:48', NULL, NULL, '1'),
(367, '1001', 'CIV', '2022-08-10', '403', 'Cost of sale debit For Invoice No1001', NULL, '0.00', 2, '1', '3', '2022-08-10 21:14:57', NULL, NULL, '1'),
(368, '1001', 'CIV', '2022-08-10', '10107', 'Inventory credit For Invoice No1001', '0.00', NULL, 2, '1', '3', '2022-08-10 21:14:57', NULL, NULL, '1');

-- --------------------------------------------------------

--
-- Table structure for table `country_state_city`
--

CREATE TABLE `country_state_city` (
  `id` int(11) NOT NULL,
  `name` varchar(30) NOT NULL,
  `text` varchar(30) NOT NULL,
  `parent_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `country_state_city`
--

INSERT INTO `country_state_city` (`id`, `name`, `text`, `parent_id`) VALUES
(1, 'test', 'sdfsdf', 1);

-- --------------------------------------------------------

--
-- Table structure for table `customer`
--

CREATE TABLE `customer` (
  `customer_id` int(11) NOT NULL,
  `customer_code` varchar(10) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL COMMENT 'This is the file Number',
  `force_rank` varchar(100) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL,
  `unit` varchar(200) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL,
  `customer_name` varchar(50) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `customer_phone` varchar(50) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `customer_address` varchar(200) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL,
  `store_id` int(11) DEFAULT NULL COMMENT 'This is Store ID',
  `customer_cnic` varchar(32) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL,
  `job_designation` varchar(120) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL,
  `business_address` varchar(200) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL,
  `type` int(11) DEFAULT NULL,
  `createby` varchar(20) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `createdate` datetime NOT NULL,
  `updateby` varchar(20) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `updatedate` datetime NOT NULL,
  `isactive` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `customer`
--

INSERT INTO `customer` (`customer_id`, `customer_code`, `force_rank`, `unit`, `customer_name`, `customer_phone`, `customer_address`, `store_id`, `customer_cnic`, `job_designation`, `business_address`, `type`, `createby`, `createdate`, `updateby`, `updatedate`, `isactive`) VALUES
(27, '65566566', 'IGP', 'Uganda Police', 'OCHOLA OKOTH', '08678678687', 'Nagulu', 0, '', '', '', 0, '1', '2022-08-10 20:38:35', '1', '2022-08-10 20:38:35', 1),
(28, '837883', 'IGP', 'Uganda Police', 'AGABA ANDREW', '07827881991', 'Naguru', 0, '', '', '', 0, '1', '2022-08-08 20:23:50', '', '0000-00-00 00:00:00', 1),
(35, '5757857857', 'AIGP', 'Research', 'Mukisa Robert', '58585785', NULL, NULL, NULL, NULL, NULL, NULL, '', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', 1),
(36, '5100090000', 'SSP', 'CID', 'Mugisha Isaac', '78976666', NULL, NULL, NULL, NULL, NULL, NULL, '', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', 1);

-- --------------------------------------------------------

--
-- Table structure for table `customer_gurrantor_map`
--

CREATE TABLE `customer_gurrantor_map` (
  `rowid` bigint(20) NOT NULL,
  `lease_id` int(11) NOT NULL,
  `customer_id` int(11) NOT NULL,
  `gurrantor_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `districts`
--

CREATE TABLE `districts` (
  `id` int(11) NOT NULL,
  `district_name` varchar(50) NOT NULL,
  `region_id` int(11) DEFAULT NULL,
  `description` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `districts`
--

INSERT INTO `districts` (`id`, `district_name`, `region_id`, `description`) VALUES
(1, 'ABIM', 1, NULL),
(2, 'ADJUMANI', 1, NULL),
(3, 'AGAGO', 1, NULL),
(4, 'ALEBTONG', 1, NULL),
(5, 'AMOLATAR', 1, NULL),
(6, 'AMUDAT', 1, NULL),
(7, 'AMURIA', 1, NULL),
(8, 'AMURU', 1, NULL),
(9, 'APAC', 1, NULL),
(10, 'ARUA', 1, NULL),
(11, 'BUDAKA', 1, NULL),
(12, 'BUDUDA', 1, NULL),
(13, 'BUGIRI', 1, NULL),
(14, 'BUGWERI', 1, NULL),
(15, 'BUHWEJU', 1, NULL),
(16, 'BUIKWE', 1, NULL),
(17, 'BUKEDEA', 1, NULL),
(18, 'BUKOMANSIMBI', 1, NULL),
(19, 'BUKWO', 1, NULL),
(20, 'BULAMBULI', 1, NULL),
(21, 'BULIISA', 1, NULL),
(22, 'BUNDIBUGYO', 1, NULL),
(23, 'BUNYANGABU', 1, NULL),
(24, 'BUSHENYI', 1, NULL),
(25, 'BUSIA', 1, NULL),
(26, 'BUTALEJA', 1, NULL),
(27, 'BUTAMBALA', 1, NULL),
(28, 'BUTEBO', 1, NULL),
(29, 'BUVUMA', 1, NULL),
(30, 'BUYENDE', 1, NULL),
(31, 'DOKOLO', 1, NULL),
(32, 'GOMBA', 1, NULL),
(33, 'GULU', 1, NULL),
(34, 'HOIMA', 1, NULL),
(35, 'IBANDA', 1, NULL),
(36, 'IGANGA', 1, NULL),
(37, 'ISINGIRO', 1, NULL),
(38, 'JINJA', 1, NULL),
(39, 'KAABONG', 1, NULL),
(40, 'KABALE', 1, NULL),
(41, 'KABAROLE', 1, NULL),
(42, 'KABERAMAIDO', 1, NULL),
(43, 'KAGADI', 1, NULL),
(44, 'KAKUMIRO', 1, NULL),
(45, 'KALAKI', 1, NULL),
(46, 'KALANGALA', 1, NULL),
(47, 'KALIRO', 1, NULL),
(48, 'KALUNGU', 1, NULL),
(49, 'KAMPALA', 1, NULL),
(50, 'KAMULI', 1, NULL),
(51, 'KAMWENGE', 1, NULL),
(52, 'KANUNGU', 1, NULL),
(53, 'KAPCHORWA', 1, NULL),
(54, 'KAPELEBYONG', 1, NULL),
(55, 'KARENGA', 1, NULL),
(56, 'KASESE', 1, NULL),
(57, 'KASSANDA', 1, NULL),
(58, 'KATAKWI', 1, NULL),
(59, 'KAYUNGA', 1, NULL),
(60, 'KAZO', 1, NULL),
(61, 'KIBAALE', 1, NULL),
(62, 'KIBOGA', 1, NULL),
(63, 'KIBUKU', 1, NULL),
(64, 'KIKUUBE', 1, NULL),
(65, 'KIRUHURA', 1, NULL),
(66, 'KIRYANDONGO', 1, NULL),
(67, 'KISORO', 1, NULL),
(68, 'KITAGWENDA', 1, NULL),
(69, 'KITGUM', 1, NULL),
(70, 'KOBOKO', 1, NULL),
(71, 'KOLE', 1, NULL),
(72, 'KOTIDO', 1, NULL),
(73, 'KUMI', 1, NULL),
(74, 'KWANIA', 1, NULL),
(75, 'KWEEN', 1, NULL),
(76, 'KYANKWANZI', 1, NULL),
(77, 'KYEGEGWA', 1, NULL),
(78, 'KYENJOJO', 1, NULL),
(79, 'KYOTERA', 1, NULL),
(80, 'LAMWO', 1, NULL),
(81, 'LIRA', 1, NULL),
(82, 'LUUKA', 1, NULL),
(83, 'LUWERO', 1, NULL),
(84, 'LWENGO', 1, NULL),
(85, 'LYANTONDE', 1, NULL),
(86, 'MADI OKOLLO', 1, NULL),
(87, 'MANAFWA', 1, NULL),
(88, 'MARACHA', 1, NULL),
(89, 'MASAKA', 1, NULL),
(90, 'MASINDI', 1, NULL),
(91, 'MAYUGE', 1, NULL),
(92, 'MBALE', 1, NULL),
(93, 'MBARARA', 1, NULL),
(94, 'MITOOMA', 1, NULL),
(95, 'MITYANA', 1, NULL),
(96, 'MOROTO', 1, NULL),
(97, 'MOYO', 1, NULL),
(98, 'MPIGI', 1, NULL),
(99, 'MUBENDE', 1, NULL),
(100, 'MUKONO', 1, NULL),
(101, 'NABILATUK', 1, NULL),
(102, 'NAKAPIRIPIRIT', 1, NULL),
(103, 'NAKASEKE', 1, NULL),
(104, 'NAKASONGOLA', 1, NULL),
(105, 'NAMAYINGO', 1, NULL),
(106, 'NAMISINDWA', 1, NULL),
(107, 'NAMUTUMBA', 1, NULL),
(108, 'NAPAK', 1, NULL),
(109, 'NEBBI', 1, NULL),
(110, 'NGORA', 1, NULL),
(111, 'NTOROKO', 1, NULL),
(112, 'NTUNGAMO', 1, NULL),
(113, 'NWOYA', 1, NULL),
(114, 'OBONGI', 1, NULL),
(115, 'OMORO', 1, NULL),
(116, 'OTUKE', 1, NULL),
(117, 'OYAM', 1, NULL),
(118, 'PADER', 1, NULL),
(119, 'PAKWACH', 1, NULL),
(120, 'PALLISA', 1, NULL),
(121, 'RAKAI', 1, NULL),
(122, 'RUBANDA', 1, NULL),
(123, 'RUBIRIZI', 1, NULL),
(124, 'RUKIGA', 1, NULL),
(125, 'RUKUNGIRI', 1, NULL),
(126, 'RWAMPARA', 1, NULL),
(127, 'SERERE', 1, NULL),
(128, 'SHEEMA', 1, NULL),
(129, 'SIRONKO', 1, NULL),
(130, 'SOROTI', 1, NULL),
(131, 'SSEMBABULE', 1, NULL),
(132, 'TORORO', 1, NULL),
(133, 'WAKISO', 1, NULL),
(134, 'YUMBE', 1, NULL),
(135, 'ZOMBO', 1, NULL),
(136, 'Sample', 0, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `employee`
--

CREATE TABLE `employee` (
  `id` int(11) NOT NULL,
  `image` varchar(100) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `employeeno` varchar(50) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `name` varchar(50) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `store_id` varchar(10) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `designation` varchar(50) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `CardNo` varchar(50) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `department` varchar(50) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `isactive` tinyint(1) NOT NULL,
  `createby` varchar(50) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `createdate` datetime NOT NULL,
  `updateby` varchar(50) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `updatedate` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `gurrantor`
--

CREATE TABLE `gurrantor` (
  `gurrantor_id` int(11) NOT NULL,
  `gurrantor_code` varchar(10) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `store_id` int(11) NOT NULL,
  `gurrantor_name` varchar(50) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `gurrantor_phone` varchar(50) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `gurrantor_address` varchar(200) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `gurrantor_cnic` varchar(32) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `job_designation` varchar(120) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `business_address` varchar(200) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `createby` varchar(20) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `createdate` datetime NOT NULL,
  `updateby` varchar(20) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `updatedate` datetime NOT NULL,
  `isactive` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `language`
--

CREATE TABLE `language` (
  `id` int(11) NOT NULL,
  `phrase` varchar(100) NOT NULL,
  `english` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `language`
--

INSERT INTO `language` (`id`, `phrase`, `english`) VALUES
(2, 'login', 'Login'),
(3, 'email', 'Email Address'),
(4, 'password', 'Password'),
(5, 'reset', 'Reset'),
(6, 'dashboard', 'Dashboard'),
(7, 'home', 'Home'),
(8, 'profile', 'Profile'),
(9, 'profile_setting', 'Profile Setting'),
(10, 'firstname', 'First Name'),
(11, 'lastname', 'Last Name'),
(12, 'about', 'About'),
(13, 'preview', 'Preview'),
(14, 'image', 'Image'),
(15, 'save', 'Save'),
(16, 'upload_successfully', 'Upload Successfully!'),
(17, 'user_added_successfully', 'User Added Successfully!'),
(18, 'please_try_again', 'Please Try Again...'),
(19, 'inbox_message', 'Inbox Messages'),
(20, 'sent_message', 'Sent Message'),
(21, 'message_details', 'Message Details'),
(22, 'new_message', 'New Message'),
(23, 'receiver_name', 'Received By'),
(24, 'sender_name', 'Sender Name'),
(25, 'subject', 'Subject'),
(26, 'message', 'Message'),
(27, 'message_sent', 'Message Sent!'),
(28, 'ip_address', 'IP Address'),
(29, 'last_login', 'Last Login'),
(30, 'last_logout', 'Last Logout'),
(31, 'status', 'Status'),
(32, 'delete_successfully', 'Delete Successfully!'),
(33, 'send', 'Send'),
(34, 'date', 'Date'),
(35, 'action', 'Action'),
(36, 'sl_no', 'SL No.'),
(37, 'are_you_sure', 'Are You Sure ? '),
(38, 'application_setting', 'Application Setting'),
(39, 'application_title', 'Application Title'),
(40, 'address', 'Address'),
(41, 'phone', 'Phone'),
(42, 'favicon', 'Favicon'),
(43, 'logo', 'Logo'),
(44, 'language', 'Language'),
(45, 'left_to_right', 'Left To Right'),
(46, 'right_to_left', 'Right To Left'),
(47, 'footer_text', 'Footer Text'),
(48, 'site_align', 'Application Alignment'),
(49, 'welcome_back', 'Welcome Back!'),
(50, 'please_contact_with_admin', 'Please Contact With Admin'),
(51, 'incorrect_email_or_password', 'Incorrect Email/Password'),
(52, 'select_option', 'Select Option'),
(53, 'ftp_setting', 'Data Synchronize [FTP Setting]'),
(54, 'hostname', 'Host Name'),
(55, 'username', 'User Name'),
(56, 'ftp_port', 'FTP Port'),
(57, 'ftp_debug', 'FTP Debug'),
(58, 'project_root', 'Project Root'),
(59, 'update_successfully', 'Update Successfully'),
(60, 'save_successfully', 'Save Successfully!'),
(61, 'delete_successfully', 'Delete Successfully!'),
(62, 'internet_connection', 'Internet Connection'),
(63, 'ok', 'Ok'),
(64, 'not_available', 'Not Available'),
(65, 'available', 'Available'),
(66, 'outgoing_file', 'Outgoing File'),
(67, 'incoming_file', 'Incoming File'),
(68, 'data_synchronize', 'Data Synchronize'),
(69, 'unable_to_upload_file_please_check_configuration', 'Unable to upload file! please check configuration'),
(70, 'please_configure_synchronizer_settings', 'Please configure synchronizer settings'),
(71, 'download_successfully', 'Download Successfully'),
(72, 'unable_to_download_file_please_check_configuration', 'Unable to download file! please check configuration'),
(73, 'data_import_first', 'Data Import First'),
(74, 'data_import_successfully', 'Data Import Successfully!'),
(75, 'unable_to_import_data_please_check_config_or_sql_file', 'Unable to import data! please check configuration / SQL file.'),
(76, 'download_data_from_server', 'Download Data from Server'),
(77, 'data_import_to_database', 'Data Import To Database'),
(79, 'data_upload_to_server', 'Data Upload to Server'),
(80, 'please_wait', 'Please Wait...'),
(81, 'ooops_something_went_wrong', ' Ooops something went wrong...'),
(82, 'module_permission_list', 'Module Permission List'),
(83, 'user_permission', 'User Permission'),
(84, 'add_module_permission', 'Add Module Permission'),
(85, 'module_permission_added_successfully', 'Module Permission Added Successfully!'),
(86, 'update_module_permission', 'Update Module Permission'),
(87, 'download', 'Download'),
(88, 'module_name', 'Module Name'),
(89, 'create', 'Create'),
(90, 'read', 'Read'),
(91, 'update', 'Update'),
(92, 'delete', 'Delete'),
(93, 'module_list', 'Module List'),
(94, 'add_module', 'Add Module'),
(95, 'directory', 'Module Direcotory'),
(96, 'description', 'Description'),
(97, 'image_upload_successfully', 'Image Upload Successfully!'),
(98, 'module_added_successfully', 'Module Added Successfully'),
(99, 'inactive', 'Inactive'),
(100, 'active', 'Active'),
(101, 'user_list', 'User List'),
(102, 'see_all_message', 'See All Messages'),
(103, 'setting', 'Setting'),
(104, 'logout', 'Logout'),
(105, 'admin', 'Admin'),
(106, 'add_user', 'Add User'),
(107, 'user', 'User'),
(108, 'module', 'Module'),
(109, 'new', 'New'),
(110, 'inbox', 'Inbox'),
(111, 'sent', 'Sent'),
(112, 'synchronize', 'Synchronize'),
(113, 'data_synchronizer', 'Data Synchronizer'),
(114, 'module_permission', 'Module Permission'),
(115, 'backup_now', 'Backup Now!'),
(116, 'restore_now', 'Restore Now!'),
(117, 'backup_and_restore', 'Backup and Restore'),
(118, 'captcha', 'Captcha Word'),
(119, 'database_backup', 'Database Backup'),
(120, 'restore_successfully', 'Restore Successfully'),
(121, 'backup_successfully', 'Backup Successfully'),
(122, 'filename', 'File Name'),
(123, 'file_information', 'File Information'),
(124, 'size', 'size'),
(125, 'backup_date', 'Backup Date'),
(126, 'overwrite', 'Overwrite'),
(127, 'invalid_file', 'Invalid File!'),
(128, 'invalid_module', 'Invalid Module'),
(129, 'remove_successfully', 'Remove Successfully!'),
(130, 'install', 'Install'),
(131, 'uninstall', 'Uninstall'),
(132, 'tables_are_not_available_in_database', 'Tables are not available in database.sql'),
(133, 'no_tables_are_registered_in_config', 'No tables are registerd in config.php'),
(134, 'enquiry', 'Enquiry'),
(135, 'read_unread', 'Read/Unread'),
(136, 'enquiry_information', 'Enquiry Information'),
(137, 'user_agent', 'User Agent'),
(138, 'checked_by', 'Checked By'),
(139, 'new_enquiry', 'New Enquiry'),
(140, 'role', 'Role'),
(141, 'add_role', 'Add Role'),
(142, 'role_list', 'Role List'),
(143, 'name', 'Name'),
(144, 'isactive', 'Is Active'),
(145, 'set', 'Set'),
(146, 'store', 'Store'),
(147, 'add_store', 'Add Store'),
(148, 'list_store', 'Store List'),
(149, 'store_name', 'Store Name'),
(150, 'store_code', 'Store Code'),
(151, 'store_address', 'Store Address'),
(152, 'store_phone', 'Store Phone'),
(153, 'user_role', 'User Role'),
(154, 'add_user_role', 'Add User Role'),
(155, 'user_role_list', 'User Role List'),
(156, 'role_name', 'Role Name'),
(157, 'user_type', 'User Type'),
(158, 'super_admin', 'Super Admin'),
(159, 'sl', 'SL'),
(160, 'user_name', 'User Name'),
(161, 'create_user_role', 'Create User Role'),
(162, 'role_permission', 'Role Permission'),
(163, 'add_role_permission', 'Add Role Permission'),
(164, 'role_permission_list', 'Role Permission List'),
(165, 'permission_error', 'You Have No Permission'),
(166, 'employee', 'Employee'),
(167, 'add', 'Add '),
(168, 'list', 'List'),
(169, 'designation', 'Designation'),
(170, 'cardno', 'NID'),
(171, 'department', 'Department'),
(172, 'customer', 'Customer'),
(173, 'customer_code', 'Customer Code'),
(174, 'customer_name', 'Customer Name'),
(175, 'business_address', 'Business Address'),
(176, 'customer_cnic', 'Customer CNIC'),
(177, 'product_name', 'Product Name'),
(178, 'product_category', 'Product Category'),
(179, 'product', 'Product'),
(180, 'product_details', 'Product Details'),
(181, 'price', 'Price'),
(182, 'category', 'Category'),
(183, 'category_name', 'Category Name'),
(184, 'supplier', 'Supplier'),
(185, 'supplier_name', 'Supplier Name'),
(186, 'purchase_order', 'Puchase Order'),
(187, 'stock_ctn', 'Stock Qty'),
(188, 'quantity', 'Qty'),
(189, 'total', 'Total'),
(190, 'grand_total', 'Grand Total'),
(191, 'add_new_item', 'Add New Product'),
(192, 'submit_and_add_another', 'Submit and Another'),
(193, 'submit', 'Submit '),
(194, 'order_no', 'Order NO'),
(195, 'warehouse', 'Warehouse'),
(196, 'assign_role', 'Assign Role'),
(197, 'add_warehouse', 'Add Warehouse'),
(198, 'list_warehouse', 'Warehouse list'),
(199, 'warehouse_name', 'Warehouse Name'),
(200, 'warehouse_code', 'Warehouse code'),
(201, 'warehouse_phone', 'Warehouse Phone'),
(202, 'warehouse_address', 'Warehouse Address'),
(203, 'check_receive', 'Check_receive'),
(204, 'receive', 'Receive'),
(205, 'order_qty', 'Order QTY'),
(206, 'receive_quantity', 'Received QTY'),
(207, 'order_date', 'Order Date'),
(208, 'storewarehouse', 'Store/warehouse'),
(209, 'successfully_approved', 'Successfully Approved'),
(210, 'disapprove', 'Disapprove'),
(211, 'approved', 'Approve'),
(212, 'receive_list', 'Receive List'),
(213, 'voucher_no', 'Voucher No'),
(214, 'purchase_price', 'Purchase Price'),
(215, 'minimum_price', 'Minimum Price'),
(216, 'retail_price', 'Retail Price'),
(217, 'block_price', 'Block Price'),
(218, 'a', 'A'),
(219, 'in', 'In A'),
(220, 'receive_qty', 'Received QTY'),
(221, 'sale', 'Sales'),
(222, 'cashsale', 'Cash Sale'),
(223, 'invoice_id', 'Receipt No.'),
(224, 'sales_man', 'Sales Man'),
(225, 'total_amount', 'Total Amount'),
(226, 'paid_amount', 'Paid Amount'),
(227, 'remaining_amnt', 'Remainig Amount'),
(228, 'lease', 'Lease'),
(229, 'pakage_code', 'Package  Code'),
(230, 'pakage_name', 'Package Name'),
(231, 'duration', 'Duration'),
(232, 'advance', 'Advance'),
(233, 'markup', 'Markup'),
(234, 'update_lease', 'Lease Update'),
(235, 'inquiry_officer', 'Inquiry Officer'),
(236, 'lease_package', 'Lease Package'),
(237, 'payment', 'Receiving '),
(238, 'invoice_no', 'Receipt No.'),
(239, 'due_amnt', 'Due Amount'),
(240, 'cash_sale_list', 'Cash Sale List'),
(241, 'credit_sale_list', 'Credit Sale List'),
(242, 'lease_sale_list', 'Lease Sale List'),
(243, 'to', 'To'),
(244, 'advance_amount', 'Advance amount'),
(245, 'gurrantor_name', 'Gurrantor  Name'),
(246, 'gurrantor_code', 'Gurrantor  Code'),
(247, 'gurrantor_phone', 'Gurrantor  Phone'),
(248, 'gurrantor_address', 'Gurrantor Address'),
(249, 'gurrantor_cnic', 'Gurrantor  CNIC'),
(250, 'stockmovment', 'Stock Movement'),
(251, 'proposal_code', 'Proposal Code'),
(252, 'issue_code', 'Issue Code'),
(253, 'issue_date', 'Issue Date'),
(254, 'for_store', 'For Store'),
(255, 'from_store', 'From Store'),
(256, 'issue_by', 'Issue By'),
(257, 'product_code', 'Product Code'),
(258, 'proposal_qty', 'Proposal QTY'),
(259, 'please_choose_another_p_code', 'Please another Product Code!!!'),
(260, 'proposal_datetime', 'Proposal Date'),
(261, 'product_info', 'Product Info'),
(262, 'category_list', 'Category List'),
(263, 'add_product', 'Add Product'),
(264, 'product_list', 'Product List'),
(265, 'model_name', 'Model Name'),
(266, 'model', 'Model'),
(267, 'add_model', 'Add Model'),
(268, 'brand', 'Brand'),
(269, 'brand_name', 'Brand Name'),
(270, 'brand_list', 'Brand List'),
(271, 'unit_name', 'Unit Name'),
(272, 'unit', 'Unit of Measurement'),
(273, 'add_unit', 'Add Unit'),
(274, 'unit_list', 'Unit List'),
(275, 'pur_price', 'Cost Price'),
(276, 'min_price', 'Min Price'),
(277, 'retprice', 'Retail Price'),
(278, 'bl_price', 'BL Price'),
(279, 'cash', 'Cash'),
(280, 'credit', 'Credit'),
(281, 'customer_type', 'Customer Type'),
(282, 'code', 'Code'),
(283, 'cnic', 'CNIC'),
(284, 'um', 'Units'),
(285, 'contact', 'Contact#'),
(286, 'package_amount', 'Package Amount'),
(287, 'recovery_received', 'Recovery Received'),
(288, 'require_install', 'Require Installment'),
(289, 'installment_amount', 'Installment Amount'),
(290, 'over_due_amount', 'Over Due Amount'),
(291, 'final_settlement', 'Final Settlement Amount'),
(292, 'final_settlement_discount', 'Final Settlement Discount'),
(293, 'receive_amnt', 'Receive Amount'),
(294, 'credit_receive', 'Credit Receive'),
(295, 'add_recovery_receiving', 'Add Recovery Receiving'),
(296, 'add_credit_receiving', 'Add Credit Receiving'),
(297, 'report', 'Report'),
(298, 'recovery', 'Recovery'),
(299, 'surplus', 'Surplus'),
(300, 'deficit', 'Deficit'),
(301, 'recovery_summary_report', 'Recovery Summary Report'),
(302, 'ac_wise_achivement', 'A/C Wise Achievement'),
(303, 'amount_wise_achivement', 'Amount Wise Achievement'),
(304, 'remaning_ac', 'Remaining A/C'),
(305, 'remaning_amount', 'Remaining Amount'),
(306, 'target', 'Target'),
(307, 'achievement', 'Achievement'),
(308, 'remaining', 'Remaining'),
(309, 'account', 'Account'),
(310, 'amount', 'Amount'),
(311, 'branches', 'Branches'),
(312, 'search', 'Search'),
(313, 'supplier_code', 'Supplier Code'),
(314, 'recovery_summary_report_datewise', 'Datewise Recovery Summary  '),
(315, 'proposed_by', 'Proposed By'),
(316, 'overdue_analysis', 'Over Due Analysis'),
(317, 'gurrantor', 'Gurrantor'),
(318, 'g_contact', 'G Contact'),
(319, 'install_no', '# of Installment'),
(320, 'lease_amount', 'Lease Amount'),
(321, 'installment_amnt', 'Installment Amount'),
(322, 'total_receive', 'Total Receive'),
(323, 'branch_wise_ov_du_analisis', 'Branch Wise Due Analysis'),
(324, 'over_due', 'Over Due'),
(325, 'days', 'Days'),
(326, 'last_payment_date', 'Last Payment Date'),
(327, 'location', 'Location'),
(328, 'discount', 'Disc'),
(329, 'creditsale', 'Credit Sale'),
(330, 'leasesale', 'Lease Sale'),
(331, 'oreder_list', 'Order List'),
(332, 'store_procedure', 'Store Procedure'),
(333, 'stock', 'Stock'),
(334, 'inqty', 'In QTY'),
(335, 'outqty', 'Out Qty'),
(336, 'select', 'Select'),
(337, 'contact_per_name', 'Contact Person '),
(338, 'c_p_contact', 'Person Contact#'),
(339, 'remark', 'Remark'),
(340, 'return', 'Return'),
(341, 'please_input_correct_invoice_no', 'Please Input a correct invoice number'),
(342, 'sales_return_form', 'Sales Return Form'),
(343, 'sale_qty', 'Sales Qty'),
(344, 'return_qty', 'Return Qty'),
(345, 'reason', 'Reason'),
(346, 'purchase_qty', 'Purchase Qty'),
(347, 'purchase_return', 'Purchase Return'),
(348, 'return_date', 'Return Date'),
(349, 'sale_return_list', 'Sales Return List'),
(350, 'purchase_return_list', 'Purchase Return List'),
(351, 'sales_return_view', 'Sales Return view'),
(352, 'purchase_return_view', 'Purchase Return veiw'),
(353, 'reports', 'Reports'),
(354, 'test', ''),
(355, 'recovery_list', 'Recovery List'),
(356, 'find', 'Find'),
(357, 'accounts', 'Accounts'),
(358, 'c_o_a', 'Chart of Accounts'),
(359, 'customer_transaction', 'Customer Transaction'),
(360, 'money_receipt', 'Money Receipt'),
(361, 'debit_voucher', 'Debit Voucher'),
(362, 'receive_by', 'Received By'),
(363, 'credit_voucher', 'Credit Voucher'),
(364, 'contra_voucher', 'Contra voucher'),
(365, 'journal_voucher', 'Journal Voucher'),
(366, 'voucher_approval', 'Voucher Approval'),
(367, 'check_status', 'Check Status'),
(368, 'account_report', 'Account Reports'),
(369, 'voucher_report', 'Voucher Report'),
(370, 'cash_book', 'Cash book'),
(371, 'bank_book', 'Bank Book'),
(372, 'income_expense', 'Income Expense'),
(373, 'general_ledger', 'General Ledger'),
(374, 'trial_balance', 'Trial Balance'),
(375, 'profit_loss', 'Profit Loss'),
(376, 'receipt_payment', 'Receipt Payment'),
(377, 'all_voucher', 'All Voucher'),
(378, 'cash_flow', 'Cash Flow'),
(379, 'stmt_of_financial_position', 'Stmt of Financial Position'),
(380, 'stmt_changes_equity', 'Stmt of Change Equity'),
(381, 'coa_print', 'Coa Print'),
(382, 'stock_qty', 'Stock Qty'),
(383, 'stock_value', 'Avg. Price'),
(384, 'add_more', 'Add more'),
(385, 'debit', 'Debit'),
(386, 'issue_qty', 'Issue Qty'),
(387, 'update_debit_voucher', 'Update Debit Voucher'),
(388, 'update_credit_voucher', 'Update Debit Voucher'),
(389, 'total_advance_amount', 'Total Advance Amount'),
(390, 'total_package_amount', 'Total Package Amount'),
(391, 'u_pack_price', 'Unit Package Price'),
(392, 'total_pack_price', 'Total Package Price'),
(393, 'from_date', 'From Date'),
(394, 'to_date', 'To Date'),
(395, 'gurrantor1', 'Gurrantor 1'),
(396, 'gurrantor2', 'Gurrantor 2'),
(397, 'customer_recovery', 'Customer Overdue Recovery'),
(398, 'stock_analysis_report', 'Stock Analysis Report'),
(399, 'lease_package_pricing', 'Lease Package Pricing'),
(400, 'cash_price', 'Cash Price'),
(401, 'package', 'Package'),
(402, 'lease_price', 'Lease Price'),
(403, 'monthly_installment', 'Monthly Installment'),
(404, 'recovery_report', 'Recovery Report'),
(405, 'stock_report', 'Stock Report'),
(406, 'lease_and_recovery_report', 'Lease & Recovery Report'),
(407, 'stock_history', 'Stock History'),
(408, 'sales_return', 'Sales Return'),
(409, 'balance_qty', 'Balance Qty'),
(410, 'sale_price', 'Sale Price'),
(411, 'general_ledger_of', 'general ledger of'),
(412, 'store_stock_history', 'Store Stock History'),
(413, 'po_no', 'PO No'),
(414, 'store_ledger', 'Store Ledger'),
(415, 'recovery_list_rpt', 'Recovery List Report'),
(416, 'store_isssue', 'Store Issue'),
(417, 'store_receive', 'Store Receive'),
(418, 'sales_amount', 'Sales Amount'),
(419, 'total_payable', 'Total Payable'),
(420, 'total_receivable', 'Total Receivable'),
(421, 'total_bank', 'Total Bank'),
(422, 'total_cash', 'Total Cash'),
(423, 'no_customer', '# of Customer'),
(424, 'monthly_sales_performance', 'Monthly Sales Performance'),
(425, 'over_due_analysis', 'Over Due Analysis'),
(426, 'products', 'Products'),
(427, 'stores', 'Stores'),
(428, 'customers', 'Customers'),
(429, 'users', 'Users'),
(430, 'qty', 'Qty'),
(431, 'value', 'Value'),
(432, 'backup', 'Backup'),
(433, 'receive_date', 'Date Received '),
(434, 'customer_and_address', 'Customer & Address#'),
(435, 'gurrantor_and_contact', 'Gurrantor & Contact#'),
(436, 'lease_date', 'Lease Date'),
(437, 'remaining_amount', 'Remaining Amount'),
(438, 'last_payment', 'Last Payment'),
(439, 'overdue_amount', 'Over Due Amount'),
(440, 'lease_from', 'Lease From'),
(441, 'amount_greater_than', 'Amount Greater Than'),
(442, 'lease_to', 'Lease To'),
(443, 'amount_less_than', 'Amount less Than'),
(444, 'amount_equal', 'Amount Equal'),
(445, 'check_all_product', 'Check All Products'),
(446, 'check_all_store', 'Check All Stores'),
(447, 'new_sale', 'New Sale'),
(448, 'new_purchase', 'New Purchase'),
(449, 'purchases_list', 'Purchases list'),
(450, 'previous_purchases', 'Previous Purchases'),
(451, 'color_name', 'Color'),
(452, 'upload_customers', 'Upload Customer'),
(453, 'upload', 'Upload'),
(454, 'manufacturer', 'Manufacturers'),
(455, 'manufacturer_name', 'Manufacturer');

-- --------------------------------------------------------

--
-- Table structure for table `lease`
--

CREATE TABLE `lease` (
  `lease_id` int(11) NOT NULL,
  `package_code` varchar(15) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `package_name` varchar(120) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `lease_duration` int(11) NOT NULL,
  `advance` decimal(2,2) NOT NULL,
  `markup` decimal(2,2) NOT NULL,
  `grace_period` tinyint(4) NOT NULL COMMENT 'if customer wants to settle within the grace period then he will not be charged for the current month''s lease',
  `isactive` tinyint(1) NOT NULL,
  `createby` varchar(20) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `createdate` datetime NOT NULL,
  `updateby` varchar(20) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `updatedate` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `lease_product_map`
--

CREATE TABLE `lease_product_map` (
  `row_id` bigint(20) NOT NULL,
  `lease_id` int(11) NOT NULL,
  `product_id` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `lease_store_map`
--

CREATE TABLE `lease_store_map` (
  `row_id` bigint(20) NOT NULL,
  `lease_id` int(11) NOT NULL,
  `store_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `message`
--

CREATE TABLE `message` (
  `id` int(11) NOT NULL,
  `sender_id` int(11) NOT NULL,
  `receiver_id` int(11) NOT NULL,
  `subject` varchar(255) NOT NULL,
  `message` text NOT NULL,
  `datetime` datetime NOT NULL,
  `sender_status` tinyint(1) NOT NULL DEFAULT 0 COMMENT '0=unseen, 1=seen, 2=delete',
  `receiver_status` tinyint(1) NOT NULL DEFAULT 0 COMMENT '0=unseen, 1=seen, 2=delete'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `module`
--

CREATE TABLE `module` (
  `id` int(11) NOT NULL,
  `name` varchar(50) NOT NULL,
  `description` text DEFAULT NULL,
  `image` varchar(255) NOT NULL,
  `directory` varchar(100) NOT NULL,
  `status` tinyint(1) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `module`
--

INSERT INTO `module` (`id`, `name`, `description`, `image`, `directory`, `status`) VALUES
(1, 'Accounts', 'Accounting', '', 'accounts', 0),
(3, 'Store Management', 'Store Management System', 'application/modules/store/assets/images/thumbnail.jpg', 'store', 1),
(6, 'Customer Management', 'Customer Information', 'application/modules/customer/assets/images/thumbnail.jpg', 'customer', 1),
(7, 'Product Management', 'Product Information', 'application/modules/product/assets/images/thumbnail.jpg', 'product', 1),
(9, 'supplier Management', 'supplier Information', 'application/modules/supplier/assets/images/thumbnail.jpg', 'supplier', 1),
(10, 'purchase Order Management', 'purchase_order Information', 'application/modules/purchase_order/assets/images/thumbnail.jpg', 'purchase_order', 1),
(12, 'sale Management', 'sale Information', 'application/modules/sale/assets/images/thumbnail.jpg', 'sale', 1),
(13, 'lease Management', 'lease Information', 'application/modules/lease/assets/images/thumbnail.jpg', 'lease', 0),
(14, 'Receiving', 'payment Management System', 'application/modules/payment/assets/images/thumbnail.jpg', 'payment', 1),
(17, 'stockmovment Management', 'stockmovment Information', 'application/modules/stockmovment/assets/images/thumbnail.jpg', 'stockmovment', 1),
(18, 'Return', 'return Information', 'application/modules/return/assets/images/thumbnail.jpg', 'return', 0),
(19, 'Reports', 'Reports Information', 'application/modules/reports/assets/images/thumbnail.jpg', 'reports', 1);

-- --------------------------------------------------------

--
-- Table structure for table `payment_collection`
--

CREATE TABLE `payment_collection` (
  `id` bigint(20) NOT NULL,
  `sale_id` bigint(20) NOT NULL,
  `invoice_no` varchar(20) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `customer_id` int(11) NOT NULL,
  `receive_amnt` float NOT NULL,
  `due_amnt` float DEFAULT NULL,
  `receive_by` int(11) NOT NULL,
  `receive_date` date NOT NULL,
  `is_installment` int(11) NOT NULL DEFAULT 0,
  `updateby` int(11) NOT NULL,
  `updatedate` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `payment_collection`
--

INSERT INTO `payment_collection` (`id`, `sale_id`, `invoice_no`, `customer_id`, `receive_amnt`, `due_amnt`, `receive_by`, `receive_date`, `is_installment`, `updateby`, `updatedate`) VALUES
(1, 20220807154352, '1000', 0, 3000, NULL, 1, '2022-08-07', 0, 0, '0000-00-00 00:00:00'),
(2, 20220807210643, '1000', 0, 3000000, NULL, 1, '2022-08-07', 0, 0, '0000-00-00 00:00:00'),
(3, 20220808235748, '1000', 28, 6000, NULL, 1, '2022-08-08', 0, 0, '0000-00-00 00:00:00'),
(4, 20220810210925, '1000', 27, 240000, NULL, 1, '2022-08-10', 0, 0, '0000-00-00 00:00:00'),
(5, 20220810211248, '1000', 27, 3900000, NULL, 3, '2022-08-10', 0, 0, '0000-00-00 00:00:00'),
(6, 20220810211457, '1001', 27, 420000, NULL, 3, '2022-08-10', 0, 0, '0000-00-00 00:00:00');

-- --------------------------------------------------------

--
-- Table structure for table `product`
--

CREATE TABLE `product` (
  `product_id` bigint(20) NOT NULL,
  `product_code` varchar(20) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `product_name` varchar(200) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `category` varchar(30) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `brand` varchar(30) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `manufacturer_id` int(11) DEFAULT NULL,
  `unit` varchar(30) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `model` varchar(50) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `color_id` int(11) NOT NULL DEFAULT 1,
  `product_details` varchar(250) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `purchase_price` float NOT NULL DEFAULT 0,
  `minimum_price` float NOT NULL DEFAULT 0,
  `retail_price` float NOT NULL DEFAULT 0,
  `block_price` float NOT NULL DEFAULT 0,
  `isactive` tinyint(1) NOT NULL,
  `createby` varchar(20) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `createdate` datetime NOT NULL,
  `updateby` varchar(20) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `updatedate` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `product`
--

INSERT INTO `product` (`product_id`, `product_code`, `product_name`, `category`, `brand`, `manufacturer_id`, `unit`, `model`, `color_id`, `product_details`, `purchase_price`, `minimum_price`, `retail_price`, `block_price`, `isactive`, `createby`, `createdate`, `updateby`, `updatedate`) VALUES
(3, 'pro-1001', 'IRON SHEET-SUPER TILE-28', '2', '4', NULL, '3', '6', 1, '', 0, 600, 600, 0, 1, '1', '2022-08-07 15:32:53', '', '0000-00-00 00:00:00'),
(4, 'pro-1002', 'IRON SHEET-NORMAL CORRUGATION-30', '2', '7', NULL, '3', '7', 1, '', 0, 7800, 7800, 0, 1, '1', '2022-08-07 15:40:45', '', '0000-00-00 00:00:00'),
(5, 'pro-1003', 'RIDGES-SUPER TILE-28-Maroon', '4', '4', NULL, '3', '6', 1, '', 0, 700, 700, 0, 1, '1', '2022-08-07 19:54:25', '', '0000-00-00 00:00:00'),
(6, 'pro-1004', 'VALLEYS-SUPER ECHO-30-Black', '5', '6', NULL, '3', '7', 1, '', 0, 1200, 1200, 0, 1, '1', '2022-08-07 20:10:54', '', '0000-00-00 00:00:00'),
(7, 'pro-1005', 'IRON SHEET-Steel & Tube-SUPER-SUPER TILE-28-Black', '2', '4', 8, '3', '6', 1, '', 0, 0, 0, 0, 1, '1', '2022-08-10 21:58:28', '', '0000-00-00 00:00:00');

-- --------------------------------------------------------

--
-- Table structure for table `product_brand`
--

CREATE TABLE `product_brand` (
  `brand_id` int(11) NOT NULL,
  `brand_name` varchar(200) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `isactive` tinyint(1) NOT NULL,
  `category_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `product_brand`
--

INSERT INTO `product_brand` (`brand_id`, `brand_name`, `isactive`, `category_id`) VALUES
(3, 'SUPER', 1, 2),
(4, 'SUPER TILE', 1, 2),
(5, 'ECHO TILE', 1, 2),
(6, 'SUPER ECHO', 1, 2),
(7, 'NORMAL CORRUGATION', 1, 2),
(8, 'MAXTILE', 1, 2);

-- --------------------------------------------------------

--
-- Table structure for table `product_category`
--

CREATE TABLE `product_category` (
  `category_id` int(11) NOT NULL,
  `category_name` varchar(200) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `isactive` tinyint(1) NOT NULL,
  `brand_label` varchar(50) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL DEFAULT 'Brand',
  `model_label` varchar(50) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL DEFAULT 'Model',
  `uses_color` int(11) NOT NULL DEFAULT 0,
  `parent_category_id` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `product_category`
--

INSERT INTO `product_category` (`category_id`, `category_name`, `isactive`, `brand_label`, `model_label`, `uses_color`, `parent_category_id`) VALUES
(2, 'IRON SHEET', 1, 'Type', 'Gauge', 1, 0),
(3, 'IRON BARS', 1, 'Brand', 'Model', 0, 0),
(4, 'RIDGES', 1, 'Brand', 'Model', 1, 2),
(5, 'VALLEYS', 1, 'Brand', 'Model', 1, 2),
(6, 'TILES', 1, 'Type', 'Size', 0, 0),
(7, 'CEMENT', 1, 'Brand', 'Model', 0, 0);

-- --------------------------------------------------------

--
-- Table structure for table `product_colors`
--

CREATE TABLE `product_colors` (
  `color_id` int(11) NOT NULL,
  `color_name` varchar(50) NOT NULL DEFAULT 'N/A'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `product_colors`
--

INSERT INTO `product_colors` (`color_id`, `color_name`) VALUES
(1, 'N/A'),
(2, 'Maroon'),
(3, 'Blue'),
(4, 'Green'),
(5, 'Black'),
(6, 'Black Red'),
(7, 'Potter Clay'),
(8, 'Harvest Gold');

-- --------------------------------------------------------

--
-- Table structure for table `product_manufacturers`
--

CREATE TABLE `product_manufacturers` (
  `id` int(11) NOT NULL,
  `manufacturer_name` varchar(200) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `isactive` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `product_manufacturers`
--

INSERT INTO `product_manufacturers` (`id`, `manufacturer_name`, `isactive`) VALUES
(7, 'Roofings', 1),
(8, 'Steel & Tube', 1),
(9, 'N/A', 1);

-- --------------------------------------------------------

--
-- Table structure for table `product_model`
--

CREATE TABLE `product_model` (
  `model_id` int(11) NOT NULL,
  `model_name` varchar(200) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `isactive` tinyint(1) NOT NULL,
  `category_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `product_model`
--

INSERT INTO `product_model` (`model_id`, `model_name`, `isactive`, `category_id`) VALUES
(1, 'N/A', 1, 2),
(6, '28', 1, 2),
(7, '30', 1, 2),
(10, 'R8', 1, 3),
(11, 'Y10', 1, 3),
(12, 'Y12', 1, 3),
(13, 'Y16', 1, 3);

-- --------------------------------------------------------

--
-- Table structure for table `product_unit`
--

CREATE TABLE `product_unit` (
  `unit_id` int(11) NOT NULL,
  `unit_name` varchar(200) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `isactive` tinyint(1) NOT NULL,
  `category_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `product_unit`
--

INSERT INTO `product_unit` (`unit_id`, `unit_name`, `isactive`, `category_id`) VALUES
(1, 'N/A', 1, NULL),
(3, 'Pieces', 1, 2),
(4, 'Kg', 1, 1),
(5, 'Ltr', 1, 1);

-- --------------------------------------------------------

--
-- Table structure for table `purchase_order`
--

CREATE TABLE `purchase_order` (
  `po_no` bigint(20) NOT NULL,
  `store_id` int(11) DEFAULT NULL,
  `warehouse_id` int(11) DEFAULT NULL,
  `createby` varchar(20) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `createdate` datetime NOT NULL,
  `isapproved` tinyint(1) DEFAULT NULL,
  `supplier_id` int(11) NOT NULL,
  `total_amnt` float NOT NULL,
  `updateby` varchar(20) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL,
  `updatedate` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `purchase_order`
--

INSERT INTO `purchase_order` (`po_no`, `store_id`, `warehouse_id`, `createby`, `createdate`, `isapproved`, `supplier_id`, `total_amnt`, `updateby`, `updatedate`) VALUES
(20220731215056, 0, 0, '3', '2022-07-31 21:58:46', 1, 1, 300000, NULL, NULL),
(20220807130740, 0, 0, '1', '2022-08-07 13:07:40', 0, 1, 120000000, NULL, NULL),
(20220807135913, 0, 0, '1', '2022-08-07 13:59:13', 1, 1, 30000, NULL, NULL),
(20220807145331, 0, 0, '1', '2022-08-07 14:53:31', 0, 1, 10000, NULL, NULL),
(20220807153707, 0, 0, '1', '2022-08-07 15:37:07', 0, 2, 10000000, NULL, NULL),
(20220807154155, 0, 0, '1', '2022-08-07 15:41:55', 0, 3, 9000000, NULL, NULL),
(20220807205857, 0, 0, '1', '2022-08-07 20:58:57', 0, 3, 10000000, NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `purchase_order_details`
--

CREATE TABLE `purchase_order_details` (
  `row_id` bigint(20) NOT NULL,
  `po_no` bigint(20) NOT NULL,
  `product_id` bigint(20) NOT NULL,
  `order_qty` int(11) NOT NULL,
  `product_rate` float NOT NULL,
  `discount` float NOT NULL,
  `store_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `purchase_order_details`
--

INSERT INTO `purchase_order_details` (`row_id`, `po_no`, `product_id`, `order_qty`, `product_rate`, `discount`, `store_id`) VALUES
(112817497946542, 20220807154155, 4, 90, 100000, 0, 2),
(496921796193467, 20220731215056, 1, 100, 3000, 0, 2),
(521477282458543, 20220807135913, 1, 30, 1000, 0, 1),
(652993653175363, 20220807130740, 1, 100, 1200000, 0, 1),
(747926455473834, 20220807205857, 6, 100, 100000, 0, 2),
(762698246881112, 0, 1, 100, 5600, 0, 2),
(862651447837354, 20220807153707, 3, 100, 100000, 0, 2),
(865317715264154, 20220807145331, 1, 100, 100, 0, 2);

-- --------------------------------------------------------

--
-- Table structure for table `purchase_receive`
--

CREATE TABLE `purchase_receive` (
  `receive_id` bigint(20) NOT NULL,
  `po_no` bigint(20) NOT NULL,
  `store_id` int(11) NOT NULL,
  `receive_by` int(11) NOT NULL,
  `receive_date` date NOT NULL,
  `supplier_id` int(11) NOT NULL,
  `voucher_no` int(11) NOT NULL,
  `warehouse_id` int(11) NOT NULL,
  `updateby` int(11) NOT NULL,
  `updatedate` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `purchase_receive`
--

INSERT INTO `purchase_receive` (`receive_id`, `po_no`, `store_id`, `receive_by`, `receive_date`, `supplier_id`, `voucher_no`, `warehouse_id`, `updateby`, `updatedate`) VALUES
(20220731215254, 20220731215056, 0, 1, '2022-07-31', 1, 1000, 0, 0, '0000-00-00 00:00:00'),
(20220803213946, 20220803213739, 0, 1, '2022-08-03', 1, 1001, 0, 0, '0000-00-00 00:00:00'),
(20220807083451, 20220803213739, 0, 1, '2022-08-07', 1, 1002, 0, 0, '0000-00-00 00:00:00'),
(20220807135941, 20220807135913, 0, 1, '2022-08-07', 1, 1003, 0, 0, '0000-00-00 00:00:00'),
(20220807145345, 20220807145331, 0, 1, '2022-08-07', 1, 1004, 0, 0, '0000-00-00 00:00:00'),
(20220807153736, 20220807153707, 0, 1, '2022-08-07', 2, 1005, 0, 0, '0000-00-00 00:00:00'),
(20220807154227, 20220807154155, 0, 1, '2022-08-07', 3, 1006, 0, 0, '0000-00-00 00:00:00'),
(20220807205922, 20220807205857, 0, 1, '2022-08-07', 3, 1007, 0, 0, '0000-00-00 00:00:00');

-- --------------------------------------------------------

--
-- Table structure for table `purchase_receive_details`
--

CREATE TABLE `purchase_receive_details` (
  `receive_id` bigint(20) NOT NULL,
  `product_id` bigint(20) NOT NULL,
  `receive_qty` int(11) NOT NULL,
  `product_rate` float NOT NULL,
  `store_id` int(11) NOT NULL,
  `discount` float NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `purchase_receive_details`
--

INSERT INTO `purchase_receive_details` (`receive_id`, `product_id`, `receive_qty`, `product_rate`, `store_id`, `discount`) VALUES
(20220731215254, 1, 100, 3000, 2, 0),
(20220803213946, 1, 30, 6000, 1, 0),
(20220807083451, 1, 30, 6000, 1, 0),
(20220807135941, 1, 30, 1000, 1, 0),
(20220807145345, 1, 100, 100, 2, 0),
(20220807153736, 3, 100, 100000, 2, 0),
(20220807154227, 4, 70, 100000, 2, 0),
(20220807205922, 6, 100, 100000, 2, 0);

-- --------------------------------------------------------

--
-- Table structure for table `purchase_return`
--

CREATE TABLE `purchase_return` (
  `preturn_id` int(11) NOT NULL,
  `store_id` int(11) NOT NULL,
  `warehouse_id` int(11) NOT NULL,
  `supplier_id` int(11) NOT NULL,
  `po_no` bigint(20) NOT NULL,
  `return_date` date NOT NULL,
  `totalamount` float NOT NULL,
  `totaldiscount` float NOT NULL,
  `return_reason` varchar(250) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `createby` int(11) NOT NULL,
  `createdate` datetime NOT NULL,
  `updateby` int(11) NOT NULL,
  `updatedate` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `purchase_return_details`
--

CREATE TABLE `purchase_return_details` (
  `preturn_id` int(11) NOT NULL,
  `product_id` bigint(20) NOT NULL,
  `qty` int(11) NOT NULL,
  `product_rate` float NOT NULL,
  `store_id` int(11) NOT NULL,
  `discount` float DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Stand-in structure for view `recovery_list`
-- (See below for the actual view)
--
CREATE TABLE `recovery_list` (
`over_due` double
,`store_id` int(11)
,`invoice_no` varchar(20)
,`customer_id` int(11)
,`sales_date` date
,`lease_id` int(11)
,`installment_amnt` float
,`gurrantor_1` int(11)
,`remaining_amnt` float
,`package_price` float
,`advance_amnt` int(11)
,`receive_amnt` double
,`receive_date` date
,`is_installment` int(11)
,`lease_duration` int(11)
,`advance` decimal(2,2)
,`markup` decimal(2,2)
);

-- --------------------------------------------------------

--
-- Table structure for table `role_permission`
--

CREATE TABLE `role_permission` (
  `id` int(11) NOT NULL,
  `fk_module_id` int(11) NOT NULL,
  `role_id` int(11) NOT NULL,
  `create` tinyint(1) DEFAULT NULL,
  `read` tinyint(1) DEFAULT NULL,
  `update` tinyint(1) DEFAULT NULL,
  `delete` tinyint(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `role_permission`
--

INSERT INTO `role_permission` (`id`, `fk_module_id`, `role_id`, `create`, `read`, `update`, `delete`) VALUES
(52, 8, 4, 0, 0, 0, 0),
(53, 6, 4, 0, 0, 0, 0),
(54, 5, 4, 0, 0, 0, 0),
(55, 13, 4, 0, 0, 0, 0),
(56, 14, 4, 0, 0, 0, 0),
(57, 7, 4, 0, 0, 0, 0),
(58, 10, 4, 0, 0, 0, 0),
(59, 12, 4, 0, 0, 0, 0),
(61, 3, 4, 0, 0, 0, 0),
(62, 9, 4, 0, 0, 0, 0),
(63, 4, 4, 0, 0, 0, 0),
(64, 11, 4, 0, 0, 0, 0),
(178, 3, 1, 0, 0, 0, 0),
(179, 4, 1, 0, 0, 0, 0),
(180, 5, 1, 0, 0, 0, 0),
(181, 6, 1, 0, 0, 0, 0),
(182, 7, 1, 0, 0, 0, 0),
(183, 8, 1, 0, 0, 0, 0),
(184, 9, 1, 0, 0, 0, 0),
(185, 10, 1, 0, 0, 0, 0),
(186, 11, 1, 0, 0, 0, 0),
(187, 12, 1, 0, 0, 0, 0),
(188, 13, 1, 0, 0, 0, 0),
(189, 14, 1, 0, 0, 0, 0),
(214, 8, 5, 0, 0, 0, 0),
(215, 6, 5, 0, 0, 0, 0),
(216, 5, 5, 1, 1, 1, 1),
(217, 13, 5, 1, 1, 1, 1),
(218, 14, 5, 0, 0, 0, 0),
(219, 7, 5, 0, 0, 0, 0),
(220, 10, 5, 0, 0, 0, 0),
(221, 12, 5, 0, 0, 0, 0),
(223, 3, 5, 0, 0, 0, 0),
(224, 9, 5, 0, 0, 0, 0),
(225, 4, 5, 0, 0, 0, 0),
(226, 11, 5, 0, 0, 0, 0),
(313, 8, 2, 0, 0, 0, 0),
(314, 6, 2, 0, 0, 0, 0),
(315, 5, 2, 0, 0, 0, 0),
(316, 13, 2, 0, 0, 0, 0),
(317, 14, 2, 0, 0, 0, 0),
(318, 7, 2, 0, 0, 0, 0),
(319, 10, 2, 1, 1, 1, 1),
(320, 18, 2, 1, 1, 1, 1),
(321, 12, 2, 1, 1, 1, 1),
(322, 16, 2, 0, 0, 0, 0),
(323, 17, 2, 1, 1, 1, 1),
(324, 3, 2, 1, 1, 1, 1),
(325, 9, 2, 0, 0, 0, 0),
(326, 4, 2, 0, 0, 0, 0),
(327, 11, 2, 0, 0, 0, 0),
(473, 1, 3, 1, 1, 0, 0),
(474, 6, 3, 0, 1, 0, 1),
(475, 13, 3, 0, 0, 0, 0),
(476, 7, 3, 0, 1, 0, 0),
(477, 10, 3, 1, 1, 1, 1),
(478, 14, 3, 0, 0, 0, 0),
(479, 19, 3, 0, 0, 0, 0),
(480, 18, 3, 0, 0, 0, 0),
(481, 12, 3, 1, 1, 1, 1),
(482, 17, 3, 1, 1, 1, 0),
(483, 3, 3, 0, 0, 0, 0),
(484, 9, 3, 0, 0, 0, 0);

-- --------------------------------------------------------

--
-- Table structure for table `sales_parent`
--

CREATE TABLE `sales_parent` (
  `sale_id` bigint(20) NOT NULL,
  `sale_type_id` tinyint(4) NOT NULL,
  `store_id` int(11) NOT NULL,
  `invoice_no` varchar(20) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `pay_slip_no` varchar(50) NOT NULL,
  `customer_id` int(11) NOT NULL,
  `salesman` int(11) NOT NULL,
  `destination` varchar(100) DEFAULT NULL,
  `sales_date` date NOT NULL,
  `sales_time` time NOT NULL,
  `lease_id` int(11) DEFAULT NULL,
  `gurrantor_1` int(11) DEFAULT NULL,
  `gurrantor_2` int(11) DEFAULT NULL,
  `inquiry_officer` int(11) DEFAULT NULL,
  `total_amnt` float DEFAULT NULL,
  `package_price` float DEFAULT NULL,
  `advance_amnt` int(11) DEFAULT NULL,
  `remaining_amnt` float DEFAULT NULL,
  `installment_amnt` float DEFAULT NULL,
  `is_lease_settled` tinyint(1) NOT NULL DEFAULT 0,
  `updateby` int(11) NOT NULL,
  `updatedate` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `sales_parent`
--

INSERT INTO `sales_parent` (`sale_id`, `sale_type_id`, `store_id`, `invoice_no`, `pay_slip_no`, `customer_id`, `salesman`, `destination`, `sales_date`, `sales_time`, `lease_id`, `gurrantor_1`, `gurrantor_2`, `inquiry_officer`, `total_amnt`, `package_price`, `advance_amnt`, `remaining_amnt`, `installment_amnt`, `is_lease_settled`, `updateby`, `updatedate`) VALUES
(20220810211248, 1, 2, '1000', '50000888', 27, 3, '2', '2022-08-10', '21:12:48', NULL, NULL, NULL, NULL, 3900000, 0, 0, NULL, 0, 0, 0, '0000-00-00 00:00:00'),
(20220810211457, 1, 2, '1001', '5600000', 27, 3, 'ADJUMANI', '2022-08-10', '21:14:57', NULL, NULL, NULL, NULL, 420000, 0, 0, NULL, 0, 0, 0, '0000-00-00 00:00:00');

-- --------------------------------------------------------

--
-- Table structure for table `sales_return`
--

CREATE TABLE `sales_return` (
  `sreturn_id` int(11) NOT NULL,
  `customer_id` int(11) NOT NULL,
  `store_id` int(11) NOT NULL,
  `sale_type_id` tinyint(1) DEFAULT NULL,
  `invoice_no` varchar(20) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `return_date` date NOT NULL,
  `totalamount` float NOT NULL,
  `totaldiscount` float NOT NULL,
  `return_reason` varchar(250) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `createby` int(11) NOT NULL,
  `createdate` datetime NOT NULL,
  `updateby` int(11) NOT NULL,
  `updatedate` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `sales_return_details`
--

CREATE TABLE `sales_return_details` (
  `sreturn_id` int(11) NOT NULL,
  `product_id` bigint(20) NOT NULL,
  `qty` int(11) NOT NULL,
  `product_rate` float NOT NULL,
  `discount` float DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `sale_details`
--

CREATE TABLE `sale_details` (
  `sale_id` bigint(20) NOT NULL,
  `product_id` int(11) NOT NULL,
  `qty` int(11) NOT NULL,
  `sell_price` float NOT NULL,
  `lease_unit_price` float DEFAULT NULL,
  `sale_type_id` tinyint(4) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `sale_details`
--

INSERT INTO `sale_details` (`sale_id`, `product_id`, `qty`, `sell_price`, `lease_unit_price`, `sale_type_id`) VALUES
(20220807154352, 0, 30, 100, NULL, 1),
(20220807210643, 4, 30, 100000, NULL, 1),
(20220808235748, 3, 6, 600, NULL, 1),
(20220810210925, 3, 40, 6000, NULL, 1),
(20220810211248, 4, 50, 78000, NULL, 1),
(20220810211457, 3, 70, 6000, NULL, 1);

-- --------------------------------------------------------

--
-- Table structure for table `sale_type`
--

CREATE TABLE `sale_type` (
  `sale_type_id` tinyint(4) NOT NULL,
  `sale_type` varchar(100) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `shortcode` varchar(3) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `createby` int(11) NOT NULL,
  `createdate` datetime NOT NULL,
  `updateby` int(11) NOT NULL,
  `upadatedate` datetime NOT NULL,
  `isactive` tinyint(1) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `sale_type`
--

INSERT INTO `sale_type` (`sale_type_id`, `sale_type`, `shortcode`, `createby`, `createdate`, `updateby`, `upadatedate`, `isactive`) VALUES
(1, 'Cash Sale', 'CS', 0, '2015-10-15 00:00:00', 0, '2015-10-15 00:00:00', 1),
(2, 'Partial Cash Sale', 'PS', 0, '2015-10-15 00:00:00', 0, '2015-10-15 00:00:00', 1),
(3, 'Lease Sale', 'LS', 0, '2015-10-15 00:00:00', 0, '2015-10-15 00:00:00', 1);

-- --------------------------------------------------------

--
-- Table structure for table `sec_role`
--

CREATE TABLE `sec_role` (
  `id` int(11) NOT NULL,
  `name` varchar(50) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `isactive` tinyint(1) NOT NULL,
  `createby` varchar(50) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `createdate` datetime NOT NULL,
  `updateby` varchar(50) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `updatedate` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `sec_role`
--

INSERT INTO `sec_role` (`id`, `name`, `isactive`, `createby`, `createdate`, `updateby`, `updatedate`) VALUES
(5, 'Pricing User', 1, '2', '2018-05-15 03:23:45', '', NULL),
(4, 'Purchase User', 1, '2', '2018-05-15 03:23:32', '', NULL),
(7, 'Sales', 1, '1', '2022-08-02 09:13:44', '', NULL),
(6, 'Sales Person', 1, '1', '2022-07-31 09:45:33', '', NULL),
(2, 'Store Admin', 1, '2', '2018-05-15 03:22:59', '', NULL),
(3, 'Store User', 1, '2', '2018-05-15 03:23:22', '', NULL),
(1, 'Super Admin', 1, '2', '2018-05-15 03:22:44', '', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `sec_userrole`
--

CREATE TABLE `sec_userrole` (
  `id` int(11) NOT NULL,
  `user_id` varchar(50) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `roleid` int(11) NOT NULL,
  `createby` varchar(50) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `createdate` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `sec_userrole`
--

INSERT INTO `sec_userrole` (`id`, `user_id`, `roleid`, `createby`, `createdate`) VALUES
(1, '3', 2, '2', '2018-05-15 03:24:36'),
(2, '6', 3, '2', '2018-05-15 03:33:39');

-- --------------------------------------------------------

--
-- Table structure for table `setting`
--

CREATE TABLE `setting` (
  `id` int(11) NOT NULL,
  `title` varchar(255) DEFAULT NULL,
  `address` text DEFAULT NULL,
  `email` varchar(50) DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `logo` varchar(50) DEFAULT NULL,
  `favicon` varchar(100) DEFAULT NULL,
  `language` varchar(100) DEFAULT NULL,
  `site_align` varchar(50) DEFAULT NULL,
  `footer_text` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `setting`
--

INSERT INTO `setting` (`id`, `title`, `address`, `email`, `phone`, `logo`, `favicon`, `language`, `site_align`, `footer_text`) VALUES
(2, 'Multi Store Management', '98 Green Road, Farmgate, Dhaka-1215.', 'bdtask@gmail.com', '0123456789', 'assets/img/icons/logo.png', 'assets/img/icons/m.png', 'english', 'LTR', '2017Â©Copyright');

-- --------------------------------------------------------

--
-- Table structure for table `stock_movement`
--

CREATE TABLE `stock_movement` (
  `movement_id` int(11) NOT NULL,
  `proposal_code` varchar(20) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `issue_code` varchar(20) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL,
  `for_store_id` int(11) NOT NULL,
  `from_store_id` int(11) NOT NULL,
  `for_warehouse` int(11) DEFAULT NULL,
  `from_warehouse` int(11) DEFAULT NULL,
  `proposal_datetime` date NOT NULL,
  `proposal_by` int(11) NOT NULL,
  `issue_datetime` date NOT NULL,
  `issue_by` int(11) NOT NULL,
  `proposal_remarks` varchar(250) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL,
  `issue_remarks` varchar(250) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL,
  `receive_by` int(11) NOT NULL,
  `receive_datetime` date NOT NULL,
  `receive_remarks` varchar(250) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL,
  `is_approved` tinyint(1) NOT NULL DEFAULT 0,
  `is_proposed` tinyint(1) DEFAULT NULL,
  `is_issued` tinyint(1) DEFAULT NULL,
  `is_received` tinyint(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `stock_movement_details`
--

CREATE TABLE `stock_movement_details` (
  `movement_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `proposal_qty` int(11) NOT NULL,
  `issue_qty` int(11) NOT NULL,
  `received_qty` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Stand-in structure for view `stoere_overdue`
-- (See below for the actual view)
--
CREATE TABLE `stoere_overdue` (
`store_id` int(11)
,`invoice_no` varchar(20)
,`customer_id` int(11)
,`sales_date` date
,`lease_id` int(11)
,`installment_amnt` float
,`package_price` float
,`advance_amnt` int(11)
,`receive_amnt` float
,`receive_date` date
,`is_installment` int(11)
,`lease_duration` int(11)
,`advance` decimal(2,2)
,`markup` decimal(2,2)
);

-- --------------------------------------------------------

--
-- Table structure for table `store`
--

CREATE TABLE `store` (
  `store_id` int(11) NOT NULL,
  `store_name` varchar(50) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `store_code` varchar(3) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `store_phone` varchar(50) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `store_address` varchar(200) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `createby` varchar(20) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `createdate` datetime NOT NULL,
  `updateby` varchar(20) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL,
  `updatedate` datetime DEFAULT NULL,
  `isactive` tinyint(1) NOT NULL,
  `manager_name` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `store`
--

INSERT INTO `store` (`store_id`, `store_name`, `store_code`, `store_phone`, `store_address`, `createby`, `createdate`, `updateby`, `updatedate`, `isactive`, `manager_name`) VALUES
(1, 'Bombo', 'Bom', '078978767676', 'Bombo', '1', '2022-07-31 21:46:51', NULL, NULL, 1, NULL),
(2, 'Mbarara', 'Mba', '07897876700', 'Mbarara', '1', '2022-08-10 20:45:13', NULL, NULL, 1, 'Henry');

-- --------------------------------------------------------

--
-- Table structure for table `supplier`
--

CREATE TABLE `supplier` (
  `supplier_id` int(11) NOT NULL,
  `supplier_code` varchar(20) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `supplier_name` varchar(200) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `address` varchar(150) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `phone` varchar(100) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `email` varchar(50) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `contact_per_name` varchar(50) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `c_p_contact` varchar(30) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `isactive` tinyint(1) NOT NULL,
  `createby` int(11) NOT NULL,
  `createdate` datetime NOT NULL,
  `updateby` int(11) NOT NULL,
  `updatedate` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `supplier`
--

INSERT INTO `supplier` (`supplier_id`, `supplier_code`, `supplier_name`, `address`, `phone`, `email`, `contact_per_name`, `c_p_contact`, `isactive`, `createby`, `createdate`, `updateby`, `updatedate`) VALUES
(2, 'sup-1', 'MS ROOFINGS', '', '', '', '', '', 1, 1, '2022-08-07 15:02:26', 0, '0000-00-00 00:00:00'),
(3, 'sup-2', 'MS UGANDA BAATI LTD', '', '', '', '', '', 1, 1, '2022-08-07 15:02:55', 0, '0000-00-00 00:00:00'),
(4, 'sup-3', 'MS MMI STEEL MILLSLTS/KIBOKO', '', '', '', '', '', 1, 1, '2022-08-07 15:03:12', 0, '0000-00-00 00:00:00'),
(5, 'sup-4', 'MS GOOD WILL UGANDA LTD', '', '', '', '', '', 1, 1, '2022-08-07 15:03:32', 0, '0000-00-00 00:00:00'),
(6, 'sup-5', 'MS HIMA CEMENT LTD', '', '', '', '', '', 1, 1, '2022-08-07 15:03:45', 0, '0000-00-00 00:00:00'),
(7, 'sup-6', 'MS TORORO CEMENT LTD', '', '', '', '', '', 1, 1, '2022-08-07 15:03:58', 0, '0000-00-00 00:00:00'),
(8, 'sup-7', 'MS KAMPALA CEMENT LTD', '', '', '', '', '', 1, 1, '2022-08-07 15:04:10', 0, '0000-00-00 00:00:00');

-- --------------------------------------------------------

--
-- Table structure for table `synchronizer_setting`
--

CREATE TABLE `synchronizer_setting` (
  `id` int(11) NOT NULL,
  `hostname` varchar(100) NOT NULL,
  `username` varchar(100) NOT NULL,
  `password` varchar(100) NOT NULL,
  `port` varchar(10) NOT NULL,
  `debug` varchar(10) NOT NULL,
  `project_root` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `synchronizer_setting`
--

INSERT INTO `synchronizer_setting` (`id`, `hostname`, `username`, `password`, `port`, `debug`, `project_root`) VALUES
(8, '70.35.198.200', 'spreadcargo', '123123123123', '21', 'true', './public_html/');

-- --------------------------------------------------------

--
-- Table structure for table `test`
--

CREATE TABLE `test` (
  `test_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `tmp_store_stock`
--

CREATE TABLE `tmp_store_stock` (
  `StoreID` int(11) NOT NULL,
  `Stock_Date` datetime NOT NULL,
  `ProdID` bigint(20) NOT NULL,
  `InQty` int(11) NOT NULL,
  `OutQty` int(11) NOT NULL,
  `category_id` varchar(11) NOT NULL,
  `brand_id` varchar(11) NOT NULL,
  `model_id` varchar(11) NOT NULL,
  `Remarks` varchar(50) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `tmp_store_stock`
--

INSERT INTO `tmp_store_stock` (`StoreID`, `Stock_Date`, `ProdID`, `InQty`, `OutQty`, `category_id`, `brand_id`, `model_id`, `Remarks`) VALUES
(1, '2022-08-03 00:00:00', 1, 90, 0, '', '', '', 'purchase_receive'),
(2, '2022-07-31 00:00:00', 1, 200, 0, '', '', '', 'purchase_receive'),
(2, '2022-08-07 00:00:00', 3, 100, 70, '', '', '', 'purchase_receive'),
(2, '2022-08-07 00:00:00', 4, 70, 50, '', '', '', 'purchase_receive'),
(2, '2022-08-07 00:00:00', 6, 100, 0, '', '', '', 'purchase_receive');

-- --------------------------------------------------------

--
-- Table structure for table `treeview_items`
--

CREATE TABLE `treeview_items` (
  `id` int(11) NOT NULL,
  `name` varchar(200) NOT NULL,
  `text` varchar(200) NOT NULL,
  `parent_id` varchar(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `user`
--

CREATE TABLE `user` (
  `id` int(11) NOT NULL,
  `firstname` varchar(50) DEFAULT NULL,
  `lastname` varchar(50) DEFAULT NULL,
  `about` text DEFAULT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(32) NOT NULL,
  `password_reset_token` varchar(20) DEFAULT NULL,
  `image` varchar(100) DEFAULT NULL,
  `last_login` datetime DEFAULT NULL,
  `last_logout` datetime DEFAULT NULL,
  `ip_address` varchar(14) DEFAULT NULL,
  `status` tinyint(1) NOT NULL DEFAULT 1,
  `is_admin` tinyint(4) NOT NULL DEFAULT 0,
  `store_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `user`
--

INSERT INTO `user` (`id`, `firstname`, `lastname`, `about`, `email`, `password`, `password_reset_token`, `image`, `last_login`, `last_logout`, `ip_address`, `status`, `is_admin`, `store_id`) VALUES
(1, NULL, NULL, NULL, 'admin@admin.com', '21232f297a57a5a743894a0e4a801fc3', NULL, NULL, '2022-08-10 21:15:39', '2022-08-10 21:10:43', '::1', 1, 1, NULL),
(2, 'Henry', 'May', 'Henry', 'henry@admin.com', '21232f297a57a5a743894a0e4a801fc3', NULL, '', NULL, NULL, NULL, 1, 1, 2),
(3, 'Henry', 'May', 'hery', 'henry@gmail.com', '21232f297a57a5a743894a0e4a801fc3', NULL, './assets/img/user/Website-Logo.png', '2022-08-10 21:10:58', '2022-08-10 21:15:30', '::1', 1, 0, 2);

-- --------------------------------------------------------

--
-- Table structure for table `warehouse`
--

CREATE TABLE `warehouse` (
  `warehouse_id` int(11) NOT NULL,
  `warehouse_name` varchar(50) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `warehouse_code` varchar(3) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `warehouse_phone` varchar(50) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `warehouse_address` varchar(200) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `createby` varchar(20) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `createdate` datetime NOT NULL,
  `updateby` varchar(20) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `updatedate` datetime NOT NULL,
  `isactive` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Structure for view `recovery_list`
--
DROP TABLE IF EXISTS `recovery_list`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `recovery_list`  AS SELECT `sales_parent`.`remaining_amnt`- sum(`payment_collection`.`receive_amnt`) AS `over_due`, `sales_parent`.`store_id` AS `store_id`, `sales_parent`.`invoice_no` AS `invoice_no`, `sales_parent`.`customer_id` AS `customer_id`, `sales_parent`.`sales_date` AS `sales_date`, `sales_parent`.`lease_id` AS `lease_id`, `sales_parent`.`installment_amnt` AS `installment_amnt`, `sales_parent`.`gurrantor_1` AS `gurrantor_1`, `sales_parent`.`remaining_amnt` AS `remaining_amnt`, `sales_parent`.`package_price` AS `package_price`, `sales_parent`.`advance_amnt` AS `advance_amnt`, sum(`payment_collection`.`receive_amnt`) AS `receive_amnt`, `payment_collection`.`receive_date` AS `receive_date`, `payment_collection`.`is_installment` AS `is_installment`, `lease`.`lease_duration` AS `lease_duration`, `lease`.`advance` AS `advance`, `lease`.`markup` AS `markup` FROM ((`sales_parent` join `payment_collection`) join `lease`) WHERE `sales_parent`.`invoice_no` = `payment_collection`.`invoice_no` AND `sales_parent`.`lease_id` = `lease`.`lease_id` AND `payment_collection`.`is_installment` = 1 GROUP BY `sales_parent`.`invoice_no` ;

-- --------------------------------------------------------

--
-- Structure for view `stoere_overdue`
--
DROP TABLE IF EXISTS `stoere_overdue`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `stoere_overdue`  AS SELECT `sales_parent`.`store_id` AS `store_id`, `sales_parent`.`invoice_no` AS `invoice_no`, `sales_parent`.`customer_id` AS `customer_id`, `sales_parent`.`sales_date` AS `sales_date`, `sales_parent`.`lease_id` AS `lease_id`, `sales_parent`.`installment_amnt` AS `installment_amnt`, `sales_parent`.`package_price` AS `package_price`, `sales_parent`.`advance_amnt` AS `advance_amnt`, `payment_collection`.`receive_amnt` AS `receive_amnt`, `payment_collection`.`receive_date` AS `receive_date`, `payment_collection`.`is_installment` AS `is_installment`, `lease`.`lease_duration` AS `lease_duration`, `lease`.`advance` AS `advance`, `lease`.`markup` AS `markup` FROM ((`sales_parent` join `payment_collection`) join `lease`) WHERE `sales_parent`.`invoice_no` = `payment_collection`.`invoice_no` AND `sales_parent`.`lease_id` = `lease`.`lease_id` ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `accesslog`
--
ALTER TABLE `accesslog`
  ADD UNIQUE KEY `SerialNo` (`sl_no`);

--
-- Indexes for table `acc_coa`
--
ALTER TABLE `acc_coa`
  ADD PRIMARY KEY (`HeadName`);

--
-- Indexes for table `acc_customer_income`
--
ALTER TABLE `acc_customer_income`
  ADD UNIQUE KEY `ID` (`ID`);

--
-- Indexes for table `acc_glsummarybalance`
--
ALTER TABLE `acc_glsummarybalance`
  ADD UNIQUE KEY `ID` (`ID`);

--
-- Indexes for table `acc_income_expence`
--
ALTER TABLE `acc_income_expence`
  ADD UNIQUE KEY `ID` (`ID`);

--
-- Indexes for table `acc_transaction`
--
ALTER TABLE `acc_transaction`
  ADD UNIQUE KEY `ID` (`ID`);

--
-- Indexes for table `customer`
--
ALTER TABLE `customer`
  ADD PRIMARY KEY (`customer_id`),
  ADD UNIQUE KEY `customer_code_unique` (`customer_code`) USING BTREE;

--
-- Indexes for table `customer_gurrantor_map`
--
ALTER TABLE `customer_gurrantor_map`
  ADD PRIMARY KEY (`rowid`),
  ADD UNIQUE KEY `lease_id` (`lease_id`,`customer_id`,`gurrantor_id`);

--
-- Indexes for table `districts`
--
ALTER TABLE `districts`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `employee`
--
ALTER TABLE `employee`
  ADD PRIMARY KEY (`employeeno`),
  ADD UNIQUE KEY `ID` (`id`);

--
-- Indexes for table `gurrantor`
--
ALTER TABLE `gurrantor`
  ADD PRIMARY KEY (`gurrantor_id`),
  ADD UNIQUE KEY `gurrantor_code_unique` (`gurrantor_code`);

--
-- Indexes for table `language`
--
ALTER TABLE `language`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `lease`
--
ALTER TABLE `lease`
  ADD PRIMARY KEY (`lease_id`);

--
-- Indexes for table `lease_product_map`
--
ALTER TABLE `lease_product_map`
  ADD PRIMARY KEY (`row_id`),
  ADD KEY `fk_lease_id1` (`lease_id`),
  ADD KEY `fk_prod_id1` (`product_id`);

--
-- Indexes for table `lease_store_map`
--
ALTER TABLE `lease_store_map`
  ADD PRIMARY KEY (`row_id`),
  ADD KEY `fk_store_lease_id1` (`lease_id`);

--
-- Indexes for table `message`
--
ALTER TABLE `message`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `module`
--
ALTER TABLE `module`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `payment_collection`
--
ALTER TABLE `payment_collection`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `product`
--
ALTER TABLE `product`
  ADD PRIMARY KEY (`product_id`);

--
-- Indexes for table `product_brand`
--
ALTER TABLE `product_brand`
  ADD PRIMARY KEY (`brand_id`),
  ADD UNIQUE KEY `brand_name_unique` (`brand_name`);

--
-- Indexes for table `product_category`
--
ALTER TABLE `product_category`
  ADD PRIMARY KEY (`category_id`),
  ADD UNIQUE KEY `category_name_unique` (`category_name`);

--
-- Indexes for table `product_colors`
--
ALTER TABLE `product_colors`
  ADD PRIMARY KEY (`color_id`);

--
-- Indexes for table `product_manufacturers`
--
ALTER TABLE `product_manufacturers`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unit_name_unique` (`manufacturer_name`);

--
-- Indexes for table `product_model`
--
ALTER TABLE `product_model`
  ADD PRIMARY KEY (`model_id`),
  ADD UNIQUE KEY `model_name_unique` (`model_name`);

--
-- Indexes for table `product_unit`
--
ALTER TABLE `product_unit`
  ADD PRIMARY KEY (`unit_id`),
  ADD UNIQUE KEY `unit_name_unique` (`unit_name`);

--
-- Indexes for table `purchase_order`
--
ALTER TABLE `purchase_order`
  ADD PRIMARY KEY (`po_no`);

--
-- Indexes for table `purchase_order_details`
--
ALTER TABLE `purchase_order_details`
  ADD PRIMARY KEY (`row_id`),
  ADD KEY `fk_po_no1` (`po_no`);

--
-- Indexes for table `purchase_receive`
--
ALTER TABLE `purchase_receive`
  ADD PRIMARY KEY (`receive_id`),
  ADD KEY `fk_po_no` (`po_no`);

--
-- Indexes for table `purchase_receive_details`
--
ALTER TABLE `purchase_receive_details`
  ADD KEY `fk_receive_id` (`receive_id`);

--
-- Indexes for table `purchase_return`
--
ALTER TABLE `purchase_return`
  ADD PRIMARY KEY (`preturn_id`);

--
-- Indexes for table `role_permission`
--
ALTER TABLE `role_permission`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_module_id` (`fk_module_id`),
  ADD KEY `fk_user_id` (`role_id`);

--
-- Indexes for table `sales_parent`
--
ALTER TABLE `sales_parent`
  ADD PRIMARY KEY (`sale_id`),
  ADD UNIQUE KEY `invoice_no` (`invoice_no`),
  ADD KEY `sale_type_id` (`sale_type_id`);

--
-- Indexes for table `sales_return`
--
ALTER TABLE `sales_return`
  ADD PRIMARY KEY (`sreturn_id`);

--
-- Indexes for table `sale_details`
--
ALTER TABLE `sale_details`
  ADD UNIQUE KEY `sale_id` (`sale_id`,`product_id`);

--
-- Indexes for table `sale_type`
--
ALTER TABLE `sale_type`
  ADD PRIMARY KEY (`sale_type_id`),
  ADD UNIQUE KEY `shortcode` (`shortcode`);

--
-- Indexes for table `sec_role`
--
ALTER TABLE `sec_role`
  ADD PRIMARY KEY (`name`),
  ADD UNIQUE KEY `ID` (`id`);

--
-- Indexes for table `sec_userrole`
--
ALTER TABLE `sec_userrole`
  ADD UNIQUE KEY `ID` (`id`);

--
-- Indexes for table `setting`
--
ALTER TABLE `setting`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `stock_movement`
--
ALTER TABLE `stock_movement`
  ADD PRIMARY KEY (`movement_id`),
  ADD UNIQUE KEY `proposal_code_unique` (`proposal_code`),
  ADD UNIQUE KEY `issue_code_unique` (`issue_code`);

--
-- Indexes for table `stock_movement_details`
--
ALTER TABLE `stock_movement_details`
  ADD KEY `stock_movement_details_ibfk_1` (`movement_id`);

--
-- Indexes for table `store`
--
ALTER TABLE `store`
  ADD PRIMARY KEY (`store_id`);

--
-- Indexes for table `supplier`
--
ALTER TABLE `supplier`
  ADD PRIMARY KEY (`supplier_id`);

--
-- Indexes for table `synchronizer_setting`
--
ALTER TABLE `synchronizer_setting`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `test`
--
ALTER TABLE `test`
  ADD PRIMARY KEY (`test_id`);

--
-- Indexes for table `user`
--
ALTER TABLE `user`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `warehouse`
--
ALTER TABLE `warehouse`
  ADD PRIMARY KEY (`warehouse_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `accesslog`
--
ALTER TABLE `accesslog`
  MODIFY `sl_no` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=63;

--
-- AUTO_INCREMENT for table `acc_customer_income`
--
ALTER TABLE `acc_customer_income`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `acc_glsummarybalance`
--
ALTER TABLE `acc_glsummarybalance`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `acc_income_expence`
--
ALTER TABLE `acc_income_expence`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `acc_transaction`
--
ALTER TABLE `acc_transaction`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=369;

--
-- AUTO_INCREMENT for table `customer`
--
ALTER TABLE `customer`
  MODIFY `customer_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=37;

--
-- AUTO_INCREMENT for table `customer_gurrantor_map`
--
ALTER TABLE `customer_gurrantor_map`
  MODIFY `rowid` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=27;

--
-- AUTO_INCREMENT for table `districts`
--
ALTER TABLE `districts`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=137;

--
-- AUTO_INCREMENT for table `employee`
--
ALTER TABLE `employee`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT for table `gurrantor`
--
ALTER TABLE `gurrantor`
  MODIFY `gurrantor_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=81;

--
-- AUTO_INCREMENT for table `language`
--
ALTER TABLE `language`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=456;

--
-- AUTO_INCREMENT for table `lease`
--
ALTER TABLE `lease`
  MODIFY `lease_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `lease_product_map`
--
ALTER TABLE `lease_product_map`
  MODIFY `row_id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `lease_store_map`
--
ALTER TABLE `lease_store_map`
  MODIFY `row_id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `message`
--
ALTER TABLE `message`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `module`
--
ALTER TABLE `module`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=20;

--
-- AUTO_INCREMENT for table `payment_collection`
--
ALTER TABLE `payment_collection`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `product`
--
ALTER TABLE `product`
  MODIFY `product_id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `product_brand`
--
ALTER TABLE `product_brand`
  MODIFY `brand_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `product_category`
--
ALTER TABLE `product_category`
  MODIFY `category_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `product_colors`
--
ALTER TABLE `product_colors`
  MODIFY `color_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `product_manufacturers`
--
ALTER TABLE `product_manufacturers`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `product_model`
--
ALTER TABLE `product_model`
  MODIFY `model_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT for table `product_unit`
--
ALTER TABLE `product_unit`
  MODIFY `unit_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `purchase_order_details`
--
ALTER TABLE `purchase_order_details`
  MODIFY `row_id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=865317715264155;

--
-- AUTO_INCREMENT for table `purchase_return`
--
ALTER TABLE `purchase_return`
  MODIFY `preturn_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `role_permission`
--
ALTER TABLE `role_permission`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=485;

--
-- AUTO_INCREMENT for table `sales_parent`
--
ALTER TABLE `sales_parent`
  MODIFY `sale_id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=20220810211458;

--
-- AUTO_INCREMENT for table `sales_return`
--
ALTER TABLE `sales_return`
  MODIFY `sreturn_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `sale_type`
--
ALTER TABLE `sale_type`
  MODIFY `sale_type_id` tinyint(4) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `sec_role`
--
ALTER TABLE `sec_role`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `sec_userrole`
--
ALTER TABLE `sec_userrole`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=25;

--
-- AUTO_INCREMENT for table `setting`
--
ALTER TABLE `setting`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `stock_movement`
--
ALTER TABLE `stock_movement`
  MODIFY `movement_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `store`
--
ALTER TABLE `store`
  MODIFY `store_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `supplier`
--
ALTER TABLE `supplier`
  MODIFY `supplier_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `synchronizer_setting`
--
ALTER TABLE `synchronizer_setting`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `test`
--
ALTER TABLE `test`
  MODIFY `test_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `user`
--
ALTER TABLE `user`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `warehouse`
--
ALTER TABLE `warehouse`
  MODIFY `warehouse_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `stock_movement_details`
--
ALTER TABLE `stock_movement_details`
  ADD CONSTRAINT `stock_movement_details_ibfk_1` FOREIGN KEY (`movement_id`) REFERENCES `stock_movement` (`movement_id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
