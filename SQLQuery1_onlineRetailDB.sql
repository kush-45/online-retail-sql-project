/*
We'll develop a project for a "Fictional Online Retail Company". 
This project will cover creating a database, tables, and indexes, inserting data,
and writing various queries for reporting and data analysis.
==================================================================================

Project Overview: Fictional Online Retail Company
--------------------------------------
A.	Database Design
	-- Database Name: OnlineRetailDB

B.	Tables:
	-- Customers: Stores customer details.
	-- Products: Stores product details.
	-- Orders: Stores order details.
	-- OrderItems: Stores details of each item in an order.
	-- Categories: Stores product categories.

C.	Insert Sample Data:
	-- Populate each table with sample data.

D. Write Queries:
	-- Retrieve data (e.g., customer orders, popular products).
	-- Perform aggregations (e.g., total sales, average order value).
	-- Join tables for comprehensive reports.
	-- Use subqueries and common table expressions (CTEs).
*/

-- using OnlineRetailDB database
USE OnlineRetailDB;

-- create Customers table 
create table Customers
(
CustomerID int primary key,
FirstName varchar(50),
LastName varchar(50),
Email varchar(50),
Phone varchar(50),
Address varchar(50),
City varchar(50),
State varchar(50),
Zipcode varchar(50),
Country varchar(50),
CreatedAT Datetime Default GETDATE()
);

-- create Product table
create table Products
(
ProductID int primary key,
ProductName varchar(50),
CategoryID int,
Price int,
Stock varchar(50),
CreatedAT Datetime Default GETDATE()
);
--changing the datatype
ALTER TABLE Products
ALTER COLUMN Price DECIMAL(10, 2);


-- create table categories
create table Categories
(
CategoryID int primary key,
CategoryName varchar(50),
Description varchar(50)
);

-- create table Orders
create table Orders
(
OrderID int primary key,
CustomerID int,
OrderDate Datetime Default GETDATE(),
TotalAmount decimal(10,2),
FOREIGn KEY (CustomerID) references Customers(CustomerID)
);
-- changing the datatype
ALTER TABLE Orders
ALTER  column TotalAmount DECIMAL(10, 2);


-- cretae table OrderItems
create table OrderItems
(
OrderItemID int primary key,
OrderID int,
ProductID int,
Quantity int,
FOREIGN KEY (ProductID) references Products(ProductID),
FOREIGN KEY (OrderID) references Orders(OrderID)
);
-- Adding a column
ALTER TABLE OrderItems
ADD Price DECIMAL(10, 2);
 select * from OrderItems;

-- insert values into Categories table
insert into Categories(CategoryID,CategoryName,Description) 
values
(1,'Electronic','Device and Gadgets'),
(2,'Clothing','Appareal and Accessories'),
(3,'Books','Printed and Electronic Book');


-- inserting the value in prodyuct table
insert into Products(ProductID,ProductName,CategoryID,Price,Stock)
values
(1,'Smartphone',1,699.99,50),
(2,'Laptop',1,999.99,30),
(3,'T-Shirt',2,19.99,100),
(4,'Jeans',2,49.99,60),
(5,'Fiction Movie',3,14.99,200),
(6,'Science Journal0',3,29.99,150);

-- inserting the values in Customer table 
insert into Customers(CustomerID,FirstName,LastName,Email,Phone,Address,City,State,Zipcode,Country)
values
(1,'Sameer','Khanna','sameerkhanns@example.com','123-456-7890','123 Elm st.','Springfield','IL',62701,'USA'),
(2,'Jane','Smith','janesmith@example.com','234-567-8901','456 oak st.','Madison','WI',53703,'USA'),
(3,'Harshad','Patel','harshadpatel@example.com','345-678-9012','789 dalal st.','Mumbai','MAharashatra',41520,'INDIA');

-- inserting the values in Order table
insert into Orders(OrderID,CustomerID,OrderDate,TotalAmount)
values
(1,1,GetDate(),719.98),
(2,2,GetDate(),49.99),
(3,3,GetDAte(),44.98);

-- Inserting the value in ordersItem table
insert into OrderItems(OrderITemID,OrderID,ProductID,Quantity,Price)
values
(1,1,1,1,699.99),
(2,1,3,1,19.99),
(3,2,4,1,49.99),
insert into OrderItems(OrderITemID,OrderID,ProductID,Quantity,Price)
values
(4,3,5,1,14.99),
(5,3,6,1,29.99);

-- Query-1  Retrive all order for a particular customer
select o.OrderID,o.OrderDate,o.TotalAmount,oi.ProductID,p.ProductName,oi.Quantity,oi.Price,c.FirstName
from Orders o
join OrderItems oi on o.orderID=oi.OrderID
join Products p on p.ProductID=oi.ProductID
join Customers c on c.CustomerID=o.OrderID
where o.CustomerID=1


-- Query-2  Find total sales of each product
select p.ProductID,p.ProductName,sum(oi.Quantity*p.Price) as TotalSales
from OrderItems oi
join Products p on p.ProductID=oi.ProductID
group by p.ProductID,p.ProductName
order by TotalSales desc;

--Query-3 calculate the average order value
select avg(TotalAmount) as AverageOrderValue from orders;

--Query-4 list the top 5 customer by total spending
select TOP 5 c.CustomerID,c.FirstName,c.LastName,c.Country,sum(o.TotalAmount) as TotalSpent
from Customers c
join Orders o on o.CustomerID=c.CustomerID
group by c.CustomerId,c.Firstname,c.LastName,c.Country
order by TotalSpent desc;

--Query-5 Retrive the most popular product category
select top 1 c.CategoryID,c.CategoryName,sum(oi.Quantity) as TotalQuantitySold
from OrderItems oi
join Products p on p.ProductID=oi.ProductID
join Categories c on c.CategoryID=p.CategoryID
group by c.CategoryID,c.CategoryName
order by TotalQuantitySold desc;


-- insert a value in Product table 
insert into Products(ProductID,ProductName,CategoryID,Price,Stock)
values
(7,'Keyboard',1,39.99,0);

-- Query-6 List all the product that are out of stock
select * from Products where Stock=0;


--Query-7 Find  customer who placed order in last 30 days
select c.CustomerID,c.FirstName,c.LastName,c.Country,o.OrderDate
from Customers c
join Orders o on o.CustomerID=c.CustomerID
where o.OrderDate >= DATEADD(DAY, -30, GETDATE());


--Query-8 Calculate the total number of orders placed each month
SELECT 
    COUNT(OrderID) AS TotalOrders,
    YEAR(OrderDate) AS OrderYear,
    MONTH(OrderDate) AS OrderMonth
FROM Orders
GROUP BY 
    YEAR(OrderDate), 
    MONTH(OrderDate);

-- Query-9 Retrive the detail from the most recent order
select top 1 o.OrderID,o.OrderDate,c.FirstName,c.LastName,c.Email,c.Phone,c.Address,c.City,c.State,c.Zipcode,c.Country,o.TotalAmount
from Orders o
join Customers c on o.CustomerID=c.CustomerID
order by OrderDate desc;


--Query-10 Find the average price of product in each category
select c.CategoryID,avg(p.price)as AveragePrice,c.categoryName
from Categories c 
join Products p
on c.CategoryID=p.CategoryID
group by c.CategoryID,c.CategoryName


--Query-11 List Customer who have never placed an order
select c.CustomerID,c.FirstName,o.OrderID
from Orders o
join Customers c
on c.CustomerID=o.CustomerID
where o.OrderID is null;


--Query 12 Retrive Total Quantity sold for each Product
select p.ProductID,p.ProductName,sum(o.Quantity) as TotalQuantity
from Products p
join OrderItems o
on p.ProductID=o.ProductID
group by p.ProductID,p.ProductName;


--Query-13 Calculate total Revenue generated for each category
select c.CategoryID,c.CategoryName,sum(oi.Price*oi.Quantity) as TotalRevenue
from Categories c 
join Products p
on c.CategoryID=p.CategoryID
join OrderItems oi
on oi.ProductID=p.ProductID
group by c.CategoryId,c.CategoryName;


--Query-14 Find the highest-priced Product in each category
select c.CategoryName,max(p.Price) as TotalPrice
from Categories c
join Products p
on p.CategoryID=c.CategoryID
group by CategoryName
order by TotalPrice desc;

--Query-15 Retrive order with a total amount greater than a specific value (e.g:-$500)
select OrderID,TotalAmount
from Orders 
where TotalAmount>500;

--Query-16 List Product along with the number of order they appear in
select p.ProductName,count(o.OrderID) as NumberofOrder
from Products p
join OrderITems oi 
on oi.ProductID=p.ProductID
join Orders o
on o.OrderID=oi.OrderID
group by ProductName;

--Query-17 Find the Top3 Most Frequently Ordered PRoducts
select top 3 count(oi.OrderID) as OrderCount,p.ProductName 
from OrderItems oi
join Products p
on p.ProductID=oi.ProductID
group by ProductName
order by OrderCount desc;

-- Query-18 Calculate total Number of Customers from each country
select count(CustomerID) as NumberOfCustomer ,Country
from Customers
group by Country
order by NumberOfCustomer desc;

-- Query-19 Retrive the list OF customer along with their total spending
select c.CustomerID,c.FirstName,c.Country,sum(o.TotalAmount) as TotalSpending
from Customers c
join Orders o
on o.CustomerID=c.CustomerID
group by c.CustomerID,c.FirstName,c.Country
order by TotalSpending desc;

-- Query-20 List Order with more than a specified number of items(e.g. -5)
SELECT 
    OrderID,
    SUM(Quantity) AS TotalItems
FROM OrderItems
GROUP BY OrderID
HAVING SUM(Quantity) >=2;
