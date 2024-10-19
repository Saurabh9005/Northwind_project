select * from information_schema.statistics where table_schema='northwind';
show tables;
#1.Calculate average Unit Price for each CustomerId.
select * from customers;
select * from order_details;
select * from orders;

# using group by clause
select o.customerid,o.employeeid,avg(od.unitprice) from orders o 
inner join order_details od on o.orderid=od.orderid group by o.customerid order by customerid;

# using window function
select o.CustomerID,od.unitprice,avg(od.unitprice) over(partition by customerid) as avg_unit_price 
from orders o
inner join order_details od on od.orderid=o.orderid;

select customerid,unitprice,avg(unitprice) over(partition by customerid) as avrg_unit_price from vwinvoice;


#2.Calculate average Unit Price for each group of CustomerId AND EmployeeId.

select * from employees;
select * from orders;
select * from order_details;
#using group by clause
select e.employeeid,o.orderid,o.customerid,avg(od.unitprice) as avrg_unit_price 
from employees e inner join orders o on o.employeeid=e.employeeid
inner join order_details od on od.orderid=o.orderid group by o.CustomerID order by e.EmployeeID;
#Using window function
select o.CustomerID,e.EmployeeID,od.unitprice,avg(od.unitprice) over(partition by customerid order by employeeid )
as avg_unit_price from employees e 
inner join orders o on o.employeeid=e.employeeid
inner join order_details od on od.orderid=o.orderid;

#3.Rank Unit Price in descending order for each CustomerId.
select customerid,unitprice,rank() over(partition by customerid order by unitprice desc) as ranks from vwinvoice;

select o.customerid,od.unitprice,rank() over(partition by customerid order by unitprice desc) as ranks from orders o
inner join order_details od on o.orderid=od.orderid;

#4.How can you pull the previous order date’s Quantity for each ProductId.
select customerid,orderdate,quantity,productid,lag(quantity) over(partition by ProductID order by orderdate) 
as previous_orderdate_quantity from orders o
inner join order_details od on o.orderid=od.orderid;


#5.How can you pull the following order date’s Quantity for each ProductId.

select customerid,orderdate,quantity,productid,lead(quantity) over(partition by ProductID order by orderdate) 
as previous_orderdate_quantity from orders o
inner join order_details od on o.orderid=od.orderid;

#6.Pull out the very first Quantity ever ordered for each ProductId.
select customerid,orderdate,quantity,productid,FIRST_VALUE(quantity) over(partition by ProductID order by orderdate) 
as first_ordered_quantity from orders o
inner join order_details od on o.orderid=od.orderid;

#7.Calculate a cumulative moving average UnitPrice for each CustomerId.


select CustomerID,unitprice,quantity,orderdate,avg(unitprice) over(partition by customerid order by orderdate) 
as moving_average_unitprice
from orders o inner join order_details od on o.orderid=od.orderid;


##Theoretical questions:


#1.Can you define a trigger that is invoked automatically before a new row is inserted into a table?

#Trigger:
-- A trigger is a stored procedure in database which automatically invokes
-- whenever a special event in the database occurs. For example, a trigger can be invoked when a row is 
-- inserted into a specified table or when certain table columns are being updated.

select * from order_details;
drop trigger if exists insert_trigger;
delimiter //
create trigger insert_trigger before insert on order_details
for each row begin
if new.discount<=0 then
signal sqlstate '50001' set message_text='discount should be greater than 0';
end if ; end //
delimiter ; 

insert into order_details  values (21015,12454,124,2546,48,0);



#2.What are the different types of triggers?
-- Trigger: A trigger is a stored procedure in database which automatically invokes
-- whenever a special event in the database occurs. 

-- There are 6 different types of triggers in MySQL:
         #update trigger
#1. Before Update Trigger:
-- It is a trigger which enacts before an update is invoked. 
-- If we write an update statement, then the actions of the trigger will be performed before the update is implemented.

#2. After Update Trigger:
-- this trigger is invoked after an updation occurs
-- i.e., it gets implemented after an update statement is executed.
        # insert trigger
#3. Before Insert Trigger:
-- this trigger is invoked before an insert, or before an insert statement is executed.

#4. After Insert Trigger:
-- this trigger gets invoked after an insert is implemented.
        
        #delete trigger
#5. Before Delete Trigger:
-- this trigger is invoked before a delete occurs, or before deletion statement is implemented.

#6. After Delete Trigger:
-- this trigger is invoked after a delete occurs, or after a delete operation is implemented.

##3.How is Metadata expressed and structured?

-- Metadata: Metadata in simple words describe as data about data.
-- In relational databases metadata is said to be consisting the information regarding the schema, storage, etc.,
-- Metadata in databases for schema consists of information regarding tables, columns, constraints,
-- foreign keys, indexes, and sequences. It also consists of information regarding the views,
-- procedures, functions, and triggers. Access to this metadata is provided in the form of a set of tables
-- or views called system catalog or data dictionary.

#syntax: example
select * from information_schema.statistics 
where table_schema='northwind';

-- MySQL stores metadata in a Unicode character set, namely UTF-8.

-- The basic building block of structural metadata is a model that describes its data entities, their characteristics, 
-- and how they are related to one another.

#4.Explain RDS and AWS key management services.

-- Amazon RDS is a Relational Database Cloud Service
-- Amazon RDS minimizes relational database management by automation
-- Amazon RDS creates multiple instances for high availability and failovers
-- Amazon RDS supports PostgreSQL, MySQL, Maria DB, Oracle, SQL Server, and Amazon Aurora---

-- AWS Key Management Service gives you centralized control over the cryptographic keys used to
-- protect your data. The service is integrated with other AWS services making it easier to encrypt 
-- data you store in these services and control access to the keys that decrypt it. 

#5.What is the difference between amazon EC2 and RDS?


#Performance	
-- While setting up the instance, the option to configure it with the specific number of IOPS is managed by us.
-- Though this provisioning of IOPS is costly, it allows us to have fast and consistent Input and Output Performance.
-- In the EC2, we have to pick up the storage volume with the right size in order to get the latency and IOPS we need. 
#Scalability	
-- RDS integrates with Amazon’s scaling tools for both horizontal and vertical scaling. If we need to scale 
-- vertically to a larger or more powerful instance, it can be done within a few clicks.
-- In EC2, we have to set up the scalable architecture manually. This process involves setting up the multiple
-- EC2 instances, load balancing them, configuring Availability Groups, etc. 
#Storage	
-- General-purpose SSD: Being a cost-effective option to choose, the SSD volumes can handle up to 3000 IOPS.
-- Provisioned IOPS: It is a good option for a database with heavy workloads which need high IOPS throughputs
 -- for a longer duration.
-- Magnetic: Takes care of magnetic storage	
-- IOPS and the latency we get depends on the EC2 instance type. 
#Security	
-- RDS provides encryption at both rest and transit.	
-- In EC2, the encryption will be at the EBS volume level and can be configured at the database level too. 
#Licensing	
-- Amazon RDS supports only the “License Included” model for licensing for SQL Server.
-- in EC2, Development charts can be viewed by users in GitLab. 
#Cost	
-- RDS is Mostly expensive.
-- Installing and managing a database in EC2 is cheaper than in the RDS but it leaves the handling of backup, 
-- recovery, and load management to us. 
#Backups	
-- in RDSThe backups can be automated. AWS Cloudwatch can receive alerts with backup failures and completion and so on.	
-- in EC2, The backups must be enabled by us here. AWS Cloudwatch cannot be used here for monitoring. 
