use Vally_point

select * from sales_data;
select * from region;
select * from Customer_Data;
select * from Product_data;

---4 Data sets are there based on that trying to go insight to know how the business going on.

-- 1st will make a one table where every important aspect will be available based on 4 difenrent data set.

create table Sales_Table(

orderdate date,
Country Varchar (255),
City varchar (255),
[Product Name] varchar (255),
[Customer Names] varchar (255),
Quantity int,
[Unit Price] int,
[Total Unit Cost] int
);

 insert into Sales_Table( orderdate,Country,City,[Product Name],[Customer Names],Quantity,[Unit Price],[Total Unit Cost])
 select sales_data.orderdate, Region.Country, Region.City, Product_data.[Product Name], Customer_Data.[Customer Names], 
 Sales_Data.Quantity, Sales_data.[Unit Price],sales_data.[Total Unit Cost]

 From Sales_data join Product_data
 on Sales_data.[Product ID] = Product_data.[Product ID]
 join Customer_Data
 on Customer_Data.[Customer Index] = Sales_data.[Customer Name Index]
 Join Region
 on Region.[Index] = Sales_data.[Region ID];

 Select * from Sales_Table;

 --2nd Going to add column of Total_sales, Total_Cost,Total_Profit,Profit %

 Alter table Sales_Table
 Add  Total_Sales As (Quantity * [Unit Price]);

 Alter table Sales_Table
 Add Total_Cost As(Quantity * [Total Unit Cost]);

 Alter table Sales_Table
 Add  Total_Profit As (Quantity * [Unit Price])- (Quantity * [Total Unit Cost]);

 Select * from Sales_Table;

 alter table sales_table
 add profitp As concat ( Cast ( (( Quantity * [unit price]) - (quantity *[total unit cost]))/ (quantity * [unit price]) *
 100 as decimal (10,2)
 ), '%');
 

 --3rd going to get measure of totl_Sales, Total_Cost, Total_Profit, Profit_%.
 select sum(sales_data.Quantity * Sales_data.[Total Unit Cost]) As Total_Cost_M
 from Sales_data;

 Select ROUND(sum(sales_data.Quantity * Sales_data.[Unit Price]),2) As Total_Sales_M
 from Sales_data;

 select ROUND( Sum( Sales_Data.Quantity *  Sales_data.[Unit Price]) - Sum(Sales_data.Quantity * Sales_data.[Total Unit Cost]),2)
 As Total_Profit

 from Sales_data;

 -- -- Sales Based on Product
 select Product_data.[Product Name], sum(sales_data.Quantity * Sales_data.[Unit Price]) As Sales_On_Product
 from Product_data join Sales_data
 on Product_data.[Product ID] = Sales_data.[Product ID]

group by Product_data.[Product Name] order by Sales_On_Product desc;

--Sales based on product Name and region

select Region.Country, Product_data.[Product Name], SUM(sales_data.Quantity * Sales_data.[Unit Price]) As Sales_Country_Product

from Sales_data join Product_data
on Sales_data.[Product ID] = Product_data.[Product ID]
join Region
on Region.[Index] = Sales_data.[Customer Name Index]
group by Region.Country, Product_data.[Product Name]
order by Sales_Country_Product desc;

 --sales based on product & Customer names 
 select Product_data.[Product Name], Customer_Data.[Customer Names], sum(sales_data.Quantity * Sales_data.[Unit Price]) As 
 Sales_Customer_Product

 from Sales_data join Product_data
 on Sales_data.[Product ID] = Product_data.[Product ID]
 join Customer_Data
 on Sales_data.[Customer Name Index] = Customer_Data.[Customer Index]

 group by Product_data.[Product Name], Customer_Data.[Customer Names] order by Sales_Customer_Product desc;

 --Calculate the total revenue for all orders from 'Germany'.
 select Region.Country,  sum(sales_data.Quantity * Sales_data.[Unit Price]) As Sales_Germany
 from Sales_data join Region
 on Sales_data.[Region ID] = Region.[Index]

 group by Region.Country
 having Region.Country='Germany';

 --Calculate the total revenue for all orders from 'italy customer name.

 select Customer_Data.[Customer Names], Region.Country, sum(sales_data.Quantity * Sales_data.[Unit Price]) As Sales_Customer_Country

 from Sales_data join Customer_Data
 on Sales_data.[Customer Name Index] = Customer_Data.[Customer Index]
 join Region
 on Sales_data.[Region ID] = Region.[Index]

 where
 Region.Country = 'Italy'

 group by Customer_Data.[Customer Names], Region.Country ;
 

 --Get the customer_name and total_sales for the top 5 Total_Sales by each country
 select top 5  Customer_Data.[Customer Names], Region.Country, SUM(sales_data.Quantity * Sales_data.[Unit Price]) As Top_5_Sales_Cus_Country

 from Sales_data join Customer_Data

 on Sales_data.[Customer Name Index] = Customer_Data.[Customer Index]
 join Region
 on Sales_data.[Region ID] = Region.[Index]

 group by Customer_Data.[Customer Names], Region.Country order by Top_5_Sales_Cus_Country desc;

 --Retrieve the total sales and total quantity sold for each customer.

 SELECT 
    Customer_Data.[Customer Names],
    SUM(Sales_data.Quantity) AS Total_Quantity,
    SUM(Sales_data.Quantity * Sales_data.[Unit Price]) AS Total_Sales_and_Quantity
FROM 
 Sales_data 
JOIN 
    Customer_Data ON Sales_data.[Customer Name Index] = Customer_Data.[Customer Index]
GROUP BY 
    Customer_Data.[Customer Names];
-- List the customers who have made purchases totaling more than $20,000.
select Customer_Data.[Customer Names], SUM(sales_data.Quantity * Sales_data.[Unit Price]) As Sales_20000

  from Customer_Data join Sales_data
on Sales_data.[Customer Name Index] = Customer_Data.[Customer Index]
group by Customer_Data.[Customer Names]
having sum(sales_data.Quantity * Sales_data.[Unit Price]) > 20000;

--Find the average total sales per order for each country.
select Region.Country, AVG(Sales_data.Quantity * Sales_data.[Unit Price]) As Avg_Sales_Country

	from Region join Sales_data

on Region.[Index] = Sales_data.[Customer Name Index]

	group by Region.Country order by Avg_Sales_Country desc;

-- Total product ordered by customer

select Customer_Data.[Customer Names], sum(Sales_data.quantity) As Count_Order_By_Customer

    from Sales_data join Customer_Data
on Sales_data.[Customer Name Index] = Customer_Data.[Customer Index]

group by Customer_Data.[Customer Names];































