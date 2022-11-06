DROP TABLE IF EXISTS review;
DROP TABLE IF EXISTS shipment;
DROP TABLE IF EXISTS productinventory;
DROP TABLE IF EXISTS warehouse;
DROP TABLE IF EXISTS orderproduct;
DROP TABLE IF EXISTS incart;
DROP TABLE IF EXISTS product;
DROP TABLE IF EXISTS category;
DROP TABLE IF EXISTS ordersummary;
DROP TABLE IF EXISTS paymentmethod;
DROP TABLE IF EXISTS customer;


CREATE TABLE customer (
    customerId          INT IDENTITY,
    firstName           VARCHAR(40),
    lastName            VARCHAR(40),
    email               VARCHAR(50),
    phonenum            VARCHAR(20),
    address             VARCHAR(50),
    city                VARCHAR(40),
    state               VARCHAR(20),
    postalCode          VARCHAR(20),
    country             VARCHAR(40),
    userid              VARCHAR(20),
    password            VARCHAR(30),
    PRIMARY KEY (customerId)
);

CREATE TABLE paymentmethod (
    paymentMethodId     INT IDENTITY,
    paymentType         VARCHAR(20),
    paymentNumber       VARCHAR(30),
    paymentExpiryDate   DATE,
    customerId          INT,
    PRIMARY KEY (paymentMethodId),
    FOREIGN KEY (customerId) REFERENCES customer(customerid)
        ON UPDATE CASCADE ON DELETE CASCADE 
);

CREATE TABLE ordersummary (
    orderId             INT IDENTITY,
    orderDate           DATETIME,
    totalAmount         DECIMAL(10,2),
    shiptoAddress       VARCHAR(50),
    shiptoCity          VARCHAR(40),
    shiptoState         VARCHAR(20),
    shiptoPostalCode    VARCHAR(20),
    shiptoCountry       VARCHAR(40),
    customerId          INT,
    PRIMARY KEY (orderId),
    FOREIGN KEY (customerId) REFERENCES customer(customerid)
        ON UPDATE CASCADE ON DELETE CASCADE 
);

CREATE TABLE category (
    categoryId          INT IDENTITY,
    categoryName        VARCHAR(50),    
    PRIMARY KEY (categoryId)
);

CREATE TABLE product (
    productId           INT IDENTITY,
    productName         VARCHAR(40),
    productPrice        DECIMAL(10,2),
    productImageURL     VARCHAR(100),
    productImage        VARBINARY(MAX),
    productDesc         VARCHAR(1000),
    categoryId          INT,
    PRIMARY KEY (productId),
    FOREIGN KEY (categoryId) REFERENCES category(categoryId)
);

CREATE TABLE orderproduct (
    orderId             INT,
    productId           INT,
    quantity            INT,
    price               DECIMAL(10,2),  
    PRIMARY KEY (orderId, productId),
    FOREIGN KEY (orderId) REFERENCES ordersummary(orderId)
        ON UPDATE CASCADE ON DELETE NO ACTION,
    FOREIGN KEY (productId) REFERENCES product(productId)
        ON UPDATE CASCADE ON DELETE NO ACTION
);

CREATE TABLE incart (
    orderId             INT,
    productId           INT,
    quantity            INT,
    price               DECIMAL(10,2),  
    PRIMARY KEY (orderId, productId),
    FOREIGN KEY (orderId) REFERENCES ordersummary(orderId)
        ON UPDATE CASCADE ON DELETE NO ACTION,
    FOREIGN KEY (productId) REFERENCES product(productId)
        ON UPDATE CASCADE ON DELETE NO ACTION
);

CREATE TABLE warehouse (
    warehouseId         INT IDENTITY,
    warehouseName       VARCHAR(30),    
    PRIMARY KEY (warehouseId)
);

CREATE TABLE shipment (
    shipmentId          INT IDENTITY,
    shipmentDate        DATETIME,   
    shipmentDesc        VARCHAR(100),   
    warehouseId         INT, 
    PRIMARY KEY (shipmentId),
    FOREIGN KEY (warehouseId) REFERENCES warehouse(warehouseId)
        ON UPDATE CASCADE ON DELETE NO ACTION
);

CREATE TABLE productinventory ( 
    productId           INT,
    warehouseId         INT,
    quantity            INT,
    price               DECIMAL(10,2),  
    PRIMARY KEY (productId, warehouseId),   
    FOREIGN KEY (productId) REFERENCES product(productId)
        ON UPDATE CASCADE ON DELETE NO ACTION,
    FOREIGN KEY (warehouseId) REFERENCES warehouse(warehouseId)
        ON UPDATE CASCADE ON DELETE NO ACTION
);

CREATE TABLE review (
    reviewId            INT IDENTITY,
    reviewRating        INT,
    reviewDate          DATETIME,   
    customerId          INT,
    productId           INT,
    reviewComment       VARCHAR(1000),          
    PRIMARY KEY (reviewId),
    FOREIGN KEY (customerId) REFERENCES customer(customerId)
        ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (productId) REFERENCES product(productId)
        ON UPDATE CASCADE ON DELETE CASCADE
);

INSERT INTO category(categoryName) VALUES ('Beverages');
INSERT INTO category(categoryName) VALUES ('Condiments');
INSERT INTO category(categoryName) VALUES ('Dairy Products');
INSERT INTO category(categoryName) VALUES ('Produce');
INSERT INTO category(categoryName) VALUES ('Meat/Poultry');
INSERT INTO category(categoryName) VALUES ('Seafood');
INSERT INTO category(categoryName) VALUES ('Confections');
INSERT INTO category(categoryName) VALUES ('Grains/Cereals');

--beverages
INSERT INTO product(productName, productPrice, productImageURL, productDesc, categoryId) VALUES( 'Bombay Gin', 39.99,'img/01.jpg', 'Every COSCS student favorite sleep aid', 1);
INSERT INTO product(productName, productPrice, productImageURL, productDesc, categoryId) VALUES( 'Titos Vodka', 39.99,'IMG/02.jpg', 'Finally, a vodka that doesnt taste like hand sanitizer', 1);
INSERT INTO product(productName, productPrice, productImageURL, productDesc, categoryId) VALUES( 'Appletons Rum', 29.99 ,'IMG/03.jpg', 'When you need a mental break before your scheduled mental breakdown', 1);
INSERT INTO product(productName, productPrice, productImageURL, productDesc, categoryId) VALUES( 'Cabo Wabo Tequila', 79.99 ,'IMG/04.jpg', 'Tequilla solves the question of how to feel like youve been punched in the mouth without insulting your step dad.', 1);
INSERT INTO product(productName, productPrice, productImageURL, productDesc, categoryId) VALUES( 'Jamesons Whiskey', 29.99 , 'IMG/05.jpg', 'The rise and fall of Ireland bottled for your convenience.', 1);
--condiments
INSERT INTO product(productName, productPrice, productImageURL, productDesc, categoryId) VALUES( 'Ketchup', 9.99,'IMG/06.jpg' ,'According to Reagan, this a vegetable!' ,2);
INSERT INTO product(productName, productPrice, productImageURL, productDesc, categoryId) VALUES( 'Mustard', 9.99,'IMG/07.jpg','Also available in Dijon if you wan that added taste of moral superiority.' ,2);
INSERT INTO product(productName, productPrice, productImageURL, productDesc, categoryId) VALUES( 'Relish', 9.99,'IMG/08.jpg' ,'There could have a been a relish the moment pun here, but we didnt want to hear people brine-ing about it.' ,2);
INSERT INTO product(productName, productPrice, productImageURL, productDesc, categoryId) VALUES( 'Sriracha', 5.99,'IMG/09.jpg','Also doubles as eye drops in a pinch' ,2);
INSERT INTO product(productName, productPrice, productImageURL, productDesc, categoryId) VALUES( 'Soy Sauce' , 5.99, 'IMG/10.jpg','Still not a salty as an 05 COD lobby' ,2);
--dairy products
INSERT INTO product(productName, productPrice, productImageURL, productDesc, categoryId) VALUES( 'Yogurt',2.99 ,'IMG/11.jpg','Why does yogurt have an expiry date? Its whole premise is being expired Milk' ,3);
INSERT INTO product(productName, productPrice, productImageURL, productDesc, categoryId) VALUES( 'Milk' , 3.99,'IMG/12.jpg','Age this to juxtapose fine wine.' ,3);
INSERT INTO product(productName, productPrice, productImageURL, productDesc, categoryId) VALUES( 'Cheese' ,5.99 , 'IMG/13.jpg','Test your lactose intolerant friends integrity by offering them this.' ,3);
INSERT INTO product(productName, productPrice, productImageURL, productDesc, categoryId) VALUES( 'Oat Milk' ,5.99 ,'IMG/14.jpg' ,'Tired of being a soy-boy? Try this!' ,3);
INSERT INTO product(productName, productPrice, productImageURL, productDesc, categoryId) VALUES( 'Other Cheese',99.99 ,'IMG/15.jpg' ,'This mystery cheese probably isnt laced with codeine.' ,3);
--produce
INSERT INTO product(productName, productPrice, productImageURL, productDesc, categoryId) VALUES( 'Cherry Tomato' , 5.99, 'IMG/16.jpg','Like a regular tomato but smol.' ,4);
INSERT INTO product(productName, productPrice, productImageURL, productDesc, categoryId) VALUES( 'Lettuce' , 2.99,'IMG/17.jpg' , 'Hands down the most boring edible leaf.' ,4);
INSERT INTO product(productName, productPrice, productImageURL, productDesc, categoryId) VALUES( 'Banana' , 0.99,'IMG/18.jpg' ,'The phallic shape of this fruit is why it tastes so good.' ,4);
INSERT INTO product(productName, productPrice, productImageURL, productDesc, categoryId) VALUES( 'Apple' , 0.99,'IMG/19.jpg' , 'Doctors just abhor these.',4);
INSERT INTO product(productName, productPrice, productImageURL, productDesc, categoryId) VALUES( 'Onion', 5.99,'IMG/20.jpg' ,'Bear incredible similarity to ogres.' ,4);
--meat/poultry
INSERT INTO product(productName, productPrice, productImageURL, productDesc, categoryId) VALUES( 'Egg', 12.99,'IMG/21.jpg','Avoid thinking about origin of this item.' ,5);
INSERT INTO product(productName, productPrice, productImageURL, productDesc, categoryId) VALUES( 'Sausages', 7.99, 'IMG/22.jpg','These employ the banana tactic to enhance flavor' ,5);
INSERT INTO product(productName, productPrice, productImageURL, productDesc, categoryId) VALUES( 'Ground Beef', 9.99, 'IMG/23.jpg','Contrary to popular belief, domestic ground tastes nothing like store bought and science doesnt know why.' ,5);
INSERT INTO product(productName, productPrice, productImageURL, productDesc, categoryId) VALUES( 'Salmon Patty', 15.99,'IMG/24.jpg','Completely usable as a frisbee in a pinch' ,5);
INSERT INTO product(productName, productPrice, productImageURL, productDesc, categoryId) VALUES( 'Chicken Breats',12.99,'IMG/25.jpg' ,'We sourced the busty-est chickens, just for you!' ,5);
--seafood
INSERT INTO product(productName, productPrice, productImageURL, productDesc, categoryId) VALUES( 'Prawns', 6.99,'IMG/26.jpg' ,'Not known for their posture!' ,6);
INSERT INTO product(productName, productPrice, productImageURL, productDesc, categoryId) VALUES( 'Tuna', 2.99,'IMG/27.jpg' ,'As a constant source of inspiration, theyll remind you that theyve never been called a Tuna Cant',6);
INSERT INTO product(productName, productPrice, productImageURL, productDesc, categoryId) VALUES( 'Canned Salmon', 3.99,'IMG/28.jpg' ,'Salmon that has been imprisoned for failing to abide by the Geneva convention' ,6);
INSERT INTO product(productName, productPrice, productImageURL, productDesc, categoryId) VALUES( 'Sardines', 5.99,'IMG/29.jpg' ,'Americas favorite stocking stuffer' ,6);
INSERT INTO product(productName, productPrice, productImageURL, productDesc, categoryId) VALUES( 'Kippered Herring', 5.99,'IMG/30.jpg' ,'Now with an even more sussy smell!' ,6);
--confections
INSERT INTO product(productName, productPrice, productImageURL, productDesc, categoryId) VALUES( 'Caramilk' , 2.99,'IMG/31.jpg' ,'Theyve built a brand on a mystery of how the caramel got in there. Enzymes. Thats how. ' ,7);
INSERT INTO product(productName, productPrice, productImageURL, productDesc, categoryId) VALUES( 'Snickers Double Pack', 2.99,'IMG/32.jpg' ,'Feel free to pretend you have a friend to share this with.' ,7);
INSERT INTO product(productName, productPrice, productImageURL, productDesc, categoryId) VALUES( 'Mint Chocolate', 5.99,'IMG/33.jpg' ,'If you like these, try toothpaste!' ,7);
INSERT INTO product(productName, productPrice, productImageURL, productDesc, categoryId) VALUES( 'Candied Peanuts', 8.99,'IMG/34.jpg' ,'This was almost healthy and then they where like nah' ,7);
INSERT INTO product(productName, productPrice, productImageURL, productDesc, categoryId) VALUES( 'Popcorn', 89.99, 'IMG/35.jpg','Price adjusted to Movie Theater standards' ,7);
--grains/cereals
INSERT INTO product(productName, productPrice, productImageURL, productDesc, categoryId) VALUES( 'Oats' , 8.99,'IMG/36.jpg' ,'Ever wondered what the colour gray tastes like? These, it tastes like these' ,8);
INSERT INTO product(productName, productPrice, productImageURL, productDesc, categoryId) VALUES( 'Cereal' ,5.99 ,'IMG/37.jpg' ,'Crunchy for a limited time!' ,8);
INSERT INTO product(productName, productPrice, productImageURL, productDesc, categoryId) VALUES( 'Rice Cakes', 2.99,'IMG/38.jpg' ,'Tastes nothing like cake!' ,8);
INSERT INTO product(productName, productPrice, productImageURL, productDesc, categoryId) VALUES( 'Wheat Thins',5.99 ,'IMG/39.jpg' ,'Classy!' ,8);
INSERT INTO product(productName, productPrice, productImageURL, productDesc, categoryId) VALUES( 'Energy Bar',6.99,'IMG/40.jpg' ,  'Instantly make yourself look more adventurous!',8);


--Info for warehouses
INSERT INTO warehouse(warehouseName) VALUES ('Boozy House')
INSERT INTO warehouse(warehouseName) VALUES ('Saucy House')
INSERT INTO warehouse(warehouseName) VALUES ('Milky House')
INSERT INTO warehouse(warehouseName) VALUES ('Sprouty House')
INSERT INTO warehouse(warehouseName) VALUES ('Meaty House')
INSERT INTO warehouse(warehouseName) VALUES ('Smelly House')
INSERT INTO warehouse(warehouseName) VALUES ('Sweety House')
INSERT INTO warehouse(warehouseName) VALUES ('Grainy House')

--prodInventory
INSERT INTO productinventory(productId, warehouseId, quantity) VALUES (1 , 1, 50 )
INSERT INTO productinventory(productId, warehouseId, quantity) VALUES (2 , 1, 50 )
INSERT INTO productinventory(productId, warehouseId, quantity) VALUES (3 , 1, 50 )
INSERT INTO productinventory(productId, warehouseId, quantity) VALUES (4 , 1, 50 )
INSERT INTO productinventory(productId, warehouseId, quantity) VALUES (5 , 1, 50 )
INSERT INTO productinventory(productId, warehouseId, quantity) VALUES (6 , 2, 50 )
INSERT INTO productinventory(productId, warehouseId, quantity) VALUES (7 , 2, 50 )
INSERT INTO productinventory(productId, warehouseId, quantity) VALUES (8 , 2, 50 )
INSERT INTO productinventory(productId, warehouseId, quantity) VALUES (9 , 2, 50 )
INSERT INTO productinventory(productId, warehouseId, quantity) VALUES (10 , 2, 50 )
INSERT INTO productinventory(productId, warehouseId, quantity) VALUES (11 , 3, 50 )
INSERT INTO productinventory(productId, warehouseId, quantity) VALUES (12 , 3, 50 )
INSERT INTO productinventory(productId, warehouseId, quantity) VALUES (13 , 3, 50 )
INSERT INTO productinventory(productId, warehouseId, quantity) VALUES (14 , 3, 50 )
INSERT INTO productinventory(productId, warehouseId, quantity) VALUES (15 , 3, 50 )
INSERT INTO productinventory(productId, warehouseId, quantity) VALUES (16 , 4, 50 )
INSERT INTO productinventory(productId, warehouseId, quantity) VALUES (17 , 4, 50 )
INSERT INTO productinventory(productId, warehouseId, quantity) VALUES (18 , 4, 50 )
INSERT INTO productinventory(productId, warehouseId, quantity) VALUES (19 , 4, 50 )
INSERT INTO productinventory(productId, warehouseId, quantity) VALUES (20 , 4, 50 )
INSERT INTO productinventory(productId, warehouseId, quantity) VALUES (21 , 5, 50 )
INSERT INTO productinventory(productId, warehouseId, quantity) VALUES (22 , 5, 50 )
INSERT INTO productinventory(productId, warehouseId, quantity) VALUES (23 , 5, 50 )
INSERT INTO productinventory(productId, warehouseId, quantity) VALUES (24 , 5, 50 )
INSERT INTO productinventory(productId, warehouseId, quantity) VALUES (25 , 5, 50 )
INSERT INTO productinventory(productId, warehouseId, quantity) VALUES (26 , 6, 50 )
INSERT INTO productinventory(productId, warehouseId, quantity) VALUES (27 , 6, 50 )
INSERT INTO productinventory(productId, warehouseId, quantity) VALUES (28 , 6, 50 )
INSERT INTO productinventory(productId, warehouseId, quantity) VALUES (29 , 6, 50 )
INSERT INTO productinventory(productId, warehouseId, quantity) VALUES (30 , 6, 50 )
INSERT INTO productinventory(productId, warehouseId, quantity) VALUES (31 , 7, 50 )
INSERT INTO productinventory(productId, warehouseId, quantity) VALUES (32 , 7, 50 )
INSERT INTO productinventory(productId, warehouseId, quantity) VALUES (33 , 7, 50 )
INSERT INTO productinventory(productId, warehouseId, quantity) VALUES (34 , 7, 50 )
INSERT INTO productinventory(productId, warehouseId, quantity) VALUES (35 , 7, 50 )
INSERT INTO productinventory(productId, warehouseId, quantity) VALUES (36 , 8, 50 )
INSERT INTO productinventory(productId, warehouseId, quantity) VALUES (37 , 8, 50 )
INSERT INTO productinventory(productId, warehouseId, quantity) VALUES (38 , 8, 50 )
INSERT INTO productinventory(productId, warehouseId, quantity) VALUES (39 , 8, 50 )
INSERT INTO productinventory(productId, warehouseId, quantity) VALUES (40 , 8, 50 )


INSERT INTO customer (firstName, lastName, email, phonenum, address, city, state, postalCode, country, userid, password) VALUES ('Arnold', 'Anderson', 'a.anderson@gmail.com', '204-111-2222', '103 AnyWhere Street', 'Winnipeg', 'MB', 'R3X 45T', 'Canada', 'arnold' , 'test');
INSERT INTO customer (firstName, lastName, email, phonenum, address, city, state, postalCode, country, userid, password) VALUES ('Bobby', 'Brown', 'bobby.brown@hotmail.ca', '572-342-8911', '222 Bush Avenue', 'Boston', 'MA', '22222', 'United States', 'bobby' , 'bobby');
INSERT INTO customer (firstName, lastName, email, phonenum, address, city, state, postalCode, country, userid, password) VALUES ('Candace', 'Cole', 'cole@charity.org', '333-444-5555', '333 Central Crescent', 'Chicago', 'IL', '33333', 'United States', 'candace' , 'password');
INSERT INTO customer (firstName, lastName, email, phonenum, address, city, state, postalCode, country, userid, password) VALUES ('Darren', 'Doe', 'oe@doe.com', '250-807-2222', '444 Dover Lane', 'Kelowna', 'BC', 'V1V 2X9', 'Canada', 'darren' , 'pw');
INSERT INTO customer (firstName, lastName, email, phonenum, address, city, state, postalCode, country, userid, password) VALUES ('Elizabeth', 'Elliott', 'engel@uiowa.edu', '555-666-7777', '555 Everwood Street', 'Iowa City', 'IA', '52241', 'United States', 'beth' , 'test');
INSERT INTO customer (userid, password) VALUES ('Admin' , 'Password');
