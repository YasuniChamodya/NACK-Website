-- DB creation --

create database if not exists nackdb;

create table if not exists customers(
cust_ID int auto_increment,
cust_name varchar(50) not null,
cust_phone varchar(9) not null,
cust_email varchar(100) not null,
cust_address varchar(150) not null,
cust_username varchar(20) not null,
cust_password varchar(20) not null,

constraint pk_customers primary key (cust_ID)
);

create table if not exists products(
prod_ID int auto_increment,
prod_name varchar(50) not null,
prod_price decimal(10,2) not null,
prod_description varchar(300),

constraint pk_products primary key (prod_ID)
);

create table if not exists shoppingCart(
cart_ID int auto_increment,
cart_custID int not null,
cart_totalPrice decimal(10,2),

constraint pk_shoppingCart primary key (cart_ID),
constraint fk_shoppingCart foreign key (cart_custID) references customers (cust_ID)
);

create table if not exists productCart(
pc_CartID int not null,
pc_prodID int not null,
pc_quantity int not null,
pc_dateTime timestamp not null default current_timestamp on update current_timestamp,

constraint pk_productCart primary key (pc_CartID,pc_prodID),
constraint fk_productCart foreign key (pc_CartID) references shoppingCart (cart_ID),
constraint fk_productCart2 foreign key (pc_prodID) references products (prod_ID)
);

create table if not exists orders(
order_ID int auto_increment,
order_custID int not null,
order_prodID int not null,
order_quantity int not null,
order_totalCost decimal(10,2) not null,

constraint pk_orders primary key (order_ID),
constraint fk_orders foreign key (order_custID) references customers (cust_ID),
constraint fk_orders2 foreign key (order_prodID) references products (prod_ID)
);


-- Data Insertion --

insert into customers (cust_name,cust_phone,cust_email,cust_address,cust_username,cust_password) values ('Nadeesh Hasintha','915783541','nadeesh96@gmail.com','Mapalagama,Galle','nadeesh96','nh@#96');
insert into customers (cust_name,cust_phone,cust_email,cust_address,cust_username,cust_password) values ('Yasuni Chamodya','915786524','yasuni98@gmail.com','Mapalagama,Galle','yasuni98','ycl@#98');

insert into products (prod_name,prod_price,prod_description) values ('Liquid Bleach',120.00,'For all your household cleaning needs use full cup of Liquid Bleach in gallon of water');
insert into products (prod_name,prod_price,prod_description) values ('Hand Wash',180.00,'For 99.9% germ protection with Tergitol');

insert into shoppingcart (cart_custID) values (1);
insert into shoppingcart (cart_custID) values (2);

insert into productcart (pc_CartID,pc_prodID,pc_quantity) values (1,1,10);
insert into productcart (pc_CartID,pc_prodID,pc_quantity) values (1,2,50);
insert into productcart (pc_CartID,pc_prodID,pc_quantity) values (2,2,12);

-- order_totalCost = product.prod_price*oders.quantity - implement this on backend --
insert into orders (order_custID,order_prodID,order_quantity,order_totalCost) values (1,2,12,9000);
insert into orders (order_custID,order_prodID,order_quantity,order_totalCost) values (2,1,10,1200);

-- Create a trigger to do this for shoppingcart table--
select sum(p.prod_price*x.pc_quantity)
from  products p, customers c, productcart x
where c.cust_ID = x.pc_CartID and p.prod_ID=x.pc_prodID
group by c.cust_ID;
