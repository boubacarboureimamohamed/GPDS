DROP SCHEMA IF EXISTS "IFT723" CASCADE;


--------Définition du schéma--------
CREATE SCHEMA IF NOT EXISTS "IFT723";
SET SCHEMA 'IFT723';


--------Ajout des extensions à la BD--------
CREATE EXTENSION IF NOT EXISTS "btree_gist";


--------Définition des domaines--------
CREATE DOMAIN Estampille AS TIMESTAMP(0);--Tronqué à la seconde
CREATE TYPE TSRANGE_sec AS RANGE (subtype = Estampille);

CREATE DOMAIN Adresse_Rue AS TEXT
  CHECK (LENGTH(VALUE) <= 250); 

CREATE DOMAIN Adresse_Appartement AS INTEGER
  CHECK (VALUE >= 0);

CREATE DOMAIN Adresse_Ville AS TEXT
  CHECK (LENGTH(VALUE) <= 20);

CREATE DOMAIN Adresse_Region AS TEXT
  CHECK (LENGTH(VALUE) <= 100);

CREATE DOMAIN Adresse_CP AS TEXT
  CHECK (VALUE ~ '^[A-Za-z]\d[A-Za-z] \d[A-Za-z]\d$');

CREATE DOMAIN Adresse_Pays AS TEXT
  CHECK (LENGTH(VALUE) <= 30);
  

-- L'adresse est identifié par "code" qui possède un numéro d'appart, la rue, la ville, le region, le code postal, et le pays.
CREATE TABLE Adresse_Courante (
    adresseID INT NOT NULL,
	adresseID_since Estampille NOT NULL,

    appartement Adresse_Appartement,
    rue Adresse_Rue NOT NULL,
    ville Adresse_Ville NOT NULL,
    region Adresse_Region NOT NULL,
    code_postal Adresse_CP NOT NULL,
    pays Adresse_Pays NOT NULL,
	Localisation_since Estampille NOT NULL,
	
    CONSTRAINT Adresse_PK PRIMARY KEY (adresseID)
);


--------Adresse courante log--------
CREATE TABLE IF NOT EXISTS Adresse_Courante_Log(
    adresseID INT NOT NULL,
	adresseID_since Estampille NOT NULL,

    appartement Adresse_Appartement,
    rue Adresse_Rue NOT NULL,
    ville Adresse_Ville NOT NULL,
    region Adresse_Region NOT NULL,
    code_postal Adresse_CP NOT NULL,
    pays Adresse_Pays NOT NULL,
	Localisation_since Estampille NOT NULL,

	adresse_transaction TSRANGE_sec NOT NULL
);

CREATE INDEX IF NOT EXISTS Adresse_Courante_Log_INDEX
	ON Adresse_Courante_Log USING GIST(adresseID, adresse_transaction);


--------Adresse code validité--------
CREATE TABLE IF NOT EXISTS Adresse_adresseID_Validite(
	adresseID INT NOT NULL,
	adresseID_validite TSRANGE_sec NOT NULL
);

CREATE INDEX IF NOT EXISTS Adresse_AdresseID_Validite_INDEX
	ON Adresse_adresseID_Validite USING GIST(adresseID, adresseID_validite);

--Vérification
ALTER TABLE Adresse_adresseID_Validite
--Redondance
	ADD CONSTRAINT Adresse_adresseID_Validite_Redondance
		EXCLUDE USING GIST (adresseID WITH =, 
							adresseID_validite WITH &&);
	
--Ciconcolocution
ALTER TABLE Adresse_adresseID_Validite
	ADD CONSTRAINT Adresse_adresseID_Validite_Circonlocution
		EXCLUDE USING GIST (adresseID WITH =, 
							adresseID_validite WITH -|-);

--Contradiction
--Sans objet, pas d'attribut non clé


--------Adresse code log--------
CREATE TABLE IF NOT EXISTS Adresse_adresseID_Log(
	adresseID INT NOT NULL,
	adresseID_validite TSRANGE_sec NOT NULL,
	adresseID_transaction TSRANGE_sec NOT NULL
);

CREATE INDEX IF NOT EXISTS Adresse_adresseID_Log_INDEX
	ON Adresse_adresseID_Log USING GIST(adresseID, adresseID_validite, adresseID_transaction);


--------Adresse localisation validité--------
CREATE TABLE IF NOT EXISTS Adresse_Localisation_Validite(
	adresseID INT NOT NULL,
	
	appartement Adresse_Appartement,
    rue Adresse_Rue NOT NULL,
    ville Adresse_Ville NOT NULL,
    region Adresse_Region NOT NULL,
	code_postal Adresse_CP NOT NULL,
    pays Adresse_Pays NOT NULL,

	Localisation_validite TSRANGE_sec NOT NULL
);

CREATE INDEX IF NOT EXISTS Adresse_Localisation_Validite_INDEX
	ON Adresse_Localisation_Validite USING GIST(adresseID, Localisation_validite);

--Vérification
ALTER TABLE Adresse_Localisation_Validite
--Redondance
	ADD CONSTRAINT Adresse_Localisation_Validite_Redondance
		EXCLUDE USING GIST (adresseID WITH =,
							appartement WITH =,
							rue WITH =,
							ville WITH =,
							region WITH =,
							code_postal WITH =,
							pays WITH =,
							Localisation_validite WITH &&);
	
--Ciconcolocution
ALTER TABLE Adresse_Localisation_Validite
	ADD CONSTRAINT Adresse_Localisation_Validite_Circonlocution
		EXCLUDE USING GIST (adresseID WITH =,
							appartement WITH =,
							rue WITH =,
							ville WITH =,
							region WITH =,
							code_postal WITH =,
							pays WITH =,
							Localisation_validite WITH -|-);

--Contradiction
ALTER TABLE Adresse_Localisation_Validite
	ADD CONSTRAINT Adresse_Localisation_Validite_Contradiction
		EXCLUDE USING GIST (adresseID WITH =,
							appartement WITH <>,
							rue WITH <>,
							ville WITH <>,
							region WITH <>,
							code_postal WITH <>,
							pays WITH <>,
							Localisation_validite WITH &&);
		

--------Adresse localisation log--------
CREATE TABLE IF NOT EXISTS Adresse_Localisation_Log(
	adresseID INT NOT NULL,
	
	appartement Adresse_Appartement,
    rue Adresse_Rue NOT NULL,
    ville Adresse_Ville NOT NULL,
    region Adresse_Region NOT NULL,
	code_postal Adresse_CP NOT NULL,
    pays Adresse_Pays NOT NULL,
	
	Localisation_validite TSRANGE_sec NOT NULL,
	Localisation_transaction TSRANGE_sec NOT NULL
);

CREATE INDEX IF NOT EXISTS Adresse_Localisation_Log_INDEX
	ON Adresse_Localisation_Log USING GIST(adresseID, Localisation_validite, Localisation_transaction);
	
