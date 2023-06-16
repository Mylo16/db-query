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

/***** JOIN QUERIES *****/

SELECT ani.name FROM animals ani JOIN owners o ON ani.owner_id = o.id WHERE o.full_name = 'Melody Pond';
SELECT ani.name FROM animals ani JOIN species s ON ani.species_id = s.id WHERE s.name = 'Pokemon';
SELECT o.full_name, ani.name FROM owners o LEFT JOIN animals ani ON o.id = ani.owner_id;
SELECT s.name,COUNT(ani.name) FROM animals ani JOIN species s ON ani.species_id = s.id GROUP BY s.name;
SELECT ani.name FROM animals ani JOIN owners o ON ani.owner_id= o.id JOIN species s ON ani.species_id= s.id WHERE o.full_name = 'Jennifer Orwell' AND s.name = 'Digimon';
SELECT ani.name FROM animals ani JOIN owners o ON ani.owner_id = o.id WHERE o.full_name = 'Dean Winchester' AND ani.escape_attempts=0;

SELECT o.full_name, COUNT(*) AS ani_count
FROM owners o
JOIN animals a ON o.id = a.owner_id
GROUP BY o.full_name
ORDER BY ani_count DESC
LIMIT 1;

/***** MANY TO MANY RELATIONSHIP QUERIES *****/

SELECT ani.name FROM animals ani JOIN visits v ON ani.id = v.animal_id JOIN vets ve ON ve.id = v.vet_id WHERE ve.name = 'William Tatcher' ORDER BY v.visit_date DESC LIMIT 1;
SELECT COUNT(v.animal_id) FROM animals ani JOIN visits v ON ani.id = v.animal_id JOIN vets ve ON ve.id = v.vet_id WHERE ve.name = 'Stephanie Mendez';
SELECT ve.name, sp.name FROM vets ve LEFT JOIN specializations spe ON ve.id = spe.vet_id LEFT JOIN species sp ON sp.id = spe.species_id;
SELECT ani.name FROM animals ani JOIN visits v ON ani.id = v.animal_id JOIN vets ve ON ve.id = v.vet_id WHERE ve.name = 'Stephanie Mendez' AND v.visit_date BETWEEN '20200401' AND '20200830';
SELECT a.name AS animal_name, COUNT(v.animal_id) AS visit_count FROM animals a INNER JOIN visits v ON a.id = v.animal_id GROUP BY a.name ORDER BY visit_count DESC LIMIT 1;
SELECT ani.name FROM animals ani JOIN visits v ON ani.id = v.animal_id JOIN vets ve ON ve.id = v.vet_id WHERE ve.name = 'Maisy Smith' ORDER BY v.visit_date ASC LIMIT 1;
SELECT a.name AS animal_name, v.visit_date, ve.name AS vet_name FROM animals a INNER JOIN visits v ON a.id = v.animal_id INNER JOIN vets ve ON ve.id = v.vet_id ORDER BY v.visit_date DESC LIMIT 1;
SELECT COUNT(*) AS num_visits FROM visits v INNER JOIN vets ve ON ve.id = v.vet_id INNER JOIN specializations s ON ve.id = s.vet_id INNER JOIN species sp ON sp.id = s.species_id WHERE sp.id != v.animal_id;
SELECT a.species_id, COUNT(*) AS visit_count, sp.name AS species_name FROM visits v INNER JOIN vets ve ON ve.id = v.vet_id INNER JOIN animals a ON a.id = v.animal_id INNER JOIN species sp ON sp.id = a.species_id WHERE ve.name = 'Maisy Smith' GROUP BY a.species_id, sp.name ORDER BY visit_count DESC LIMIT 1;
