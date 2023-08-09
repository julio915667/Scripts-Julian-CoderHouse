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
       
       SELECT * FROM PRODUCTS;

