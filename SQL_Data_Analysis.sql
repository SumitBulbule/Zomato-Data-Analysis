
drop table if exists goldusers_signup;
CREATE TABLE goldusers_signup(userid integer,gold_signup_date date); 

INSERT INTO goldusers_signup(userid,gold_signup_date) 
 VALUES (1,'09-22-2017'),
(3,'04-21-2017');

drop table if exists users;
CREATE TABLE users(userid integer,signup_date date); 

INSERT INTO users(userid,signup_date) 
 VALUES (1,'09-02-2014'),
(2,'01-15-2015'),
(3,'04-11-2014');

drop table if exists sales;
CREATE TABLE sales(userid integer,created_date date,product_id integer); 

INSERT INTO sales(userid,created_date,product_id) 
 VALUES (1,'04-19-2017',2),
(3,'12-18-2019',1),
(2,'07-20-2020',3),
(1,'10-23-2019',2),
(1,'03-19-2018',3),
(3,'12-20-2016',2),
(1,'11-09-2016',1),
(1,'05-20-2016',3),
(2,'09-24-2017',1),
(1,'03-11-2017',2),
(1,'03-11-2016',1),
(3,'11-10-2016',1),
(3,'12-07-2017',2),
(3,'12-15-2016',2),
(2,'11-08-2017',2),
(2,'09-10-2018',3);


drop table if exists product;
CREATE TABLE product(product_id integer,product_name text,price integer); 

INSERT INTO product(product_id,product_name,price) 
 VALUES
(1,'p1',980),
(2,'p2',870),
(3,'p3',330);


select * from sales;
select * from product;
select * from goldusers_signup;
select * from users;

---Que. What is the total amount each customer spends on zomato

select a.userid, sum(b.price) tota_amt_spent from sales a
inner join product b on a.product_id=b.product_id
group by a.userid

---Que. How many days each customer visited zomato

select userid, COUNT(distinct created_date) number from sales
group by userid

---Que. What was the first product purchased by each customer

select *,RANK() over(partition by userid  order by created_date) rnk from sales

select * from
(select *,RANK() over(partition by userid  order by created_date) rnk from sales) a where rnk = 1

---que. What is Most purchased item and how many times it was purchased by all customers

select product_id,count(product_id) Purchases from sales
group by product_id
order by count(product_id) desc

--- Que. Which item was the most popular for each customer

select userid,product_id,count(product_id) count_order from sales
group by userid, product_id

select *,rank() over (partition by userid order by count_order desc) rnk from
 (select userid,product_id,count(product_id) count_order from sales group by userid, product_id) a

 --- Que. 1st purchase of each customer after they become a member

 select * from 
 (select c.*,rank () over (partition by userid order by created_date) rnk from
 (select a.userid,a.created_date,a.product_id,b.gold_signup_date from sales a
 inner join goldusers_signup b
 on a.userid = b.userid
 where created_date >= gold_signup_date) c) d
 where rnk = 1

 --- Que. Which item was purchased just before the customer become a member

 select * from 
 (select c.*,rank () over (partition by userid order by created_date desc) rnk from
 (select a.userid,a.created_date,a.product_id,b.gold_signup_date from sales a
 inner join goldusers_signup b
 on a.userid = b.userid
 where created_date <= gold_signup_date) c) d
 where rnk = 1

 --- que. What is the total orders and amount spent for each member before they become a member

 select userid, count(created_date),sum(price) total_amt_spent from
 (select c.*, d.price from
 (select a.userid,a.created_date,a.product_id,b.gold_signup_date from sales a
 inner join goldusers_signup b
 on a.userid = b.userid
 where created_date <= gold_signup_date) c
 inner join product d
 on c.product_id = d.product_id) e
 group by userid

 --- Que. Rank all the transactions of customers

 select *,rank() over (partition by userid order by created_date) Rnk from sales










