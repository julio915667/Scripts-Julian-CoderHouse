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

DELIMITER //
CREATE PROCEDURE OrdenamientoDinamicoDeProductos(
    IN columna_orden VARCHAR(30),
    IN tipo_orden VARCHAR(10)
)
BEGIN
    SET @query = CONCAT('SELECT * FROM PRODUCTS ORDER BY ', columna_orden, ' ', tipo_orden);
    PREPARE stmt FROM @query;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END //
DELIMITER ;

CALL OrdenamientoDinamicoDeProductos('price', 'DESC');


DELIMITER //
CREATE PROCEDURE InsertarUEliminar(
    IN operacion INT, -- 1 para INSERTAR, 2 para ELIMINAR
    IN nombre_producto VARCHAR(30),
    IN cantidad INT,
    IN precio INT,
    IN imagen VARCHAR(40)
)
BEGIN
    IF operacion = 1 THEN
        INSERT INTO PRODUCTS (product_name, stock, price, image)
        VALUES (nombre_producto, cantidad, precio, imagen);
    ELSEIF operacion = 2 THEN
        DELETE FROM PRODUCTS
        WHERE product_name = nombre_producto;
    END IF;
END //
DELIMITER ;


CALL InsertarUEliminar(2, 'Producto a Eliminar', 0, 0, '');
CALL InsertarUEliminar(1, 'Nuevo Producto', 50, 200, 'nuevo_producto.jpg');



-- Tabla de historial para operaciones en Clients
CREATE TABLE Clients_Log (
    log_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    action_type VARCHAR(10), -- INSERT, UPDATE, DELETE
    timestamp DATETIME,
    user_id INT,
    client_id INT
    -- Otros campos relevantes para el historial
);

-- Tabla de historial para operaciones en PRODUCTS
CREATE TABLE Products_Log (
    log_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    action_type VARCHAR(10), -- INSERT, UPDATE, DELETE
    timestamp DATETIME,
    user_id INT,
    product_id INT
    -- Otros campos relevantes para el historial
);


-- Trigger para operaciones en Clients
DELIMITER //
CREATE TRIGGER Clients_BeforeInsert
BEFORE INSERT ON Clients
FOR EACH ROW
BEGIN
    INSERT INTO Clients_Log (action_type, timestamp, user_id, client_id)
    VALUES ('INSERT', NOW(), @user_id, NEW.client_id);
END;
//

CREATE TRIGGER Clients_AfterUpdate
AFTER UPDATE ON Clients
FOR EACH ROW
BEGIN
    INSERT INTO Clients_Log (action_type, timestamp, user_id, client_id)
    VALUES ('UPDATE', NOW(), @user_id, NEW.client_id);
END;
//

CREATE TRIGGER Clients_AfterDelete
AFTER DELETE ON Clients
FOR EACH ROW
BEGIN
    INSERT INTO Clients_Log (action_type, timestamp, user_id, client_id)
    VALUES ('DELETE', NOW(), @user_id, OLD.client_id);
END;
//

-- Trigger para operaciones en PRODUCTS
DELIMITER //
CREATE TRIGGER Products_BeforeInsert
BEFORE INSERT ON PRODUCTS
FOR EACH ROW
BEGIN
    INSERT INTO Products_Log (action_type, timestamp, user_id, product_id)
    VALUES ('INSERT', NOW(), @user_id, NEW.product_id);
END;
//

CREATE TRIGGER Products_AfterUpdate
AFTER UPDATE ON PRODUCTS
FOR EACH ROW
BEGIN
    INSERT INTO Products_Log (action_type, timestamp, user_id, product_id)
    VALUES ('UPDATE', NOW(), @user_id, NEW.product_id);
END;
//

CREATE TRIGGER Products_AfterDelete
AFTER DELETE ON PRODUCTS
FOR EACH ROW
BEGIN
    INSERT INTO Products_Log (action_type, timestamp, user_id, product_id)
    VALUES ('DELETE', NOW(), @user_id, OLD.product_id);
END;
//

-- Crear usuario con permisos de solo lectura
CREATE USER 'usuario_lectura'@'localhost' IDENTIFIED BY 'contraseña_lectura';

-- Crear usuario con permisos de lectura, inserción y modificación
CREATE USER 'usuario_modificacion'@'localhost' IDENTIFIED BY 'contraseña_modificacion';

-- Asignar permisos de solo lectura a todas las tablas en el esquema Mayorista ElectroBazar
GRANT SELECT ON MayoristaElectroBazar.* TO 'usuario_lectura'@'localhost';


-- Asignar permisos de lectura, inserción y modificación a todas las tablas en el esquema MayoristaElectroBazar
GRANT SELECT, INSERT, UPDATE ON MayoristaElectroBazar.* TO 'usuario_modificacion'@'localhost';

-- No permitir que el usuario elimine registros de ninguna tabla
-- (Siempre es una buena práctica evitar otorgar permisos de eliminación a menos que sea necesario)



-- Comenzamos una transacción
START TRANSACTION;

-- Verificamos si la tabla Clients tiene registros
SELECT COUNT(*) FROM Clients;

-- Si la tabla tiene registros, eliminamos algunos de ellos (dejando algunos registros)
-- Si no tiene registros, realizamos una inserción de ejemplo
-- En lugar de eliminar registros, agregamos nuevos registros en este ejemplo
DELETE FROM Clients WHERE client_id IN (1, 2);

-- Realizar una inserción de ejemplo si no hay registros
INSERT INTO Clients (first_name, user_name, email, pass_word)
VALUES ('New', 'new_user', 'new@example.com', 'new_password');

-- Aquí comentamos la sentencia Rollback (no la ejecutamos)
-- ROLLBACK;

-- Y aquí ejecutamos la sentencia Commit para guardar los cambios
COMMIT;


-- Comenzamos una nueva transacción
START TRANSACTION;

-- Insertamos 8 nuevos registros en la tabla PRODUCTS
INSERT INTO PRODUCTS (product_name, stock, price, image)
VALUES
    ('Product 1', 10, 100, 'product1.jpg'),
    ('Product 2', 20, 200, 'product2.jpg'),
    ('Product 3', 30, 300, 'product3.jpg'),
    ('Product 4', 40, 400, 'product4.jpg');

-- Agregamos un savepoint después de insertar el registro #4
SAVEPOINT savepoint_after_4;

-- Continuamos insertando registros
INSERT INTO PRODUCTS (product_name, stock, price, image)
VALUES
    ('Product 5', 50, 500, 'product5.jpg'),
    ('Product 6', 60, 600, 'product6.jpg'),
    ('Product 7', 70, 700, 'product7.jpg'),
    ('Product 8', 80, 800, 'product8.jpg');

-- Agregamos un savepoint después de insertar el registro #8
SAVEPOINT savepoint_after_8;

-- Aquí comentamos la sentencia para eliminar el savepoint después de los primeros 4 registros (no la ejecutamos)
-- ROLLBACK TO savepoint_after_4;

-- Terminamos la transacción y guardamos todos los cambios
COMMIT;

-- Informes

SELECT c.first_name AS client_name, o.order_id, o.product_name, o.quantity, o.total, o.address
FROM ORDERS o
INNER JOIN Clients c ON o.client_id = c.client_id;

SELECT c.client_id, c.first_name, SUM(o.total) AS total_spent
FROM Clients c
INNER JOIN ORDERS o ON c.client_id = o.client_id
GROUP BY c.client_id, c.first_name
HAVING total_spent > 500;

SELECT p.product_id, p.product_name, SUM(o.total) AS total_revenue
FROM PRODUCTS p
INNER JOIN ORDERS o ON p.product_id = o.product_id
GROUP BY p.product_id, p.product_name;


SELECT c.client_id, c.first_name
FROM Clients c
LEFT JOIN ORDERS o ON c.client_id = o.client_id
WHERE o.order_id IS NULL;


