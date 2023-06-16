/* Database schema to keep the structure of entire database. */

CREATE TABLE animals (
    name varchar(100),
    id int,
    date_of_birth date,
    escape_attempts int,
    neutered boolean,
    weight_kg decimal,
    PRIMARY KEY (id)
);

ALTER TABLE animals ADD species varchar(255);

/***** OWNERS *****/

CREATE TABLE owners (
    id INT GENERATED ALWAYS AS IDENTITY,
    full_name VARCHAR(255),
    age INT,
    PRIMARY KEY (id)
);

CREATE TABLE species (
    id INT GENERATED ALWAYS AS IDENTITY,
    name VARCHAR(255),
    PRIMARY KEY (id)
);

ALTER TABLE animals DROP species;
ALTER TABLE animals ADD species_id INT;
ALTER TABLE animals ADD CONSTRAINT SPECIES FOREIGN KEY(species_id) REFERENCES species(id);
ALTER TABLE animals ADD owner_id INT;
ALTER TABLE animals ADD CONSTRAINT OWNER FOREIGN KEY(owner_id) REFERENCES owners(id);

/***** JOIN TABLES *****/

CREATE TABLE vets(
  id INT GENERATED ALWAYS AS IDENTITY,
  name VARCHAR(255),
  age INT,
  date_of_graduation DATE,
  PRIMARY KEY(id)
);

CREATE TABLE specializations(
  species_id INT,
  vets_id INT
);

CREATE TABLE visits(
  id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  animal_id INT,
  vet_id INT,
  visit_date DATE,
  FOREIGN KEY (vet_id) REFERENCES vets(id),
  FOREIGN KEY (animal_id) REFERENCES animals(id)
);