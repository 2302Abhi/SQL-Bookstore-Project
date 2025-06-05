-- CREATING TABLES 
CREATE TABLE Books (
     Book_ID SERIAL PRIMARY KEY,
	 Title VARCHAR(100),
	 Author VARCHAR(100),
	 Genre VARCHAR(100),
	 Published_Year INT,
	 Price NUMERIC(10, 2),
	 Stock INT
);
CREATE TABLE Customers (
      Customer_ID SERIAL PRIMARY KEY,
	  Name VARCHAR(100),
	  Email VARCHAR(100),
	  Phone VARCHAR(15),
	  City VARCHAR(50),
	  Country VARCHAR(150)
);
CREATE TABLE Orders (
      Order_ID SERIAL PRIMARY KEY,
	  Cutomer_ID INT REFERENCES Customers(Customer_ID),
	  Book_ID INT REFERENCES Books(Book_ID),
	  Order_Date DATE,
	  Quantity INT,
	  Total_Amount NUMERIC(10,2)
);
-- Rename column name in table
Alter table Orders
Rename cutomer_id to Customer_id

-- IMPORTING DATA FROM CSV FILE USING COMMAND
-- this command is not run in Query tool so i have to write it on psql terminal

-- selecting all the table 
SELECT * FROM Books
SELECT * FROM customers
SELECT * FROM orders

-- NOW solving my question query
--1) Retrieve all books in the  "fiction" genre
SELECT * FROM books 
WHERE Genre='Fiction';

--2) Find books published after the year 1950;
SELECT * FROM books 
where Published_year>1950;

--3) List all customers from the Canada:
SELECT * FROM Customers
where country='Canada'
--4) Show orders placed in November 2023;
SELECT * FROM orders
where order_date BETWEEN  '2023-11-01' AND '2023-11-30';

--5) Retrives the total stock of books available:
SELECT SUM(stock) As Total_Stock
FROM books;

--6) FInd the details of the most expensive books;
SELECT * FROM books
Order BY price DESC 
LIMIT 1;

--7) Show all customers who ordered more then 1 quantity of a books:
SELECT * from  Orders 
where quantity>1;

--8) Retrieve all orders where the total amount exceeds $20;
SELECT * from  Orders 
where total_amount>20;

--9) List all genres available in the books table:
SELECT DISTINCT genre FROM books;

--10) Find the book with the lowest stock:
Select * from books
order by stock
limit 5;

--11) Calculate the total revenue generated from all orders:
SELECT SUM(total_amount) As total_revenue 
FROM orders

--Adavance Questions:

--1) Retrieve the total number of books sold for each genre:
SELECT * FROM ORDERS;

SELECT b.Genre, SUM(o.Quantity) AS Total_books_Sold
FROM Orders o
JOIN Books b ON o.book_id=b.book_id
GROUP BY b.Genre;

--2)Find the average price of books in the "Fantasy" genre:
SELECT AVG(price) AS average_price,genre 
FROM books WHERE genre='Fantasy'
GROUP BY Genre;

--3) List customers who have placed at least 2 orders:
SELECT c.Name, COUNT(Order_id) AS Order_count
FROM Orders o
JOIN customers c ON O.customer_id=c.customer_id
GROUP BY name
HAVING COUNT(Order_id)>=2;

--4) Find the most frequently ordered book:
SELECT Book_id, COUNT(order_id) AS ORDER_COUNT
FROM orders
GROUP BY Book_id
ORDER BY ORDER_COUNT DESC LIMIT 1;

--5) Show the top 3 most expensive book of 'Fantasy' Genre:
SELECT *
FROM books
WHERE genre='Fantasy'
ORDER BY price DESC LIMIT 3;

--6) Retrieve the total quantity of books sold by each author:
SELECT b.author,SUM(o.quantity) AS total_book_sold
FROM ORDERS o
JOIN books b ON o.book_id=b.book_id
GROUP BY b.author;

--7) List the citites where customers who spent over $30 are located:
SELECT DISTINCT c.city,o.total_amount
FROM orders o
JOIN customers c ON o.customer_id=c.customer_id
WHERE o.total_amount>=30;

--8) Find the customer who spent the most on orders:
SELECT c.name,SUM(o.total_amount) AS TOTAL_spent
FROM ORDERS o 
JOIN Customers c ON o.customer_id=c.customer_id
GROUP BY c.name
ORDER BY TOTAL_spent DESC LIMIT 1;

--9) Calculate the stock remaining after fulfilling all orders:
SELECT b.book_id, b.title, b.stock,COALESCE(SUM(o.quantity),0) AS Order_quantity,
    b.stock-COALESCE(SUM(o.quantity),0) AS Remainin_quantity
FROM books b
LEFT JOIN orders o ON b.book_id =o.book_id
GROUP BY b.book_id;
