CREATE TABLE Clients (
client_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
first_name VARCHAR(30),
user_name VARCHAR(30),
email VARCHAR(30),
pass_word VARCHAR(30)
);

CREATE TABLE ORDERS (
client_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
product_name VARCHAR(30),
quantity INT(30),
total INT(30),
address VARCHAR(30)
);