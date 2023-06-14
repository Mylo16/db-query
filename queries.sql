/*Queries that provide answers to the questions from all projects.*/

SELECT * FROM animals WHERE name LIKE '%mon%';
SELECT name FROM animals WHERE date_of_birth >= '20160101' AND date_of_birth <= '20191231';
SELECT name FROM animals WHERE neutered = true AND escape_attempts < 3;
SELECT date_of_birth FROM animals WHERE name IN ('Agmon', 'Pikachu');
SELECT name, escape_attempts FROM animals WHERE weight_kg > 10.5;
SELECT * FROM animals WHERE neutered = true;
SELECT * FROM animals WHERE name NOT IN ('Gabumon');
SELECT * FROM animals WHERE weight_kg > 10.2 AND weight_kg < 17.5;

/***** TRANSACTIONS *****/

BEGIN; 
UPDATE animals
SET species = 'unspecified'; 
SELECT species FROM animals; 
ROLLBACK;
SELECT species FROM animals;

BEGIN;
UPDATE animals SET species='pokemon' WHERE name NOT IN ('mon');
UPDATE animals SET species='digimon' WHERE name LIKE '%mon%';
COMMIT;

BEGIN;
DELETE FROM animals WHERE id >= 1;
ROLLBACK;
SELECT * FROM animals;

BEGIN;
DELETE FROM animals WHERE date_of_birth > '20220101';
SELECT * FROM animals;
SAVEPOINT SP1;
UPDATE animals SET weight_kg=-1*weight_kg;
ROLLBACK TO SP1;
SELECT * FROM animals;
UPDATE animals SET weight_kg=-1*weight_kg WHERE weight_kg<0;
COMMIT;
SELECT * FROM animals;

/***** AGGREGATE FUNCTIONS *****/

SELECT COUNT(*) FROM animals;
SELECT COUNT(escape_attempts) FROM animals GROUP BY escape_attempts HAVING escape_attempts=0;
SELECT AVG(weight_kg) FROM animals;
SELECT sum(escape_attempts) FROM animals GROUP BY neutered; /* neutered are more than none neutered */;
SELECT species, MIN(weight_kg), MAX(weight_kg) FROM animals GROUP BY species;
SELECT species, AVG(escape_attempts) FROM animals WHERE date_of_birth BETWEEN '19900101' AND '20000101' GROUP BY species;
