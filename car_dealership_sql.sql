-- creating the tables from Car Dealership ERD

create table sales_staff(
	sales_id SERIAL primary key,
	first_name VARCHAR(150),
	last_name VARCHAR(150),
	date_of_hire DATE,
	contact_number VARCHAR(15),
	mailing_address VARCHAR(150)
);

create table vehicle_inventory(
	vehicle_id SERIAL primary key,
	make VARCHAR(100),
	model VARCHAR(150),
	year_made VARCHAR(4),
	mileage INTEGER,
	vehicle_condition VARCHAR(10),
	price_listing NUMERIC(8,2)
);

create table customers(
	customer_id SERIAL primary key,
	first_name VARCHAR(150),
	last_name VARCHAR(150),
	phone_number VARCHAR(15),
	mailing_address VARCHAR(150)
);

create table mechanics(
	mechanic_id SERIAL primary key,
	first_name VARCHAR(150),
	last_name VARCHAR(150),
	contact_number VARCHAR(15),
	mailing_address VARCHAR(150),
	date_of_hire DATE 
);

create table parts_inventory(
	inventory_id SERIAL primary key,
	part_name VARCHAR(250),
	quantity_available INTEGER,
	selling_price NUMERIC(7,2),
	cost_per_unit NUMERIC(7,2),
	supplier_name VARCHAR(250)
);

create table vehicle_sales(
	invoice_id SERIAL primary key,
	date_sold DATE,
	price_sold NUMERIC(8,2),
	sales_id INTEGER not null,
	vehicle_id INTEGER not null,
	customer_id INTEGER not null,
	foreign key(sales_id) references sales_staff(sales_id),
	foreign key(vehicle_id) references vehicle_inventory(vehicle_id),
	foreign key(customer_id) references customers(customer_id)
);

create table vehicles_serviced(
	VIN SERIAL primary key,
	make VARCHAR(150),
	model VARCHAR(150),
	year_made VARCHAR(4),
	mileage INTEGER,
	customer_id INTEGER not null,
	foreign key(customer_id) references customers(customer_id)
);

create table service_transactions(
	ticket_id SERIAL primary key,
	date_serviced DATE,
	services_completed VARCHAR(500),
	amount NUMERIC(7,2),
	inventory_id INTEGER,
	mechanic_id INTEGER not null,
	customer_id INTEGER not null,
	VIN INTEGER not null,
	foreign key(inventory_id) references parts_inventory(inventory_id),
	foreign key(mechanic_id) references mechanics(mechanic_id),
	foreign key(customer_id) references customers(customer_id),
	foreign key(VIN) references vehicles_serviced(VIN)
);


-- ***********************************************************************
--    Now creating stored functions to add data to most of the tables


-- creating stored function to add customer to their corresponding table
create or replace function add_customer(
	_customer_id INTEGER,
	_first_name VARCHAR,
	_last_name VARCHAR,
	_phone_number VARCHAR,
	_mailing_address VARCHAR
)
returns void
as $MAIN$
begin 
	insert into customers(customer_id, first_name, last_name, phone_number, mailing_address)
	VALUES(_customer_id, _first_name, _last_name, _phone_number, _mailing_address);
end;
$MAIN$
language plpgsql;


-- creating stored function to add vehicle to the vehicle inventory table
create or replace function add_vehicle(
	_vehicle_id INTEGER,
	_make VARCHAR,
	_model VARCHAR,
	_year_made VARCHAR,
	_mileage INTEGER,
	_vehicle_condition VARCHAR,
	_price_listing numeric 
)
returns void
as $MAIN$
begin 
	insert into vehicle_inventory(vehicle_id, make, model, year_made, mileage, vehicle_condition, price_listing)
	VALUES(_vehicle_id, _make, _model, _year_made, _mileage, _vehicle_condition, _price_listing);
end;
$MAIN$
language plpgsql;

-- creating stored function to add salesperson to the sales staff table
create or replace function add_salesperson(
	_sales_id INTEGER,
	_first_name VARCHAR,
	_last_name VARCHAR,
	_date_of_hire DATE,
	_contact_number VARCHAR,
	_mailing_address VARCHAR
)
returns void
as $MAIN$
begin 
	insert into sales_staff(sales_id, first_name, last_name, date_of_hire, contact_number, mailing_address)
	VALUES(_sales_id, _first_name, _last_name, _date_of_hire, _contact_number, _mailing_address);
end;
$MAIN$
language plpgsql;

--creating stored function to add mechanic to their corresponding table
create or replace function add_mechanic(
	_mechanic_id INTEGER,
	_first_name VARCHAR,
	_last_name VARCHAR,
	_contact_number VARCHAR,
	_mailing_address VARCHAR,
	_date_of_hire DATE
)
returns void
as $MAIN$
begin 
	insert into mechanics(mechanic_id, first_name, last_name, contact_number, mailing_address, date_of_hire)
	VALUES(_mechanic_id, _first_name, _last_name, _contact_number, _mailing_address, _date_of_hire);
end;
$MAIN$
language plpgsql;

--creating stored function to add a vehicle part to the inventory table 
create or replace function add_vehicle_part(
	_inventory_id INTEGER,
	_part_name VARCHAR,
	_quantity_available INTEGER,
	_selling_price numeric,
	_cost_per_unit numeric,
	_supplier_name VARCHAR
)
returns void
as $MAIN$
begin 
	insert into parts_inventory(inventory_id, part_name, quantity_available, selling_price, cost_per_unit, supplier_name)
	VALUES(_inventory_id, _part_name, _quantity_available, _selling_price, _cost_per_unit, _supplier_name);
end;
$MAIN$
language plpgsql;

-- ***************************************************************************************************************
--                   Now adding data to tables by calling the stored functions 

--adding customers
select add_customer(1001, 'Enzo', 'Lamborgazi', '212-344-7656', '2133 Appian Way, Milan, Italy');
select add_customer(1002, 'Michael', 'Jablonsky', '345-766-2335', '876 Roosevelt Drive, Buffalo, New York');
select add_customer(1003, 'Donovan', 'McNeally', '757-322-4050', '8771 Longhill Road, Williamsburg, VA');
select add_customer(1004, 'Septimus', 'Snape', '932-000-5656', '62 Crookshanks Blvd, London, England');
select add_customer(1005, 'Harwin', 'Hightower', '778-900-8721', '9009 Riverlands Road, Dublin, Ireland');




--adding vehicles for sale
select add_vehicle(101, 'Toyota', 'Avalon', '2022', 132, 'NEW', 36125.00);
select add_vehicle(102, 'Toyota', '4Runner', '2022', 234, 'NEW', 38805.00);
select add_vehicle(103, 'Toyota', 'Camry', '2022', 430, 'NEW', 29990.00);
select add_vehicle(104, 'Toyota', 'Tacoma', '2022', 871, 'NEW', 27150.00);
select add_vehicle(2001, 'Jeep', 'Grand Cherokee', '2017', 54321, 'USED', 12230.00);
select add_vehicle(2002, 'Ford', 'Fiesta', '2012', 81809, 'USED', 6550.00);



--adding salespeople to staff
select add_salesperson(1001, 'Bennett', 'Coltrane', '12/01/2014', '332-876-0900', '620 High Noon Way, Santa Fe, New Mexico');
select add_salesperson(1002, 'Rebecca', 'Murdoch', '4/15/2016', '332-900-4521', '112 Spruce Drive, Santa Fe, New Mexico');
select add_salesperson(1003, 'Darryl', 'Metchie', '6/02/2016', '332-675-2089', '2330 San Clarista Road, Santa Fe, New Mexico');
select add_salesperson(1004, 'Annie', 'Flinton', '3/28/2017', '332-876-2211', '8003 Sepulveda Blvd, Santa Fe, New Mexico');



--adding mechanics to staff
select add_mechanic(4001, 'Ronald', 'Harrow', '332-888-0934', '332 Mission Way, Santa Fe, New Mexico', '8/20/2011');
select add_mechanic(4002, 'Rip', 'Sutton', '201-344-4958', '857 Rocky Mountain Drive, Durango, Colorado', '4/12/2015');
select add_mechanic(4003, 'Devon', 'Smith', '332-453-6878', '8875 Pico Blvd, Santa Fe, New Mexico', '7/01/2017');


--adding parts to inventory table
select add_vehicle_part(1001, 'TPMS Sensor', 110, 45.99, 19.99, 'Taos Components Company');
select add_vehicle_part(4001, 'Brake Pads', 55, 89.99, 29.99, 'Aztec Automotive Supplier');
select add_vehicle_part(6001, 'Spark Plug', 86, 35.99, 10.99, 'Roberts Quality Depot');


-- **************************************************************************************************************
--                                adding data to remaining tables

-- inserting data to vehicles serviced table
insert into vehicles_serviced(
	VIN,
	make,
	model,
	year_made,
	mileage,
	customer_id
)VALUES(
	8457234,
	'Toyota',
	'Camry',
	'2011',
	104430,
	1002
);

insert into vehicles_serviced(
	VIN,
	make,
	model,
	year_made,
	mileage,
	customer_id
)VALUES(
	3742175,
	'Toyota',
	'Rav4',
	'2016',
	65322,
	1005
);


--inserting entries for vehicle sales table
insert into vehicle_sales(
	invoice_id,
	date_sold,
	price_sold,
	sales_id,
	vehicle_id,
	customer_id
)VALUES(
	100,
	'8/29/2022',
	29229.45,
	1004,
	104,
	1001
);

insert into vehicle_sales(
	invoice_id,
	date_sold,
	price_sold,
	sales_id,
	vehicle_id,
	customer_id
)VALUES(
	102,
	'9/09/2022',
	36898.21,
	1003,
	102,
	1003
);

--inserting entries for the service_transactions table
 insert into service_transactions(
 	ticket_id,
 	date_serviced,
 	services_completed,
 	amount,
 	inventory_id,
 	mechanic_id,
 	customer_id,
 	VIN
 )VALUES(
 	1001,
 	'9/15/2022',
 	'Oil Change. Checked Air Pressure in all 4 tires.',
 	37.99,
 	null,
 	4001,
 	1005,
 	3742175
 );

insert into service_transactions(
 	ticket_id,
 	date_serviced,
 	services_completed,
 	amount,
 	inventory_id,
 	mechanic_id,
 	customer_id,
 	VIN
 )VALUES(
 	1002,
 	'10/10/2022',
 	'Faulty TPMS sensors, replaced all 4. Rotated Tires and checked air pressure as well.',
 	250.87,
 	1001,
 	4002,
 	1002,
 	8457234
 );

-- *****************************************************************************************************************************
--                                 Tables all have multiple records now

select * from customers 
select * from parts_inventory 
select * from sales_staff 
select * from vehicle_inventory 
select * from service_transactions 
select * from mechanics 
select * from vehicle_sales 
select * from vehicles_serviced 

-- ***********************************************************************************************************************
--                              Dropping the functions and tables from database

drop function add_customer;
drop function add_vehicle;
drop function add_salesperson;
drop function add_mechanic;
drop function add_vehicle_part;

drop table service_transactions;
drop table vehicle_sales;
drop table vehicles_serviced;
drop table mechanics;
drop table customers;
drop table parts_inventory;
drop table sales_staff;
drop table vehicle_inventory;
 	
 	