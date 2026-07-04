-- =====================================================================
-- Olist E-Commerce Revenue Dashboard - Data Analysis Queries
-- =====================================================================
-- Author: Thenmozhi Venkatesan
-- Database: Oracle 18c
-- Description: All SQL analysis queries used for the Olist E-Commerce
--              Revenue Dashboard project, organized into sections for
--              readability.
--              Query logic is unchanged from the original work.
-- =====================================================================


-- =====================================================================
-- SECTION 1: BASIC EXPLORATORY QUERIES
-- =====================================================================

select * from orders_1;

select order_id,order_status
from orders_1
where order_status='delivered';

select order_id,order_status
from orders_1
where order_status='canceled' or order_status='unavailable';

select order_id, order_purchase_timestamp from orders_1
where order_purchase_timestamp>to_date('01-Jan-2018','dd-mon-yyyy');

select order_id,order_purchase_timestamp
from orders_1
order by order_purchase_timestamp desc;

select count(order_id) from orders_1;

select count(order_id), order_status from orders_1
group by order_status;

select count(order_id),to_char(order_purchase_timestamp,'yyyy')
from orders_1
group by to_char(order_purchase_timestamp,'yyyy');

select * from payments;

select sum(payment_value) from payments;

select payment_type,avg(payment_value)
from payments
group by payment_type;

select payment_type,count(payment_type)
from payments
group by payment_type
order by count(payment_type) desc;

select payment_type,sum(payment_value)
from payments
group by payment_type
order by sum(payment_value) desc;

select * from customer;

select customer_state,count(customer_state)
from customer
group by customer_state
order by count(customer_state) desc;

select * from order_item;

select * from products;

select count(oi.order_id),p.product_category_name
from order_item oi inner join products p
on oi.product_id=p.product_id
group by p.product_category_name
order by count(oi.order_id) desc;

select * from order_item;

select (seller_id),sum(price) from order_item
group by seller_id
order by sum(price) desc;

select * from sellers;

select * from products;

select p.product_category_name,sum(oi.price)
from products p inner join order_item oi
on p.product_id= oi.product_id
group by p.product_category_name
order by sum(oi.price) desc;

select * from payments;

select * from customer;

select * from orders_1;

select c.customer_state,sum(p.payment_value)
from customer c inner join orders_1 o
on c.customer_id=o.customer_id inner join payments p
on p.order_id=o.order_id
group by c.customer_state
order by sum(p.payment_value) desc;

select * from reviews;

select s.seller_state, round(avg(r.review_score),2)
from sellers s inner join order_item oi
on s.seller_id=oi.seller_id inner join reviews r
on oi.order_id=r.order_id
group by s.seller_state
order by avg(r.review_score) desc;

select p.product_category_name,round(avg(r.review_score),2)
from products p inner join order_item oi
on p.product_id=oi.product_id inner join reviews r
on r.order_id= oi.order_id
group by p.product_category_name
order by round(avg(r.review_score),2) asc;

select * from orders_1;

select * from geolocation;


-- =====================================================================
-- SECTION 2: BUSINESS ANALYSIS QUERIES (JOINS & AGGREGATIONS)
-- =====================================================================

-- Average delivery time by customer state
select avg(round(
(o.order_delivered_customer_date-o.order_purchase_timestamp),0)) ,c.customer_state
from orders_1 o inner join customer c on
o.customer_id=c.customer_id
group by customer_state
order by avg(round((o.order_delivered_customer_date-o.order_purchase_timestamp),0)) desc;

-- Cancelled orders by customer state
select count(o.order_status),o.order_status,c.customer_state from
orders_1 o inner join customer c on
o.customer_id=c.customer_id
where o.order_status='canceled'
group by c.customer_state,o.order_status
order by count(o.order_status) desc;

select count(order_status) from orders_1 where order_status='canceled';

select * from order_item;

-- Revenue by payment type
select p.payment_type ,sum(oi.price)
from payments p inner join order_item oi
on p.order_id= oi.order_id
group by p.payment_type
order by sum(oi.price) desc;

select * from orders_1;
select * from sellers;

-- Delivered orders by seller state
select s.seller_state,count(o.order_status),o.order_status
from orders_1 o inner join order_item oi
on o.order_id=oi.order_id inner join sellers s
on s.seller_id=oi.seller_id
where o.order_status='delivered'
group by s.seller_state,o.order_status
order by count(o.order_status) desc;

-- Cancelled orders by product category
select p.product_category_name,count(o.order_status),o.order_status
from products p inner join order_item oi
on p.product_id=oi.product_id inner join orders_1 o
on o.order_id=oi.order_id
where o.order_status='canceled'
group by product_category_name,o.order_status
order by count(o.order_status) desc;

select * from customer;
select * from payments;
select * from products;

-- Average payment value by customer state
select c.customer_state,round(avg(p.payment_value),2)
from customer c inner join orders_1 o
on c.customer_id =o.customer_id inner join payments p
on p.order_id=o.order_id
group by c.customer_state
order by round(avg(p.payment_value),2) desc;

-- Average payment value by product category
select p.product_category_name,round(avg(pa.payment_value),2)
from products p inner join order_item oi
on p.product_id=oi.product_id inner join payments pa
on pa.order_id=oi.order_id
group by p.product_category_name
order by round(avg(pa.payment_value),2) desc;

-- Average review score by seller state
select s.seller_state,round(avg(r.review_score),2)
from sellers s inner join order_item oi
on s.seller_id=oi.seller_id inner join reviews r
on r.order_id=oi.order_id
group by s.seller_state
order by round(avg(r.review_score),2) asc;

select * from reviews;

-- Total 5-star reviews by customer state
select c.customer_state,count(r.review_score),r.review_score
from customer c inner join orders_1 o
on c.customer_id=o.customer_id inner join reviews r
on r.order_id=o.order_id
where r.review_score=5
group by c.customer_state,r.review_score
order by count(r.review_score) desc;

-- Average payment value by payment type
select round(avg(payment_value),2),payment_type
from payments
group by payment_type
order by round(avg(payment_value),2) asc;

-- Total 1-star reviews by product category
select p.product_category_name ,count(r.review_score),r.review_score
from products p inner join order_item oi
on p.product_id=oi.product_id inner join reviews r
on r.order_id=oi.order_id
where r.review_score=1
group by p.product_category_name,r.review_score
order by count(r.review_score) desc;

select * from sellers;

-- Total revenue by seller state
select s.seller_state,sum(pa.payment_value)
from sellers s inner join order_item oi
on s.seller_id=oi.seller_id inner join payments pa
on pa.order_id=oi.order_id
group by s.seller_state
order by sum(pa.payment_value) desc;

-- Average review score by customer state
select c.customer_state,round(avg(review_score),2)
from customer c inner join orders_1 o
on c.customer_id=o.customer_id inner join reviews r
on r.order_id=o.order_id
group by c.customer_state
order by round(avg(review_score),2) asc;

-- Total revenue by product category
select p.product_category_name ,sum(pa.payment_value)
from products p inner join order_item oi
on p.product_id=oi.product_id inner join payments pa
on pa.order_id=oi.order_id
group by p.product_category_name
order by sum(pa.payment_value) desc;

-- Total revenue by seller state (ascending)
select s.seller_state,sum(p.payment_value)
from sellers s inner join order_item oi
on s.seller_id=oi.seller_id inner join payments p
on p.order_id=oi.order_id
group by s.seller_state
order by sum(p.payment_value) asc;

-- Delivered orders by customer state
select c.customer_state,count(o.order_status),o.order_status
from customer c inner join orders_1 o
on c.customer_id=o.customer_id
where o.order_status='delivered'
group by c.customer_state,o.order_status
order by count(o.order_status) desc;

select * from order_item;

-- Average freight/shipping cost by product category
select p.product_category_name,round(avg(oi.freight_value),2)
from products p inner join order_item oi
on p.product_id=oi.product_id
group by p.product_category_name
order by round(avg(oi.freight_value),2) desc;

select * from orders_1;

-- Credit card orders count by customer state
select c.customer_state,count(o.order_id),p.payment_type
from customer c inner join orders_1 o
on c.customer_id=o.customer_id inner join payments p
on p.order_id=o.order_id
where p.payment_type='credit_card'
group by c.customer_state,p.payment_type
order by count(o.order_id) desc;

-- Total 5-star reviews by seller state
select s.seller_state,count(r.review_score),r.review_score
from sellers s inner join order_item oi
on s.seller_id=oi.seller_id inner join reviews r
on r.order_id=oi.order_id
where r.review_score=5
group by s.seller_state,r.review_score
order by count(r.review_score) desc;

-- Credit card revenue by product category
select p.product_category_name,sum(pa.payment_value),pa.payment_type
from products p inner join order_item oi
on p.product_id=oi.product_id inner join payments pa
on pa.order_id=oi.order_id
where pa.payment_type='credit_card'
group by p.product_category_name,pa.payment_type
order by sum(pa.payment_value) desc;

-- Delivered order revenue by customer state
select c.customer_state,sum(oi.price),o.order_status
from customer c inner join orders_1 o
on c.customer_id=o.customer_id inner join order_item oi
on o.order_id=oi.order_id
where o.order_status='delivered'
group by c.customer_state,o.order_status
order by sum(oi.price) desc;

-- Delivered order revenue by seller state
select s.seller_state,sum(oi.price),o.order_status
from sellers s inner join order_item oi
on s.seller_id=oi.seller_id inner join orders_1 o
on oi.order_id=o.order_id
where o.order_status='delivered'
group by s.seller_state,o.order_status
order by sum(oi.price) desc;

-- Cancelled order revenue by product category
select p.product_category_name,sum(oi.price),o.order_status
from products p inner join order_item oi
on p.product_id=oi.product_id inner join orders_1 o
on oi.order_id=o.order_id
where o.order_status='canceled'
group by p.product_category_name,o.order_status
order by sum(oi.price) desc;

-- Average credit card payment by customer state
select c.customer_state,round(avg(p.payment_value),2),p.payment_type
from customer c inner join orders_1 o
on c.customer_id=o.customer_id inner join payments p
on p.order_id=o.order_id
where p.payment_type='credit_card'
group by c.customer_state,p.payment_type
order by round(avg(p.payment_value),2) desc;

-- Average credit card payment by seller state
select s.seller_state,round(avg(p.payment_value),2),p.payment_type
from sellers s  inner join order_item oi
on s.seller_id=oi.seller_id inner join payments p
on p.order_id=oi.order_id
where p.payment_type='credit_card'
group by s.seller_state,p.payment_type
order by round(avg(p.payment_value),2) desc;


-- =====================================================================
-- SECTION 3: TOP-N ANALYSIS & RANKING (CTE + WINDOW FUNCTIONS)
-- =====================================================================

select * from customer;
select * from payments;

-- Top 5 customers by total payment value
with top_5 as
(
select c.customer_id ,sum(p.payment_value)
from customer c inner join orders_1 o
on c.customer_id=o.customer_id inner join payments p
on p.order_id=o.order_id
group by c.customer_id
order by sum(p.payment_value) desc
fetch first 5 rows only)
select * from top_5;

-- Top 3 seller states by revenue
with top_3_seller as
(
select s.seller_state,sum(oi.price)
from sellers s inner join order_item oi
on s.seller_id=oi.seller_id
group by s.seller_state
order by sum(oi.price) desc
fetch first 3 rows only)
select * from top_3_seller;

-- Top 5 product categories by average review score
with top_5_product as
(
select p.product_category_name,round(avg(r.review_score),2)
from products p inner join order_item oi
on p.product_id=oi.product_id inner join reviews r
on r.order_id=oi.order_id
group by p.product_category_name
order by round(avg(r.review_score),2) desc
fetch first 5 rows only)
select * from top_5_product;

-- Top 10 customer states by total payment value
with top_10_customer as
(
select c.customer_state,sum(p.payment_value)
from customer c inner join orders_1 o
on c.customer_id=o.customer_id inner join payments p
on p.order_id=o.order_id
group by c.customer_state
order by sum(p.payment_value) desc
fetch first 10 rows only)
select * from top_10_customer;

-- Top 5 seller states by average review score
with top_5_ss as
(
select s.seller_state,round(avg(r.review_score),2)
from sellers s inner join order_item oi
on s.seller_id=oi.seller_id inner join reviews r
on r.order_id=oi.order_id
group by s.seller_state
order by round(avg(r.review_score),2) desc
fetch first 5 rows only)
select * from top_5_ss;

-- Ranking sellers by total revenue
select
seller_id,
sum(price),
row_number () over (order by sum(price) desc) as rank_no
from order_item
group by seller_id;

-- Ranking seller states by total payment value
select
s.seller_state,
sum(p.payment_value),
row_number () over (order by sum(p.payment_value) desc) as rank_no
from sellers s inner join order_item oi
on s.seller_id=oi.seller_id inner join payments p
on oi.order_id=p.order_id
group by s.seller_state;

-- Ranking product categories by total revenue
select
p.product_category_name,
sum(oi.price),
row_number() over (order by sum(oi.price) desc ) as rank_no
from products p inner join order_item oi
on p.product_id=oi.product_id
group by p.product_category_name ;

-- Ranking seller states by average review score
select
s.seller_state,
round(avg(r.review_score),2),
row_number() over (order by round(avg(review_score),2) desc) as rank_no
from sellers s inner join order_item oi
on s.seller_id=oi.seller_id inner join reviews r
on r.order_id=oi.order_id
group by s.seller_state;

-- Ranking customer states by delivered order count
select
c.customer_state,
count(o.order_status),
row_number() over (order by count(o.order_status) desc) as rank_no
from customer c inner join orders_1 o
on c.customer_id=o.customer_id
where o.order_status='delivered'
group by c.customer_state;

-- Ranking product categories by average payment value
select
p.product_category_name,
round(avg(pa.payment_value),2),
row_number() over  (order by round(avg(pa.payment_value),2) desc) as rank_no
from products p inner join order_item oi
on p.product_id=oi.product_id inner join payments pa
on pa.order_id=oi.order_id
group by p.product_category_name;

-- Ranking seller states by order count
select
s.seller_state,
count(o.order_id),
row_number() over (order by count(o.order_id) desc) as rank_no
from sellers s inner join order_item oi
on s.seller_id=oi.seller_id inner join orders_1 o
on o.order_id=oi.order_id
group by s.seller_state;

-- Ranking customer states by average review score
select c.customer_state,
round(avg(r.review_score),2),
row_number() over (order by round(avg(r.review_score),2) desc) as rank_no
from customer c inner join orders_1 o
on c.customer_id=o.customer_id inner join reviews r
on r.order_id=o.order_id
group by c.customer_state;

-- Ranking product categories by order count
select
p.product_category_name,
count(o.order_status),
row_number() over (order by count(o.order_status) desc ) as rank_no
from products p inner join order_item oi
on p.product_id =oi.product_id inner join orders_1 o
on o.order_id=oi.order_id
group by p.product_category_name;

-- Ranking seller states by average payment value
select
s.seller_state,
round(avg(p.payment_value),2),
row_number() over (order by round(avg(p.payment_value),2) desc) as rank_no
from sellers s inner join order_item oi
on oi.seller_id=s.seller_id inner join payments p
on p.order_id=oi.order_id
group by s.seller_state;
