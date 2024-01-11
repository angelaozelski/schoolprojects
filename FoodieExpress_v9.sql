-- Create the 'FoodieExpress' database
if not exists (select *from sys.databases where name = 'FoodieExpress')
CREATE DATABASE FoodieExpress;

-- Use the 'FoodieExpress' database
USE FoodieExpress;
GO

--DOWN
--Users fk drop
if exists (select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
    where constraint_name = 'fk_Users_AddressID')
    alter TABLE Users drop fk_Users_AddressID
--OrderItems fk drop
if exists (select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
    where constraint_name = 'fk_OrderItems_MenuItemID')
    alter TABLE OrderItems drop fk_OrderItems_MenuItemID
if exists (select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
    where constraint_name = 'fk_OrderItems_UserID')
    alter TABLE OrderItems drop fk_OrderItems_UserID

--Restaurants fk drop
if exists (select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
    where constraint_name = 'fk_Restaurants_OwnerUserID')
    alter TABLE Restaurants drop fk_Restaurants_OwnerUserID
if exists (select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
    where constraint_name = 'fk_Restaurants_AddressID')
    alter TABLE Restaurants drop fk_Restaurants_AddressID
--MenuItems fk drop
if exists (select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
    where constraint_name = 'fk_MenuItems')
    alter TABLE MenuItems drop fk_MenuItems
--Bills fk drop
if exists (select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
    where constraint_name = 'fk_Bill_OrderId')
    alter TABLE Bills drop fk_Bill_OrderId
if exists (select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
    where constraint_name = 'fk_Bill_UserID')
    alter TABLE Bills drop fk_Bill_UserID


drop table if EXISTS OrderItems --Two fk
drop table if EXISTS Bills -- NO fk
drop table if EXISTS MenuItems -- One fk
drop table if EXISTS Restaurants -- Two fk
drop table if EXISTS Users  -- One fk
drop table if EXISTS Addresses --No fk



--UP
-- Create the 'Addresses' table
CREATE TABLE Addresses (
    AddressID INT IDENTITY(1,1) PRIMARY KEY,
    Street NVARCHAR(MAX) NOT NULL,
    City NVARCHAR(100) NOT NULL,
    State_code NVARCHAR(100) NOT NULL,
    ZipCode NVARCHAR(20) NOT NULL,
    Phone NVARCHAR(20)
);

-- Create the 'Users' table with AddressID foreign key
CREATE TABLE Users (
    UserID INT IDENTITY(1,1) PRIMARY KEY,
    UserType NVARCHAR(50) NOT NULL,
    FullName NVARCHAR(100) NOT NULL,
    Email NVARCHAR(255) UNIQUE NOT NULL,
    User_password NVARCHAR(255) NOT NULL,
    User_addressID INT
    CONSTRAINT fk_Users_AddressID FOREIGN KEY (User_addressID) REFERENCES Addresses(AddressID)
);

-- Create the 'Restaurants' table with AddressID foreign key
CREATE TABLE Restaurants (
    RestaurantID INT IDENTITY(1,1) PRIMARY KEY,
    OwnerUserID INT,
    Name NVARCHAR(100) NOT NULL,
    Restaurant_addressID INT,
    Phone NVARCHAR(20),
    CONSTRAINT fk_Restaurants_OwnerUserID FOREIGN KEY (OwnerUserID) REFERENCES Users(UserID),
    CONSTRAINT fk_Restaurants_AddressID FOREIGN KEY (Restaurant_addressID) REFERENCES Addresses(AddressID)
);

-- Create the 'MenuItems' table to store restaurant menu items
CREATE TABLE MenuItems (
    MenuItemID INT IDENTITY(1,1) PRIMARY KEY,
    RestaurantID INT,
    Name NVARCHAR(100) NOT NULL,
    Description NVARCHAR(MAX),
    Price DECIMAL(10, 2) NOT NULL,
    CONSTRAINT fk_MenuItems FOREIGN KEY (RestaurantID) REFERENCES Restaurants(RestaurantID)
);

-- Create the 'OrderItems' table to store individual items within an order
CREATE TABLE OrderItems (
    OrderItemID INT IDENTITY(1,1) PRIMARY KEY,
    Order_customer_ID INT,
    MenuItemID INT,
    Quantity INT NOT NULL
    CONSTRAINT fk_OrderItems_MenuItemID foreign key (MenuItemID) REFERENCES MenuItems(MenuItemID),
    CONSTRAINT fk_OrderItems_UserID foreign key (Order_customer_ID) REFERENCES Users(UserID)
);

-- Create the 'Bills' table to store customer Bills
CREATE TABLE Bills (
    Bill_ID INT IDENTITY(1,1) PRIMARY key,
    Bill_UserID int,
    OrderDate DATETIME DEFAULT GETDATE(),
    Status NVARCHAR(50) NOT NULL,
    TotalAmount DECIMAL(10, 2) NOT NULL
    CONSTRAINT fk_Bill_UserID FOREIGN key (Bill_UserID) REFERENCES Users(UserID)
);




-- Insert sample Addresses. Since this has primary key, the data need to be inserted 1st
GO
SET IDENTITY_INSERT Addresses ON;
INSERT INTO Addresses (AddressID, Street, City, State_code, ZipCode, phone)
VALUES
    (1, '123 Main St', 'Troy', 'CA', '94101','N/A'),
    (2, '456 Elm St', 'Macomb', 'CA', '94101','N/A'),
    (3, '789 Oak St', 'Sterling Heights' , 'CA', '94101', 'N/A'),
    (4, '123 Palm Street', 'Oceanview', 'CA', '94101','N/A'),
    (5, '456 Sunset Avenue', 'Redwood City', 'CA', '94101','N/A'),
    (6, '789 Harbor Road', 'Seaside', 'CA', '94101','N/A'),
    (7, '1010 Golden Lane', 'Bayville', 'CA', '94101','N/A'),
    (8, '222 Pacific Drive', 'Sunfield', 'CA', '94101','N/A'),
    (9, '333 Coastal Lane', 'Palm Beach', 'CA', '94101','N/A'),
    (10, '444 Bayview Road', 'Coralville', 'CA', '94101','N/A'),
    (11, '555 Surfside Avenue', 'Wavecrest', 'CA', '94101','N/A'),
    (12, '666 Seashell Street', 'Marina Bay', 'CA', '94101','N/A'),
    (13, '777 Oceanfront Drive', 'Rivertown', 'CA', '94101','N/A'),
    (14, '888 Beach Boulevard', 'Shoreville', 'CA', '94101','N/A'),
    (15, '999 Sandcastle Lane', 'Lighthouse', 'CA', '94101','N/A'),
    (16, '1111 Boardwalk Street', 'Bayshore', 'CA', '94101','N/A'),
    (17, '1234 Palm Tree Road', 'Beachwood', 'CA', '94101','N/A'),
    (18, '1357 Shoreline Avenue', 'Coral Bay', 'CA', '94101','N/A'),
    (19, '1470 Seaview Drive', 'Coastline', 'CA', '94101','N/A'),
    (20, '1593 Bayshore Road', 'Sandy Cove', 'CA','94101', 'N/A'),
    (21, '1716 Pier Street', 'Mariners Point', 'CA', '94101','N/A'),
    (22, '1839 Cove Lane', 'Ocean Breeze', 'CA','94101', 'N/A'),
    (23, '1962 Tidal Avenue', 'Harbor Bay', 'CA', '94101','N/A'),
    (24, '2085 Surf Drive', 'Pacific Shores', 'CA', '94101','N/A'),
    (25, '2208 Beachfront Road', 'Sunset Cove', 'CA', '94101','N/A'),
    (26, '2331 Marina Lane', 'Coastal Harbor', 'CA', '94101','N/A'),
    (27, '2454 Sunset Boulevard', 'Shoreline Beach', 'CA', '94101','N/A'),
    (28, '2577 Coastal Court', 'Oceanview Estates', 'CA', '94101','N/A'),
    (29, '191 Castro St', 'Mountain View', 'CA', '94041', '650-426-0582'),
    (30, '789 Pizza Ave', 'Harbor Bay', 'CA', '90345','123-456-7890'),
    (31, '456 Burger Blvd', 'Oceanview Estates', 'CA', '90345', '987-654-3210'),
    (32, '123 Seaside Avenue', 'Coral Bay', 'CA', '90210', '415-555-1234'),
    (33, '456 Oak Street', 'Willowville', 'CA', '90345', '310-555-5678'),
    (34, '789 Spice Lane', 'Pacificville', 'CA', '90456', '702-555-9876'),
    (35, '234 Flame Road', 'Grille City', 'CA', '90567', '786-555-4321');
SET IDENTITY_INSERT Addresses OFF;

-- Insert sample users
GO
INSERT INTO Users (UserType, FullName, Email, User_password, User_addressID)
VALUES
    ('Customer', 'John Doe', 'john@example.com', 'hashed_password_customer', '1'),
    ('RestaurantOwner', 'Alice Smith', 'alice@example.com', 'hashed_password_owner', '2'),
    ('DeliveryDriver', 'Bob Johnson', 'bob@example.com', 'hashed_password_driver', '3'),
    ('Customer','Alice Johnson','Alice1@example.com','3$K9z','4'), --Vu Ton
    ('Customer','Mark Williams','Mark@example.com','pT7&x','5'),
    ('Customer','Sarah Davis','Sarah@example.com','L$W5q8','6'),
    ('Customer','John Smith','John1@example.com','9uR#v','7'),
    ('Customer','Emily Turner','Emily@example.com','Y*2nW','8'),
    ('Customer','David Martinez','David@example.com','X6Z@p','9'),
    ('Customer','Laura Thompson','Laura@example.com','dV5Q7','10'),
    ('Customer','Michael Clark','Michael@example.com','A&8zJ','11'),
    ('Customer','Olivia White','Olivia@example.com','Gp6%R','12'),
    ('Customer','Daniel Brown','Daniel@example.com','4x@Wv','13'),
    ('DeliveryDriver','Sophia Lee','Sophia@example.com','Y7UzP','14'),
    ('DeliveryDriver','Christopher Wilson','Christopher@example.com','fS3*J','15'),
    ('DeliveryDriver','Mia Adams','Mia@example.com','tD6#K','16'),
    ('DeliveryDriver','Andrew Walker','Andrew@example.com','Z9b$R','17'),
    ('DeliveryDriver','Ava Garcia','Ava@example.com','7N#pX','18'),
    ('DeliveryDriver','William Harris','William@example.com','kQ8@L','19'),
    ('DeliveryDriver','Chloe Scott','Chloe@example.com','H1v$Y','20'),
    ('RestaurantOwner','James Anderson','James@example.com','6sT*W','21'),
    ('RestaurantOwner','Grace Jackson','Grace@example.com','m7Y$J','22'),
    ('RestaurantOwner','Joseph Wright','Joseph@example.com','eL@5z','23'),
    ('RestaurantOwner','Ella Thomas','Ella@example.com','R4Xp&','24'),
    ('RestaurantOwner','Benjamin Lopez','Benjamin@example.com','U%2rL','25'),
    ('RestaurantOwner','Lily Hall','Lily@example.com','iK9$B','26'),
    ('RestaurantOwner','Samuel Martin','Samuel@example.com','Ov3&J','27'),
    ('RestaurantOwner','Harper Rodriguez','Harper@example.com','Zt7G@','28'); 

-- Insert sample restaurants
GO
SET IDENTITY_INSERT Restaurants ON;
INSERT INTO Restaurants (RestaurantID, OwnerUserID, Name, Restaurant_addressID, Phone)
VALUES
    (1, 1, 'Eureka! Mountain View', '29', '650-426-0582'), --AO
    (2, 2, 'Pizza Palace', '30', '123-456-7890'),
    (3, 3, 'Burger Joint', '31', '987-654-3210'),
    (4, 4, 'Mediterranean Delights','32','415-555-1234'), --Vu Ton
    (5, 5, 'Savory Bistro','33','310-555-5678'),
    (6, 6, 'Thai Orchid Garden','34','702-555-9876'),
    (7, 7, 'Steakhouse 42','35','786-555-4321');
SET IDENTITY_INSERT Restaurants OFF;

-- Insert sample menu items for 'Eureka!'
GO
SET IDENTITY_INSERT MenuItems ON;
INSERT INTO MenuItems (RestaurantID, MenuItemID, Name, Description, Price)
VALUES
    (1, 31, 'Mushroom Burger', 'Vegan burger made from Portobello Mushroom Caps with Spicy Aoili. Served with French Fries, Soup, or Salad', 10.99),
    (1, 32, 'Chicken Sandwich', 'Grilled Chicken Sandwich with lettuce, tomato, onion, pickles and garlic aoili. Served with French Fries, Soup, or Salad', 12.99);

-- Insert sample menu items for 'Pizza Palace'
GO
INSERT INTO MenuItems (RestaurantID, MenuItemID, Name, Description, Price)
VALUES
    (2, 1, 'Margherita Pizza', 'Classic tomato and mozzarella cheese pizza', 10.99),
    (2, 2, 'Pepperoni Pizza', 'Pizza with pepperoni and cheese', 12.99),
    (2, 3, 'Hawian Pizza', 'Pizza with pineapple and bacon', 20.99);

-- Insert sample menu items for 'Burger Joint'
GO
INSERT INTO MenuItems (RestaurantID, MenuItemID, Name, Description, Price)
VALUES
    (3, 4, 'Classic Burger', 'Beef patty, lettuce, tomato, and mayo', 8.99),
    (3, 5, 'Veggie Burger', 'Vegetarian patty with lettuce and aioli', 9.99),
    (3, 6, 'Bruschetta','Toasted baguette slices topped with diced tomatoes, garlic, basil, and olive oil.',3.26),
    (3, 7, 'Mozzarella Sticks','Golden-fried sticks of mozzarella cheese served with marinara sauce.',8.74),
    (3, 8, 'Tomato Basil Soup','A creamy blend of ripe tomatoes, fresh basil, and a touch of cream.',8.28),
    (3, 9,'Lobster Bisque','A rich, creamy soup made with lobster meat, stock, and sherry.',5.99),
    (3, 10,'Caesar Salad','Crisp romaine lettuce, croutons, Parmesan cheese, and Caesar dressing.',9.18);

GO
INSERT INTO MenuItems (RestaurantID, MenuItemID, Name, Description, Price)
VALUES
    (4, 11,'Greek Salad','Romaine lettuce, olives, feta cheese, cucumbers, tomatoes, and Greek dressing.',3.27),
    (4, 12, 'Grilled Salmon','Fresh salmon fillet grilled to perfection, served with a lemon-dill sauce.',2.35),
    (4, 13, 'Chicken Marsala','Sautéed chicken breast in a Marsala wine and mushroom sauce.',7.25),
    (4, 14, 'Beef Tenderloin','Filet mignon cooked to your liking, served with a red wine reduction.',3.42),
    (4, 15, 'Spaghetti Carbonara','Spaghetti with pancetta, eggs, Parmesan cheese, and black pepper.',6.7);

GO
INSERT INTO MenuItems (RestaurantID, MenuItemID, Name, Description, Price)
VALUES
    (5, 16, 'Vegetable Alfredo','Fettuccine pasta with a creamy Alfredo sauce and a medley of fresh vegetables.',8.43),
    (5, 17,'Classic Cheeseburger','1/2 pound beef patty with cheddar cheese, lettuce, tomato, and pickles.',8.7),
    (5, 18, 'Mushroom Swiss Burger','Beef patty with Swiss cheese, sautéed mushrooms, and garlic aioli.',3.04),
    (5, 19, 'BLT Sandwich','Bacon, lettuce, and tomato with mayonnaise on toasted bread.',3.65),
    (5, 20, 'Club Sandwich','Triple-decker sandwich with turkey, bacon, lettuce, tomato, and mayo.',5.32);

GO
INSERT INTO MenuItems (RestaurantID, MenuItemID, Name, Description, Price)
VALUES
    (6, 21, 'Margherita Pizza','Thin-crust pizza with tomato sauce, mozzarella cheese, basil, and olive oil.',4.58),
    (6, 22, 'Pepperoni Pizza','Classic pizza topped with pepperoni and mozzarella.',3.76),
    (6, 23, 'Chocolate Lava Cake','Warm chocolate cake with a molten center, served with vanilla ice cream.',7.3),
    (6, 24, 'Tiramisu','Italian dessert made with layers of coffee-soaked ladyfingers and mascarpone cheese.',6.03),
    (6, 25, 'Mango Tango Smoothie','A refreshing blend of mango, banana, and yogurt.',5.68);

GO
INSERT INTO MenuItems (RestaurantID, MenuItemID, Name, Description, Price)
VALUES
    (7, 26, 'Espresso','A shot of strong, Italian espresso for coffee enthusiasts.',5.8),
    (7, 27, 'Seared Scallops','Plump and tender scallops seared to perfection, served with a citrus beurre blanc sauce and a garnish of microgreens.',4.88),
    (7, 28, 'Stuffed Portobello Mushrooms', 'Large Portobello mushrooms stuffed with a mixture of breadcrumbs, spinach, cheese, and herbs, baked to a golden brown and drizzled with balsamic glaze.',6.83),
    (7, 29, 'French Onion Soup', 'A classic French soup made with caramelized onions, beef broth, and melted Gruyère cheese on top of a toasted baguette slice.',2.14),
    (7, 30, 'Lemon Sorbet', 'A refreshing and tangy lemon sorbet to cleanse the palate before the main course.',3.82);
SET IDENTITY_INSERT MenuItems OFF;

---Trigger to update bill table when insert into Orderitems
GO
drop TRIGGER if exists update_bill_table
GO
create trigger update_bill_table
on OrderItems
after insert
AS
begin
    insert into Bills (Bill_UserID,OrderDate,[Status],TotalAmount)
    select i.Order_customer_ID, GETDATE(),'Pending',i.Quantity*m.Price*1.10
    from inserted as i
        join MenuItems as m on m.MenuItemID = i.MenuItemID
end

GO
SET IDENTITY_INSERT Restaurants ON;
insert into OrderItems (Order_customer_ID,MenuItemID, Quantity)
values
    (1,2,2),
    (1, 3, 2),
    (4, 15, 6),
    (5, 20, 8),
    (12, 25, 14),
    (9, 28, 16),
    (15, 12, 18),
    (8, 29, 20),
    (18, 14, 22),
    (23, 9, 24),
    (27, 7, 26),
    (21, 26, 28),
    (14, 23, 30),
    (25, 18, 30),
    (28, 11, 30),
    (7, 15, 30),
    (19, 19, 30),
    (13, 30, 30),
    (24, 3, 30),
    (10, 17, 30),
    (22, 6, 30),
    (17,22, 30),
    (20, 8, 30),
    (26, 5, 30),
    (16, 27, 30);
GO
SET IDENTITY_INSERT MenuItems OFF;

--Create a procedure that help change the password of the user
Go
Drop PROCEDURE if exists Update_user_info
GO
create PROCEDURE Update_user_info
    @user_id int,
    @new_password VARCHAR(50) = null,
    @email VARCHAR(50) = null
AS
begin
    UPDATE Users
    Set 
        User_password = isnull(@new_password,User_password),
        Email = isnull (@email,Email)
    Where UserID = @user_id
end;

---Execute the procedure
Go
EXEC Update_user_info 1,'weather', Null;
GO
exec Update_user_info 2,"wow","worldofwarcraft";

--Create a function to compute the total price of any order
GO
drop function if exists extract_bill_by_user
GO
create function extract_bill_by_user(@user_id int)
returns TABLE
as RETURN
    select b.*, u.FullName
    from Bills b 
        join Users u on b.Bill_UserID = u.UserID
    where Bill_UserID = @user_id;

---Execute the function to see the bill by user
GO
select * from extract_bill_by_user(8)

--create indexing that search for restaurant name
GO
Drop index if exists restaurant_search
on Menuitems
GO
create index restaurant_search
on MenuItems (RestaurantID)

--test out the created index by select
select *
from MenuItems
where RestaurantID = 3

--PENDING ORDERS WITH RESTAURANT NAME
DROP VIEW if exists Pending_Orders;
GO

CREATE VIEW Pending_Orders AS
SELECT 
    R.RestaurantID,
    R.Name AS RestaurantName,
    R.Phone AS RestaurantPhone,
    B.Bill_ID,
    B.OrderDate,
    B.Status,
    O.OrderItemID,
    O.MenuItemID,
    M.Name AS MenuItemName,
    M.Price,
    O.Quantity
FROM 
    Bills B
JOIN 
    OrderItems O ON B.Bill_ID = O.Order_customer_ID
JOIN 
    MenuItems M ON O.MenuItemID = M.MenuItemID
JOIN 
    Restaurants R ON M.RestaurantID = R.RestaurantID
WHERE 
    B.Status = 'Pending';
GO

SELECT * FROM Pending_Orders;

--RESTAURANTS WITH MENU ITEMS
DROP VIEW if exists RestaurantMenu;
GO

CREATE VIEW RestaurantMenu AS
SELECT 
    R.RestaurantID,
    R.Name AS RestaurantName,
    R.Phone AS RestaurantPhone,
    M.MenuItemID,
    M.Name AS MenuItemName,
    M.Description,
    M.Price
FROM 
    Restaurants R
JOIN 
    MenuItems M ON R.RestaurantID = M.RestaurantID;
GO

SELECT * FROM RestaurantMenu;

-- Find the total number of customers - AO
SELECT COUNT(*) AS TotalCustomers
FROM Users
WHERE UserType = 'Customer';

-- Calculate the average bill amount - AO
SELECT AVG(TotalAmount) AS AverageBillAmount
FROM Bills;

-- Find the most common city and state in customer addresses - AO
SELECT TOP 1
    City,
    State_code,
    COUNT(*) AS AddressCount
FROM
    Addresses
GROUP BY
    City,
    State_code
ORDER BY
    AddressCount DESC;

-- Find the restaurant with the highest average order amount - AO
WITH RestaurantAvgOrderAmount AS (
    SELECT
        R.RestaurantID,
        R.Name AS RestaurantName,
        AVG(B.TotalAmount) AS AvgOrderAmount
    FROM
        Restaurants R
    JOIN
        MenuItems M ON R.RestaurantID = M.RestaurantID
    JOIN
        OrderItems O ON M.MenuItemID = O.MenuItemID
    JOIN
        Bills B ON O.Order_customer_ID = B.Bill_ID
    GROUP BY
        R.RestaurantID, R.Name
)

SELECT TOP 1
    RestaurantID,
    RestaurantName,
    AvgOrderAmount
FROM
    RestaurantAvgOrderAmount
ORDER BY
    AvgOrderAmount DESC;

--1. How many customers that each restaurant has? 
GO
WITH restaurant_customer AS (
    SELECT r.Name, o.Order_customer_ID 
    FROM MenuItems m
    JOIN Restaurants r ON m.RestaurantID = r.RestaurantID
    JOIN OrderItems o ON m.MenuItemID = o.MenuItemID
)
SELECT name, count(*) as number_of_customer
FROM restaurant_customer
group by Name

--2. What is the total bills by restaurants? 
GO
drop view if exists Order_Menu_Bill
GO
create VIEW Order_Menu_Bill AS
(select m.*, b.TotalAmount, b.Bill_UserID
from OrderItems o 
    join Bills b on b.Bill_ID = o.Order_customer_ID
    join MenuItems m on o.MenuItemID = m.MenuItemID)

GO
select *
from Order_Menu_Bill

GO
select r.Name, sum(TotalAmount) as Total_Revenue
from Order_Menu_Bill omb
    join Restaurants r on r.RestaurantID = omb.RestaurantID
group by r.name
order by r.Name

--3. List all information of pending orders including the name of the restaurant, date of order, status, items, price...?  
GO
SELECT Status, OrderItemID, RestaurantName, OrderDate, MenuItemName, Price, Quantity
FROM Pending_Orders

--4. What is the menu of each restaurant including descriptions and price? 
GO
select r.Name, m.Name, m.[Description], m.Price
from MenuItems m
    join Restaurants r on r.RestaurantID = m.RestaurantID
order by r.Name


