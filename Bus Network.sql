CREATE TABLE driver (
    driver_id INTEGER PRIMARY KEY,
    name VARCHAR(40),
    surname VARCHAR(40),
    salary DECIMAL(10, 2),
    supervisor_id INTEGER,
    FOREIGN KEY (supervisor_id) REFERENCES driver(driver_id)
);

CREATE TABLE bus (
    licence_plate VARCHAR(7) PRIMARY KEY,
    model VARCHAR(20),
    fuel_type ENUM('Petrol', 'Hybrid', 'Electric'),
    capacity INTEGER(2),
    mileage DECIMAL (8,2),
    driver_id INTEGER,
    FOREIGN KEY (driver_id) REFERENCES driver(driver_id)
);

CREATE TABLE route (
    route_no INTEGER PRIMARY KEY,
    start_point VARCHAR(100),
    end_point VARCHAR(100),
    duration INTEGER(4)
);

CREATE TABLE trip (
    trip_id INTEGER PRIMARY KEY,
    route_no INTEGER,
    licence_plate VARCHAR(7),
    trip_date INTEGER(8),  
    departure_time INTEGER(4),
    arrival_time INTEGER(4),
    FOREIGN KEY (route_no) REFERENCES route(route_no),
    FOREIGN KEY (licence_plate) REFERENCES bus(licence_plate)
);

CREATE TABLE ticket (
    ticket_id INTEGER PRIMARY KEY,
    passenger_name VARCHAR(100),
    passenger_type ENUM('Child', 'Adult', 'Senior'),
    price DECIMAL(5, 2),
    trip_id INTEGER,
    FOREIGN KEY (trip_id) REFERENCES trip(trip_id)
);

INSERT INTO driver (driver_id, name, surname, salary, supervisor_id)
VALUES
(1, 'John', 'Doe', 37000.00, NULL),
(2, 'Emily', 'Clark', 35000.00, NULL),
(3, 'David', 'Taylor', 38000.00, 1),
(4, 'Olivia', 'Johnson', 29000.00, 1),
(5, 'James', 'Brown', 33000.00, 1),
(6, 'Sarah', 'Miller', 34000.00, 1),
(7, 'Michael', 'Davis', 32000.00, 2),
(8, 'Sophia', 'Garcia', 30000.00, 2),
(9, 'Liam', 'Martinez', 31000.00, 2),
(10, 'Emma', 'Rodriguez', 30000.00, 2);

INSERT INTO bus (licence_plate, model, fuel_type, capacity, mileage, driver_id)
VALUES
('BUS1234', 'Volvo', 'Hybrid', 50, 0.00, NULL),
('BUS5678', 'Mercedes', 'Electric', 40, 0.00, NULL),
('BUS9101', 'Old Routemaster', 'Petrol', 60, 20000.00, 3),
('BUS1122', 'Ford', 'Hybrid', 55, 15000.00, 4),
('BUS3344', 'Volvo', 'Hybrid', 70, 30000.00, 5),
('BUS5566', 'Mercedes', 'Petrol', 45, 30000.00, 6),
('BUS7788', 'New Routemaster', 'Electric', 50, 65000.00, 7),
('BUS9911', 'Ford', 'Hybrid', 60, 10000.00, 8),
('BUS2233', 'Volvo', 'Electric', 40, 15000.00, 9),
('BUS4455', 'Mercedes', 'Hybrid', 55, 30000.00, 10);

INSERT INTO route (route_no, start_point, end_point, duration)
VALUES
(1, 'London', 'Manchester', 0400),
(2, 'London', 'Liverpool', 0300),
(3, 'London', 'Birmingham', 0200),
(4, 'London', 'Newcastle', 0500), 
(5, 'London', 'Sheffield', 0300), 
(6, 'London', 'Brighton', 0100),
(7, 'Manchester', 'Liverpool', 0100),  
(8, 'Manchester', 'Birmingham', 0200),  
(9, 'Liverpool', 'Birmingham', 0300),  
(10, 'Sheffield', 'Brighton', 0300);

INSERT INTO trip (trip_id, route_no, licence_plate, trip_date, departure_time, arrival_time)
VALUES
(1, 1, 'BUS9101', 20241201, 0700, 1100),
(2, 2, 'BUS1122', 20241201, 1200, 1500),
(3, 3, 'BUS3344', 20241201, 1600, 1800),
(4, 4, 'BUS7788', 20241201, 1900, 0100),
(5, 5, 'BUS3344', 20241201, 0800, 1100),
(6, 6, 'BUS5566', 20241201, 1200, 1300),
(7, 7, 'BUS7788', 20241202, 0900, 1000),
(8, 8, 'BUS9911', 20241202, 1100, 1300),
(9, 9, 'BUS2233', 20241203, 0800, 1100),
(10, 10, 'BUS4455', 20241203, 1200, 1500),
(11, 1, 'BUS5566', 20241204, 0900, NULL),
(12, 2, 'BUS7788', 20241204, 1000, NULL);

INSERT INTO ticket (ticket_id, passenger_name, passenger_type, price, trip_id)
VALUES
(1, 'Alice Smith', 'Adult', 35.00, 1),
(2, 'Alice Smith', 'Adult', 18.00, 9),
(3, 'Alice Smith', 'Adult', 25.00, 5),
(4, 'Bob Johnson', 'Child', 17.50, 1),
(5, 'Bob Johnson', 'Child', 10.00, 3),
(6, 'Catherine Taylor', 'Senior', 24.00, 2),
(7, 'Catherine Taylor', 'Senior',  4.00, 7),
(8, 'Daniel Brown', 'Adult', 35.00, 1),
(9, 'Daniel Brown', 'Adult', 18.00, 9),
(10, 'Ella Davis', 'Child', 17.50, 1),
(11, 'George Martinez', 'Adult', 30.00, 2),
(12, 'Hannah Lopez', 'Adult', 30.00, 2),
(13, 'Ian Gonzalez', 'Child', 15.00, 2),
(14, 'Jack Perez', 'Senior', 24.00, 2),
(15, 'Karen Lee', 'Adult', 20.00, 3),
(16, 'Liam Walker', 'Child', 10.00, 3),
(17, 'Megan Hall', 'Adult', 20.00, 3),
(18, 'Nathan Allen', 'Senior', 16.00, 3),
(19, 'Olivia Young', 'Adult', 18.00, 9),
(20, 'Paul Hernandez', 'Child',  9.00, 9);




SELECT * FROM driver;
SELECT * FROM bus;
SELECT * FROM route;
SELECT * FROM trip;
SELECT * FROM ticket;

-- Give drivers who made more than one trip a 10% pay rise.
UPDATE driver
SET salary = salary * 1.1
WHERE driver_id IN (
  SELECT driver_id
  FROM bus 
  WHERE licence_plate IN 
    (SELECT licence_plate
      FROM trip
      GROUP BY licence_plate
      HAVING COUNT(trip_id) > 1));

SELECT * FROM driver;

-- Trips from manchester that happen on 2st December 2024 have been delayed by an hour.
UPDATE trip 
SET departure_time = departure_time + 100, arrival_time = arrival_time + 100
WHERE trip_date = 20241202 AND route_no IN (
  SELECT route_no
  FROM route
  WHERE start_point = 'Manchester');
  
SELECT * FROM trip;

-- List all routes and the number of ticket sales. Order by most popular route first.

SELECT r.route_no, r.start_point, r.end_point, COUNT(t2.ticket_id) AS 'Sales'
FROM route r
LEFT JOIN trip t1
ON r.route_no = t1.route_no
LEFT JOIN ticket t2
ON t1.trip_id = t2.trip_id
GROUP BY r.route_no, r.start_point, r.end_point
ORDER BY COUNT(t2.ticket_id) DESC;

-- List all drivers who have a salary greater than £32,000 or drive a bus with a capacity of 50 or greater.
SELECT driver_id, name, surname
FROM driver
WHERE salary > 32000
UNION 
SELECT d.driver_id, d.name, d.surname
FROM driver d
INNER JOIN bus b
ON d.driver_id = b.driver_id
WHERE capacity >= 50;

-- List the names and surnames of drivers as Driver Name, who are assigned to a bus, and have a salary greater than the average salary.
SELECT CONCAT(d.name,' ',d.surname) AS 'Driver Name'
FROM driver d
WHERE EXISTS (SELECT 1 FROM bus b WHERE d.driver_id = b.driver_id)
AND d.salary > (SELECT AVG(salary) FROM driver);

-- List the names of passengers, the total number of trips they have taken, and the total amount they have spent on tickets. Only include passengers who have spent £50.00 or more.
SELECT t1.passenger_name, COUNT(t2.trip_id) AS 'No. of Trips', SUM(t1.price) AS 'Total'
FROM ticket t1
INNER JOIN trip t2
ON t1.trip_id = t2.trip_id
GROUP BY t1.passenger_name
HAVING SUM(t1.price) > 50.00;

-- List all passengers and the model of the bus who have been on any bus with "Routemaster" 
SELECT t1.passenger_name, b.model
FROM ticket t1
INNER JOIN trip t2
ON t1.trip_id = t2.trip_id
INNER JOIN bus b
ON t2.licence_plate = b.licence_plate
WHERE model LIKE '%Routemaster';


-- What is the total mileage of buses driven by the drivers under each supervisor's management?
SELECT DISTINCT d1.name, d1.surname, sum(b.mileage) AS 'Total Mileage'
FROM driver d1
INNER JOIN driver d2
ON d2.supervisor_id = d1.driver_id
INNER JOIN bus b
ON d2.driver_id = b.driver_id
GROUP BY d1.name, d1.surname;

-- list the driver name and surname alongside their assigned bus of trips that are currently active.
SELECT d.name, d.surname, b.licence_plate
FROM driver d
INNER JOIN bus b
ON d.driver_id = b.driver_id
INNER JOIN trip t
ON b.licence_plate = t.licence_plate
WHERE t.arrival_time IS NULL;


-- list the passenger names and trip information of passengers who rode an Electric bus between January 1st 2024 and January 4th 2024
SELECT t1.passenger_name, t2.trip_id, t2.trip_date, 
        t2.departure_time, t2.arrival_time, b.licence_plate
FROM ticket t1
INNER JOIN trip t2 
ON t1.trip_id = t2.trip_id
INNER JOIN bus b 
ON t2.licence_plate = b.licence_plate
WHERE b.licence_plate IN (
    SELECT licence_plate 
    FROM bus 
    WHERE fuel_type = 'Electric'
) 
AND t2.trip_date >= 20241201 AND t2.trip_date <= 20241203;

-- Delete buses that do not have any trips assigned to them
DELETE FROM bus
WHERE licence_plate NOT IN (SELECT licence_plate FROM trip);

SELECT * FROM bus;

-- Delete tickets from trips that had the earliest departure time
DELETE FROM ticket
WHERE trip_id IN (
  SELECT trip_id
  FROM trip
  WHERE departure_time = (SELECT MIN(departure_time) FROM trip));

SELECT * FROM ticket;
