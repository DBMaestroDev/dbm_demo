-- USE Northwind-DEV
-- Build bundles table
CREATE TABLE BUNDLES (
id INT,
bundle_name varchar(80),
expires_at datetime,
discount_code varchar(30),
PRIMARY KEY(id)
);