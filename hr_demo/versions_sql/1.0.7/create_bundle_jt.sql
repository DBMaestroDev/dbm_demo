-- USE Northwind-DEV
-- Build bundles join table
CREATE TABLE PRODUCTS_BUNDLES (
id INT,
bundle_id int,
product_id int,
PRIMARY KEY(id)
);