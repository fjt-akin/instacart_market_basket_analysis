
CREATE DATABASE instacart;

-- create aisles schema
CREATE TABLE aisles (
	aisle_id INT PRIMARY KEY,
    aisle VARCHAR(50)
);
 
 -- create department schema
 CREATE TABLE departments (
	department_id INT PRIMARY KEY,
    department VARCHAR(50)
 );
  
 -- create orders schema 
 CREATE TABLE orders(
	order_id INT PRIMARY KEY,
    user_id INT ,
    eval_set VARCHAR(50),
    order_number INT,
    order_dow INT,
    order_hour_of_day INT,
    days_since_prior_order INT
 );
 
 -- create products schema
 CREATE TABLE products(
	product_id INT PRIMARY KEY,
    product_name VARCHAR(255),
    aisle_id INT,
    department_id INT,
    FOREIGN KEY(aisle_id) REFERENCES aisles(aisle_id),
    FOREIGN KEY(department_id) REFERENCES departments(department_id)
 );
 
 -- create order_products_prior
 CREATE TABLE order_products_prior(
	order_id INT,
    product_id INT,
    add_to_cart_order INT,
    reordered BIT,
    FOREIGN KEY(order_id) REFERENCES orders(order_id),
    FOREIGN KEY(product_id) REFERENCES products(product_id)
 );
 
  -- create order_products_train
CREATE TABLE order_products_train(
	order_id INT,
    product_id INT,
    add_to_cart_order INT,
    reordered BIT,
    FOREIGN KEY(order_id) REFERENCES orders(order_id),
    FOREIGN KEY(product_id) REFERENCES products(product_id)
 
-- DATA DICTIONARY
 
 --  Aisles schema

-- ●	aisle_id: Unique identifier for each aisle.
-- ●	aisle: Descriptive name of the aisle.

-- Departments schema

-- ●	department_id: Unique identifier for each department.
-- ●	department: Descriptive name of the department.

-- Order_products__prior schema

-- ●	order_id: Unique identifier for each individual order.
-- ●	product_id: Unique identifier for each product in the order.
-- ●	add_to_cart_order: Order in which the product was added to the cart.
-- ●	reordered: Binary flag indicating if the product was reordered (1 for reorder, 0 for first-time order).

-- Order_products__train schema

-- ●	order_id: Unique identifier for each individual order.
-- ●	product_id: Unique identifier for each product in the order.
-- ●	add_to_cart_order: Order in which the product was added to the cart.
-- ●	reordered: Binary flag indicating if the product was reordered (1 for reorder, 0 for first-time order).

-- Orders schema

-- ●	order_id: Unique identifier for each individual order.
-- ●	user_id: Unique identifier for each user/customer.
-- ●	eval_set: Indicates the evaluation set the order belongs to (prior, train, test).
-- ●	order_number: Sequence number of the order for a particular user.
-- ●	order_dow: Day of the week when the order was placed (0 = Sunday, 1 = Monday, etc.).
-- ●	order_hour_of_day: Hour of the day when the order was placed.
-- ●	days_since_prior_order: Number of days since the user's previous order (null for first orders).

-- Products schema

-- ●	product_id: Unique identifier for each product.
-- ●	product_name: Descriptive name of the product.
-- ●	aisle_id: Unique identifier for the aisle where the product is located.
-- ●	department_id: Unique identifier for the department to which the product belongs.

-- This data dictionary provides a detailed overview of each dataset and the purpose of each column within them. It's a valuable reference for understanding the structure and content of the data.
