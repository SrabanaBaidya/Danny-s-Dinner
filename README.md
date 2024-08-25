# 🍣 Danny's Diner: An SQL Case Study

Welcome to my solutions for the **Danny's Diner** case study, part of the **8 Week SQL Challenge** by [Danny Ma](https://www.linkedin.com/in/datawithdanny/). This case study explores customer dining behaviors to draw insights for enhancing the dining experience and improving customer retention.

## 🛠️ Business Task

Danny's Diner wants to leverage its sales data to gain insights into customer preferences, dining frequency, and menu performance. The goal is to use these insights to improve menu offerings, enhance the customer experience, and optimize the loyalty program.

## 🔐 Entity Relationship Diagram

The Entity Relationship Diagram (ERD) below illustrates the relationships between the key tables used in this case study:

![Entity Relationship Diagram](er.PNG)

1. **Sales**: Contains customer-level purchase data including `customer_id`, `order_date`, and `product_id`.
2. **Menu**: Lists each `product_id` with its corresponding `product_name` and `price`.
3. **Members**: Tracks customer membership details including `customer_id` and `join_date`.

## ❓ Case Study Questions

Each of the following case study questions can be answered using a single SQL statement:

1. **Total Spending**: What is the total amount each customer spent at the restaurant?
2. **Visit Frequency**: How many days has each customer visited the restaurant?
3. **First Purchase**: What was the first item from the menu purchased by each customer?
4. **Menu Popularity**: What is the most purchased item on the menu and how many times was it purchased by all customers?
5. **Customer Preferences**: Which item was the most popular for each customer?
6. **Post-Membership Purchases**: Which item was purchased first by the customer after they became a member?
7. **Pre-Membership Purchases**: Which item was purchased just before the customer became a member?
8. **Member Spending Analysis**: What is the total number of items and amount spent for each member before they became a member?
9. **Points Calculation**: If each $1 spent equates to 10 points and sushi has a 2x points multiplier, how many points would each customer have?
10. **First Week Double Points**: In the first week after a customer joins the program (including their join date), they earn 2x points on all items, not just sushi. How many points do customer A and B have at the end of January?

### Bonus Questions

- **Join All The Things**: Create a comprehensive table that Danny and his team can use to quickly derive insights without needing to join the underlying tables using SQL.

## 📝 Solution

All solutions for the case study questions are provided in the `Solution Script.sql` file. Each question is addressed using SQL queries that analyze the provided datasets.


## 📚 Resources

- **8 Week SQL Challenge**: [8 Week SQL Challenge](https://www.datawithdanny.com/)
- **LinkedIn Profile - Danny Ma**: [Danny Ma](https://www.linkedin.com/in/datawithdanny/)
