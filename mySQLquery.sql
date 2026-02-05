CREATE DATABASE BOOK_STORE;

USE BOOK_STORE;

CREATE TABLE Authors (
author_id INT PRIMARY KEY,
name VARCHAR(200),
country VARCHAR(100)
);

CREATE TABLE Books (
book_id INT PRIMARY KEY,
title VARCHAR(200),
genre VARCHAR(100),
price DECIMAL(10,2),
author_id INT,
CONSTRAINT FK_Authors FOREIGN KEY(author_id) REFERENCES Authors(author_ID)
);

CREATE TABLE Customers (
customer_id INT PRIMARY KEY,
name VARCHAR(200),
email VARCHAR(200)
);

CREATE TABLE Orders (
order_id INT PRIMARY KEY,
customer_id INT,
order_date DATE, 
CONSTRAINT FK_Customers FOREIGN KEY(customer_id) REFERENCES Customers(customer_id)
);

CREATE TABLE Order_Details (
order_detail_id INT PRIMARY KEY,
order_id INT,
book_id INT,
quantity INT, 
CONSTRAINT FK_Orders FOREIGN KEY(order_id) REFERENCES Orders(order_id),
CONSTRAINT FK_Books FOREIGN KEY(book_id) REFERENCES Books(book_id)
);



INSERT INTO Authors
VALUES
(1, 'J.K. Rowling', 'UK'),
(2, 'George R.R. Martin', 'USA'),
(3, 'Haruki Murakami', 'Japan');

INSERT INTO Books
VALUES
(1, 'Harry Potter', 'Fantasy', 20.99, 1),
(2, 'Game of Thrones', 'Fantasy', 25.99, 2),
(3, 'Norwegian Wood', 'Fiction', 15.49, 3);

INSERT INTO Customers
VALUES
(1, 'Alice', 'alice@gmail.com'),
(2, 'Bob', 'bob@yahoo.com'),
(3, 'Charlie', 'charlie@hotmail.com');

INSERT INTO Orders 
VALUES 
(1, 1, '2023-12-01'), 
(2, 2, '2023-12-02');

INSERT INTO Order_Details 
VALUES 
(1, 1, 1, 2), 
(2, 2, 2, 1), 
(3, 2, 3, 1);



SELECT OD.order_detail_id, OD.order_id, OD.quantity, O.customer_id, C.name, OD.book_id, B.title 
FROM Order_Details AS OD 
JOIN Orders AS O ON OD.order_id = O.order_id 
JOIN Customers AS C ON C.customer_id = O.customer_ID 
JOIN Books AS B ON B.book_id = OD.book_id;

SELECT A.author_id, A.name, (OD.quantity * B.price) AS 'Total Revenue' 
FROM Order_Details AS OD 
JOIN Books AS B ON B.book_id = OD.book_id 
JOIN Authors AS A ON A.author_id = B.author_id;



SELECT B.author_id, A.name, B.title, B.price
FROM Books AS B
JOIN Authors AS A ON A.author_id = B.author_id
WHERE B.price = (SELECT MAX(price) FROM Books);

SELECT C.customer_id, C.name, COUNT(B.genre) AS Distinct_Genre_Ordered
FROM Order_Details AS OD
JOIN Orders AS O ON O.order_id = OD.order_id
JOIN Books AS B ON OD.book_id = B.book_id
JOIN Customers AS C ON C.customer_id = O.customer_id
GROUP BY C.customer_id, C.name
HAVING Distinct_Genre_Ordered > 1;