DROP TABLE assignments;
DROP TABLE animals;
DROP TABLE enclosures;
DROP TABLE staff;

CREATE TABLE staff (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255),
  employeeNumber INT
);  

CREATE TABLE enclosures (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255),
  capacity INT,
  closedForMaintenance BOOLEAN
);

CREATE TABLE animals (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255),
  type VARCHAR(255),
  age INT,
  fk_enclosure_id INT REFERENCES enclosures(id)
);  

CREATE TABLE assignments(
  id SERIAL PRIMARY KEY,
  day VARCHAR(255),
  fk_employee_id INT REFERENCES staff(id),
  fk_enclosure_id INT REFERENCES enclosures(id)
);  


INSERT INTO staff (name, employeeNumber) VALUES ('Hamza', 55);
INSERT INTO staff (name, employeeNumber) VALUES ('Amber', 13);
INSERT INTO staff (name, employeeNumber) VALUES ('Bianca', 11);
INSERT INTO staff (name, employeeNumber) VALUES ('Ben', 66);


INSERT INTO enclosures (name, capacity, closedForMaintenance) VALUES ('Wildcats', 10, FALSE);
INSERT INTO enclosures (name, capacity, closedForMaintenance) VALUES ('Birds', 30, TRUE);
INSERT INTO enclosures (name, capacity, closedForMaintenance) VALUES ('Reptiles', 20, FALSE);
INSERT INTO enclosures (name, capacity, closedForMaintenance) VALUES ('Primates', 15, FALSE);

INSERT INTO animals (name, type, age, fk_enclosure_id) VALUES ('Simba', 'Lion', 2, 1);
INSERT INTO animals (name, type, age, fk_enclosure_id) VALUES ('ShereKhan', 'Tiger', 45, 1);
INSERT INTO animals (name, type, age, fk_enclosure_id) VALUES ('Lago', 'Parrot', 12, 2);
INSERT INTO animals (name, type, age, fk_enclosure_id) VALUES ('Skipper', 'Penguin', 5, 2);
INSERT INTO animals (name, type, age, fk_enclosure_id) VALUES ('Kaa', 'Snake', 60, 3);
INSERT INTO animals (name, type, age, fk_enclosure_id) VALUES ('Oogway', 'Tortoise', 100, 3);
INSERT INTO animals (name, type, age, fk_enclosure_id) VALUES ('Harambe', 'Gorilla', 9, 4);
INSERT INTO animals (name, type, age, fk_enclosure_id) VALUES ('Julian', 'Lemur', 16, 4);

INSERT INTO assignments (day, fk_employee_id, fk_enclosure_id) VALUES ('Monday', 1, 1);
INSERT INTO assignments (day, fk_employee_id, fk_enclosure_id) VALUES ('Tuesday', 2, 2);
INSERT INTO assignments (day, fk_employee_id, fk_enclosure_id) VALUES ('Wednesday', 3, 3);
INSERT INTO assignments (day, fk_employee_id, fk_enclosure_id) VALUES ('Thursday', 4, 4);
INSERT INTO assignments (day, fk_employee_id, fk_enclosure_id) VALUES ('Friday', 1, 2);
INSERT INTO assignments (day, fk_employee_id, fk_enclosure_id) VALUES ('Saturday', 2, 4);
INSERT INTO assignments (day, fk_employee_id, fk_enclosure_id) VALUES ('Sunday', 3, 1);

-- QUERIES 

--SELECT * FROM staff;
--SELECT * FROM enclosures;
--SELECT * FROM animals;
--SELECT * FROM assignments;

-- The names of the animals in a given enclosure

SELECT (animals.name) 
FROM assignments
INNER JOIN enclosures
ON assignments.fk_enclosure_id = enclosures.id 
INNER JOIN staff
ON assignments.fk_employee_id = staff.id
INNER JOIN animals
ON enclosures.id = animals.fk_enclosure_id
WHERE enclosures.name = 'Reptiles';

-- The names of the staff working in a given enclosure

SELECT (staff.name) 
FROM assignments
INNER JOIN enclosures
ON assignments.fk_enclosure_id = enclosures.id 
INNER JOIN staff
ON assignments.fk_employee_id = staff.id
INNER JOIN animals
ON enclosures.id = animals.fk_enclosure_id
WHERE enclosures.name = 'Primates';

--The names of staff working in enclosures which are closed for maintenance

SELECT (staff.name) 
FROM assignments
INNER JOIN enclosures
ON assignments.fk_enclosure_id = enclosures.id 
INNER JOIN staff
ON assignments.fk_employee_id = staff.id
INNER JOIN animals
ON enclosures.id = animals.fk_enclosure_id
WHERE enclosures.closedForMaintenance = TRUE;

--The name of the enclosure where the oldest animal lives. If there are two animals who are the same age choose the first one alphabetically.

SELECT (enclosures.name) 
FROM assignments
INNER JOIN enclosures
ON assignments.fk_enclosure_id = enclosures.id 
INNER JOIN staff
ON assignments.fk_employee_id = staff.id
INNER JOIN animals
ON enclosures.id = animals.fk_enclosure_id
WHERE animals.age = (SELECT MAX(age) FROM animals);

--The number of different animal types a given keeper has been assigned to work with.

SELECT COUNT(DISTINCT animals.type)
FROM assignments
INNER JOIN enclosures
ON assignments.fk_enclosure_id = enclosures.id 
INNER JOIN staff
ON assignments.fk_employee_id = staff.id
INNER JOIN animals
ON enclosures.id = animals.fk_enclosure_id
WHERE staff.name = 'Amber';


--The number of different keepers who have been assigned to work in a given enclosure

SELECT COUNT(DISTINCT staff.name) 
FROM assignments
INNER JOIN enclosures
ON assignments.fk_enclosure_id = enclosures.id 
INNER JOIN staff
ON assignments.fk_employee_id = staff.id
INNER JOIN animals
ON enclosures.id = animals.fk_enclosure_id
WHERE enclosures.name = 'Birds';


--The names of the other animals sharing an enclosure with a given animal (eg. find the names of all the animals sharing the big cat field with Tony)

SELECT (animals.name) 
FROM assignments
INNER JOIN enclosures
ON assignments.fk_enclosure_id = enclosures.id 
INNER JOIN staff
ON assignments.fk_employee_id = staff.id
INNER JOIN animals
ON enclosures.id = animals.fk_enclosure_id
WHERE enclosures.id = (SELECT fk_enclosure_id FROM animals WHERE name = 'Harambe');