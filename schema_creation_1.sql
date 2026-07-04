-- =====================================================================
-- Olist E-Commerce Revenue Dashboard - Database Schema Creation
-- =====================================================================
-- Author: Thenmozhi Venkatesan
-- Database: Oracle 18c
-- Description: Table structures for the Olist Brazilian E-Commerce
--              dataset (9 relational tables)
-- =====================================================================

-- ---------------------------------------------------------------------
-- TABLE: ORDERS
-- ---------------------------------------------------------------------
create table orders_1(
order_id varchar2(50),
customer_id varchar2(50),
order_status varchar2(50),
order_purchase_timestamp date,
order_approved_at date,
order_delivered_carrier_date date,
order_delivered_customer_date date,
order_estimated_delivery_date date
);

select * from orders_1;

SELECT TO_CHAR(order_purchase_timestamp, 'DD-MON-YYYY HH24:MI:SS') AS purchase_time
FROM orders_1
WHERE ROWNUM <= 5;

-- ---------------------------------------------------------------------
-- TABLE: CUSTOMER
-- ---------------------------------------------------------------------
create table customer(
customer_id varchar2(50),
customer_unique_id varchar2(50),
customer_zip_code_prefix number,
customer_city varchar2(50),
customer_state varchar2(30)
);

select * from customer;

-- ---------------------------------------------------------------------
-- TABLE: ORDER_ITEM
-- ---------------------------------------------------------------------
create table order_item(
order_id varchar2(50),
order_item_id number,
product_id varchar2(50),
seller_id varchar2(50),
shipping_limit_date date,
price number,
freight_value number
);

select * from order_item;

-- ---------------------------------------------------------------------
-- TABLE: PRODUCTS
-- ---------------------------------------------------------------------
create table products(
product_id varchar2(50),
product_category_name varchar2(50),
product_name_lenght number,
product_description_lenght number,
product_photos_qty number,
product_weight_g number,
product_length_cm number,
product_height_cm number,
product_width_cm number
);

select * from products;

-- ---------------------------------------------------------------------
-- TABLE: SELLERS
-- ---------------------------------------------------------------------
create table sellers(
seller_id varchar2(50),
seller_zip_code_prefix number,
seller_city varchar2(100),
seller_state varchar2(100)
);

drop table sellers;

select * from sellers;

-- ---------------------------------------------------------------------
-- TABLE: REVIEWS
-- ---------------------------------------------------------------------
create table reviews(
review_id varchar2(50),
order_id varchar2(50),
review_score number,
review_creation_date date,
review_answer_timestamp date
);

drop table reviews;

select * from reviews;

-- ---------------------------------------------------------------------
-- TABLE: PAYMENTS
-- ---------------------------------------------------------------------
create table payments(
order_id varchar2(50),
payment_sequential number,
payment_type varchar2(50),
payment_installments number,
payment_value number
);

select * from payments;

-- ---------------------------------------------------------------------
-- TABLE: GEOLOCATION
-- ---------------------------------------------------------------------
create table geolocation(
geolocation_zip_code_prefix number,
geolocation_lat number,
geolocation_lng number,
geolocation_city varchar2(50),
geolocation_state varchar2(30)
);

select * from geolocation;

-- ---------------------------------------------------------------------
-- TABLE: CATEGORY_TRANSLATION
-- ---------------------------------------------------------------------
create table category_translation(
product_category_name varchar2(100),
product_category_name_english varchar2(100)
);
