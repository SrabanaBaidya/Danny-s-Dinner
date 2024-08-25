/*How many days has each customer visited the restaurant?*/
  
SELECT customer_id, COUNT(DISTINCT order_date) AS visit_count
FROM sales
GROUP BY customer_id;

/*What was the first item from the menu purchased by each customer?*/
/*Assign Ranks to each menu*/
WITH ordered_sales AS (SELECT 
s.customer_id, 
s.order_date, 
m.product_name,
DENSE_RANK() OVER(
PARTITION BY s.customer_id 
ORDER BY s.order_date) AS RnK
FROM sales AS s
INNER JOIN menu AS m
ON s.product_id = m.product_id)

/*Fetch the Rank 1 menu from the assigned Ranks*/
SELECT customer_id, product_name
FROM ordered_sales
WHERE RnK = 1
GROUP BY customer_id, product_name;

/*What is the most purchased item on the menu and how many times was it purchased by all customers?*/
SELECT m.product_name AS Most_purchases_item, COUNT(s.order_date) AS number_purchased
FROM menu AS m INNER JOIN sales AS s
ON m.product_id=s.product_id
GROUP BY m.product_name
ORDER BY number_purchased DESC
LIMIT 1;

/*Which item was the most popular for each customer?*/


WITH most_popular AS (SELECT s.customer_id AS Customers,m.product_name AS Items, COUNT(m.product_id) AS order_count,
DENSE_RANK() OVER(PARTITION BY s.customer_id 
ORDER BY COUNT(s.product_id) DESC) AS RnK
FROM menu AS m
INNER JOIN sales AS s
ON m.product_id = s.product_id
GROUP BY s.customer_id, m.product_name)
SELECT Customers, Items, order_count
FROM most_popular 
WHERE RnK = 1;


/*Which item was purchased first by the customer after they became a member?*/


WITH membership_customers AS(
SELECT me.customer_id AS Customers,s.product_id,
ROW_NUMBER() OVER (PARTITION BY me.customer_id ORDER BY s.order_date) AS OrderRank
FROM members AS me INNER JOIN sales AS s
ON me.customer_id=s.customer_id
AND s.order_date>me.join_date)

SELECT Customers,product_name
FROM membership_customers AS mc
INNER JOIN menu AS m
ON mc.product_id=m.product_id
WHERE OrderRank=1
ORDER BY Customers ASC;

/*Which item was purchased just before the customer became a member?*/

WITH before_membership_customers AS(
SELECT me.customer_id AS Customers,s.product_id,
ROW_NUMBER() OVER (PARTITION BY me.customer_id ORDER BY s.order_date DESC) AS OrderRank
FROM members AS me INNER JOIN sales AS s
ON me.customer_id=s.customer_id
AND s.order_date<me.join_date)

SELECT Customers,product_name
FROM before_membership_customers AS mc
INNER JOIN menu AS m
ON mc.product_id=m.product_id
WHERE OrderRank=1
ORDER BY Customers ASC;

/*What is the total items and amount spent for each member before they became a member?*/

SELECT s.customer_id AS members,COUNT(s.product_id) AS items,SUM(m.price) AS amount_spent
FROM sales AS s INNER JOIN menu AS m 
ON m.product_id=s.product_id
INNER JOIN members AS me
ON me.customer_id=s.customer_id
WHERE s.order_date<me.join_date
GROUP BY members
ORDER BY members DESC;

 /*If each $1 spent equates to 10 points and sushi has a 2x points multiplier - 
 how many points would each customer have?*/
 
 /*USING CTE*/
WITH point_customers AS (SELECT s.customer_id AS customer_id,
SUM(CASE WHEN m.product_name = 'sushi' THEN (2 * m.price) ELSE m.price END) AS total_points
FROM sales AS s INNER JOIN menu AS m ON s.product_id = m.product_id
GROUP BY s.customer_id)
SELECT customer_id, total_points * 10 AS final_points
FROM point_customers;


SELECT s.customer_id,
SUM(CASE WHEN m.product_name = 'sushi' THEN (2 * m.price) ELSE m.price END) * 10 AS total_points
FROM sales AS s
INNER JOIN menu AS m ON s.product_id = m.product_id
GROUP BY s.customer_id;

/*In the first week after a customer joins the program (including their join date) they earn 2x points on all items,
 not just sushi - how many points do customer A and B have at the end of January?*/
 
 
WITH joined_customers AS (SELECT m.customer_id AS customer_id,m.join_date
FROM members AS m WHERE m.customer_id IN ('A', 'B')),
points_earned AS (SELECT s.customer_id,
SUM( CASE WHEN s.order_date <= DATE_ADD(jc.join_date, INTERVAL 7 DAY) THEN (2 * m.price)
ELSE m.price END) AS total_points
FROM sales AS s INNER JOIN menu AS m ON s.product_id = m.product_id
INNER JOIN joined_customers AS jc ON s.customer_id = jc.customer_id
WHERE s.order_date <= DATE_ADD(jc.join_date, INTERVAL 1 MONTH) -- End of January
GROUP BY s.customer_id)
SELECT jc.customer_id,COALESCE(pe.total_points, 0) AS points_at_end_of_january
FROM joined_customers AS jc
LEFT JOIN points_earned AS pe ON jc.customer_id = pe.customer_id;

/*Join All The Things
Recreate the table with: customer_id, order_date, product_name, price, member (Y/N)*/

SELECT sales.customer_id, sales.order_date,  menu.product_name, menu.price,
CASE WHEN members.join_date > sales.order_date THEN 'N'
     WHEN members.join_date <= sales.order_date THEN 'Y'
     ELSE 'N' END AS member_status
FROM dannys_diner.sales
LEFT JOIN dannys_diner.members
ON sales.customer_id = members.customer_id
INNER JOIN dannys_diner.menu
ON sales.product_id = menu.product_id
ORDER BY members.customer_id, sales.order_date;