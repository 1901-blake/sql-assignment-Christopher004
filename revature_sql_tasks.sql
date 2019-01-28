--2.1
--task: Select all records from the Employee table.
SELECT * FROM employee;

--task: Select all records from the Employee table where last name is King.  
SELECT * FROM employee WHERE lastname = 'King';

--task: Select all records from the Employee table where first name is Andrew and REPORTSTO is NULL.
SELECT * FROM employee WHERE firstname = 'Andrew' and reportsto is null ;

--2.2
--task: Select all albums in Album table and sort result set in descending order by title.
SELECT * from album ORDER BY title desc;

--task: Select first name from Customer and sort result set in ascending order by city
SELECT firstname, city from Customer ORDER BY city;

--2.3
--task: Insert two new records into Genre table
insert into genre (genreid,name)
values ('26', 'Reggaeton');

insert into genre (genreid,name)
values ('27', 'Country');

--task: Insert two new records into Employee table
insert into employee (employeeid,lastname,firstname,title,reportsto,
birthdate,hiredate,address,city,state,country,postalcode,phone,fax,email)
values ('9', 'Roman','lucas','IT Staff','6','1970-10-28','2004-05-06 00:00:00',
'1111 6 Ave SW','Calgary','AB','Canada','T2P 5M5','+1 (403)280-5489','+1(403)280-5490','lucas@chinoocorp.com');

insert into employee (employeeid,lastname,firstname,title,reportsto,
birthdate,hiredate,address,city,state,country,postalcode,phone,fax,email)
values ('10', 'Gonzalez','David','IT Staff','7','1973-05-18','2004-07-15 00:00:00',
'7727B 41 Ave','Calgary','AB','Canada','T3B 1Y7','+1 (403)928-4502','+1(403)928-4502','david@chinoocorp.com');

--task: Insert two new records into Customer table
insert into customer (customerid,firstname,lastname,company,address,
city,state,country,postalcode,phone,fax,email,supportrepid)
values ('60', 'David','Izquierdo',NULL,'113 Lupus St','London',NULL,'United Kingdom',
'EH4 1HH','+44 2412 659 5945',NULL,'david@gmail.com','5');

insert into customer (customerid,firstname,lastname,company,address,
city,state,country,postalcode,phone,fax,email,supportrepid)
values ('61', 'Christopher','Gonzalez',NULL,'hc2 box 45454','Arecibo',NULL,
'Puerto Rico','00612','787 319 9190',NULL,'chris04@gmail.com','5');

--2.4
--task: Update Aaron Mitchell in Customer table to Robert Walter
Update customer
Set firstname = 'Robert',
lastname = 'Walter'
Where customerid = '32';

--task: Update name of artist in the Artist table “Creedence Clearwater Revival” to “CCR”
Update artist set name = 'CCR'
Where name = 'Creedence Clearwater Revival';

--2.5
--task: Select all invoices with a billing address like “T%”
select * from invoice where billingaddress like 'T%';

--2.6
--task: Select all invoices that have a total between 15 and 50
select * from invoice where invoiceid between 15 and 50;

--task: Select all employees hired between 1st of June 2003 and 1st of March 2004
select * from employee where hiredate between '2003-06-01' and '2004-03-01';

--2.7
--task: Delete a record in Customer table where the name is Robert Walter 
--(There may be constraints that rely on this, find out how to resolve them).
Delete from invoiceline 
where invoicelineid in (select a.invoicelineid
from invoiceline a 
inner join invoice b 
on a.invoiceid = b.invoiceid
Join customer c
on b.customerid=c.customerid
where c.firstname = 'Robert'
and c.lastname = 'Walter');

Delete from invoice 
where invoiceid in (select b.invoiceid
from invoice b 
inner join invoice c 
on b.invoiceid = c.invoiceid
Join customer d
on c.customerid=d.customerid
where d.firstname = 'Robert'
and d.lastname = 'Walter');

Delete from customer where firstname = 'Robert' and lastname = 'Walter';

--3.0

--3.1
--task: Create a function that returns the current time.

select current_time;

--task: create a function that returns the length of a mediatype from the mediatype table
select length(name) from mediatype;

--3.2 
--task: Create a function that returns the average total of all invoices
select avg(total) from invoice;

--task: Create a function that returns the most expensive track
select max(unitprice) from track;

--3.3
--task: Create a function that returns the average price of invoiceline items in the invoiceline table
CREATE OR REPLACE FUNCTION averageinvoiceline()
RETURNS float AS $average$
declare
	average float;
BEGIN
   SELECT avg(unitprice) into average FROM invoiceline;
   RETURN average;
END;
$average$ LANGUAGE plpgsql;
select averageinvoiceline();

--3.4
--task: Create a function that returns all employees who are born after 1968.
create function employees_birth() 
returns table(employeeid int, firstname varchar, lastname varchar, birthdate timestamp) 
    as $$ 
select employeeid, firstname, lastname, birthdate from employee where birthdate>='1968-01-01';
$$ language sql;

select * from employees_birth();

--4.0
--4.1
--task: Create a stored procedure that selects the first and last names of all the employees.
 create function getemployees() 
 returns TABLE(firstname varchar, lastname varchar) 
 as $$
 select firstname, lastname from employee 
 $$ language sql;

select * from getemployees()

--4.2
--task: Create a stored procedure that updates the personal information of an employee.
create function changinginfo(fname varchar, lname varchar, address varchar, city varchar,state varchar,
country varchar, postalcode varchar, phone int, fax int, email varchar) 
returns void as 
$$ update employee set firstname=$1, lastname=$2, address=$3, city=$4, state=$5, 
   country=$6, postalcode=$7, phone=$8, fax=$9, email=$10;
$$ language sql;

--task: Create a stored procedure that returns the managers of an employee.
 create function return_manager(empployeeid int)
 returns integer as $$ 
select reportsto from employee where employeeid=$1;
$$ language sql;

--4.3
--task: Create a stored procedure that returns the name and company of a customer.
create function name_and_company(customerid int) 
returns table(firstname varchar, lastname varchar, company varchar) as $$
select firstname, lastname, company from customer;
$$ language sql;

--5.0
--task: Create a transaction that given a invoiceId will delete that invoice 
--(There may be constraints that rely on this, find out how to resolve them).
begin
Delete from invoiceline 
where invoiceid = ''
Delete from invoice 
Where invoiceid = ''
    commit;

--task:Create a transaction nested within a stored procedure that inserts a new record in the Customer table
create or replace function insertintocustomer(id int, fname varchar, lname varchar, 
compa varchar, addr varchar, city varchar, state varchar, country varchar, 
postal int, phone int, fax int, email varchar, supprepid int) 
returns void as $$
begin
      insert into customer (customerid, firstname, lastname, 
      company, address, city, state, country, postalcode, phone, fax, email, supportrepid)
      
      values(id, fname, lname, compa, addr, city, state, country, postal, phone, fax, email, supprepid);
        end;
 $$ language plpgsql;


--6.0
--6.1
--task: Create an after insert trigger on the employee table fired after a new record is inserted into the table.
create trigger after_employee
after insert on album
for each row
execute procedure afterE();

--task: Create an after update trigger on the album table that fires after a row is inserted in the table
create trigger after_album
after update on album
for each row
execute procedure afterT();

--task: Create an after delete trigger on the customer table that fires after a row is deleted from the table.
create trigger delete_customer 
after delete on customer
for each row
execute procedure afterD();

--7.0
--7.1
--task: Create an inner join that joins customers and orders and specifies the name of the customer and the invoiceId.
select * from invoice a
inner join customer b
on a.customerid = b.customerid

--7.2
--task: Create an outer join that joins the customer and invoice table, 
--specifying the CustomerId, firstname, lastname, invoiceId, and total.
select b.customerid, b.firstname,  from invoice a
full outer join customer b
on a.customerid = b.customerid 

--7.3
--task: Create a right join that joins album and artist specifying artist name and title.
select b.name, a.title from album a
right join artist b
on a.artistid = b.artistid

--7.4
--task: Create a cross join that joins album and artist and sorts by artist name in ascending order.
select b.name, a.title from album a
cross join artist b
order by b.name;

--7.5
--task: Perform a self-join on the employee table, joining on the reportsto column.
Select *
From employee a
Inner join employee b
On a.reportsto = b.reportsto;
