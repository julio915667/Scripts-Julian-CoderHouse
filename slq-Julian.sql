CREATE SCHEMA MayoristaElectroBazar;
USE MayoristaElectroBazar;

CREATE TABLE Clients (
    client_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(30),
    user_name VARCHAR(30),
    email VARCHAR(30),
    pass_word VARCHAR(30)
);

CREATE TABLE PRODUCTS (
    product_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    product_name VARCHAR(30),
    stock INT(30),
    price INT(30),
    image VARCHAR(40)
);

CREATE TABLE ORDERS (
    order_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    client_id INT,
    product_name VARCHAR(30),
     product_id INT,
    quantity INT(30),
    total INT(30),
    address VARCHAR(30),
    FOREIGN KEY (client_id) REFERENCES Clients(client_id), 
    FOREIGN KEY (product_id) REFERENCES PRODUCTS(product_id)
);

USE MayoristaElectroBazar;
-- Insertando datos en la tabla de Clients
INSERT INTO Clients (first_name, user_name, email, pass_word)
VALUES ('John', 'john_user', 'john@example.com', 'password123'),
       ('Jane', 'jane_user', 'jane@example.com', 'secret456'),
       ('Mike', 'mike_user', 'mike@example.com', 'secure789');
SELECT * FROM Clients;

-- Insertando datos en la tabla de PRODUCTS
INSERT INTO PRODUCTS (product_name, stock, price, image)
VALUES ('Smartphone', 100, 500, 'smartphone.jpg'),
       ('Laptop', 50, 1000, 'laptop.jpg'),
       ('TV', 30, 800, 'tv.jpg'), 
       ('PC GAMER', 10, 1800, 'pcgamer.jpg'),
       ('Teclado Gamer', 0, 50, 'tecladogamer.jpg');
      
INSERT INTO PRODUCTS (product_name, stock, price, image)
VALUES ('IPHONE 14 pro', 10, 500, 'iphone.jpg'),
       ('Laptop I9 8 RAM', 5, 12000, 'laptop.jpg');
       
       SELECT * FROM PRODUCTS;

USE MayoristaElectroBazar;

-- Inserciones en la tabla Clients
INSERT INTO Clients (first_name, user_name, email, pass_word)
VALUES ('Alice', 'alice_user', 'alice@example.com', 'password123'),
       ('Bob', 'bob_user', 'bob@example.com', 'secret456');

-- Inserciones en la tabla PRODUCTS
INSERT INTO PRODUCTS (product_name, stock, price, image)
VALUES ('Monitor', 20, 200, 'monitor.jpg'),
       ('Impresora', 15, 150, 'printer.jpg');

-- Inserciones en la tabla ORDERS
-- Aquí asumimos que los valores de client_id y product_id existen en las tablas relacionadas
INSERT INTO ORDERS (client_id, product_id, quantity, total, address)
VALUES (1, 1, 2, 400, '123 Main St'),
       (2, 2, 3, 450, '456 Elm St');

-- Inserciones en la tabla ORDERS para el cliente John
INSERT INTO ORDERS (client_id, product_id, quantity, total, address)
VALUES (1, 1, 3, 600, '789 Oak St'),
       (1, 2, 2, 500, '789 Oak St'),
       (1, 3, 1, 200, '789 Oak St');

-- Inserciones en la tabla ORDERS para el cliente Jane
INSERT INTO ORDERS (client_id, product_id, quantity, total, address)
VALUES (2, 4, 1, 1800, '456 Elm St'),
       (2, 3, 2, 1600, '456 Elm St');

-- Inserciones en la tabla ORDERS para el cliente Mike
INSERT INTO ORDERS (client_id, product_id, quantity, total, address)
VALUES (3, 1, 1, 600, '321 Pine St'),
       (3, 2, 3, 1200, '321 Pine St');


-- Vistas - View


CREATE VIEW OrderSummary AS
SELECT o.order_id, c.first_name AS client_name, p.product_name, o.quantity, o.total
FROM ORDERS o
INNER JOIN Clients c ON o.client_id = c.client_id
INNER JOIN PRODUCTS p ON o.product_id = p.product_id;

SELECT * FROM OrderSummary;


CREATE VIEW BigSpenderClients AS
SELECT c.client_id, c.first_name, SUM(o.total) AS total_spent
FROM Clients c
INNER JOIN ORDERS o ON c.client_id = o.client_id
GROUP BY c.client_id, c.first_name
HAVING total_spent > 500; -- Por ejemplo, total mayor a $500

SELECT * FROM BigSpenderClients;


CREATE VIEW ProductRevenue AS
SELECT p.product_id, p.product_name, SUM(o.total) AS total_revenue
FROM PRODUCTS p
INNER JOIN ORDERS o ON p.product_id = o.product_id
GROUP BY p.product_id, p.product_name;
SELECT * FROM ProductRevenue;


CREATE VIEW CustomersWithoutOrders AS
SELECT c.client_id, c.first_name
FROM Clients c
LEFT JOIN ORDERS o ON c.client_id = o.client_id
WHERE o.order_id IS NULL;
SELECT * FROM CustomersWithoutOrders;

CREATE VIEW ExpensiveProducts AS
SELECT product_id, product_name, price
FROM PRODUCTS
WHERE price > 1000; -- Por ejemplo, precio mayor a $1000
SELECT * FROM ExpensiveProducts;


DELIMITER //
CREATE FUNCTION CalculateTotalSpent(client_id INT) RETURNS INT
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE total_spent INT;
    
    SELECT SUM(total) INTO total_spent
    FROM ORDERS
    WHERE client_id = client_id;
    
    RETURN total_spent;
END //
DELIMITER ;


DELIMITER //
CREATE FUNCTION GetClientStock(client_id INT) RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE client_stock INT;
    
    SELECT SUM(p.stock) INTO client_stock
    FROM PRODUCTS p
    INNER JOIN ORDERS o ON p.product_id = o.product_id
    WHERE o.client_id = client_id;
    
    RETURN client_stock;
END //
DELIMITER ;

