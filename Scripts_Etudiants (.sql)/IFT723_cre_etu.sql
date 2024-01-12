-- DROP SCHEMA IF EXISTS "IFT723" CASCADE;


--------Définition du schéma--------
CREATE SCHEMA IF NOT EXISTS "IFT723";
SET SCHEMA 'IFT723';



--------Ajout des extensions à la BD--------
CREATE EXTENSION IF NOT EXISTS "btree_gist";



--------Définition des domaines--------
--CREATE DOMAIN Estampille AS TIMESTAMP(0);--Tronqué à la seconde
--CREATE TYPE TSRANGE_sec AS RANGE (subtype = Estampille);

--Pour la table étudiant--
CREATE DOMAIN nom_prenom AS TEXT
  CHECK (LENGTH(VALUE) <= 50); 

CREATE DOMAIN Etudiant_Matricule AS CHAR(10)
  CHECK (LENGTH(VALUE) = 10);

--Selon la norme HTML5
--https://dba.stackexchange.com/questions/68266/what-is-the-best-way-to-store-an-email-address-in-postgresql
CREATE DOMAIN email AS TEXT
  CHECK ( value ~ '^[a-zA-Z0-9.!#$%&''*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$' );

--Valide pour Canada et US
CREATE DOMAIN phoneNumber AS VARCHAR(10) 
	CHECK(VALUE ~ '^[0-9]{10}$');




--------Création des tables--------
--------Étudiant courante--------
CREATE TABLE IF NOT EXISTS Etudiant_Courante(
	matricule Etudiant_Matricule NOT NULL,
	matricule_since Estampille NOT NULL,
	
	prenom nom_prenom NOT NULL,
	nom nom_prenom NOT NULL,
	nom_prenom_since Estampille NOT NULL, 

	courriel email NOT NULL UNIQUE,	
	telephone phoneNumber NOT NULL,
	contact_since Estampille NOT NULL,
	
	adresseCode Adresse_Code NOT NULL,
	adresseCode_since Estampille NOT NULL,
	
	PRIMARY KEY (matricule),
	FOREIGN KEY (adresseCode) REFERENCES Adresse_Courante(code)
);

--------Étudiant courante log--------
CREATE TABLE IF NOT EXISTS Etudiant_Courante_Log(
	matricule Etudiant_Matricule NOT NULL,
	matricule_since Estampille NOT NULL,
	
	prenom nom_prenom NOT NULL,
	nom nom_prenom NOT NULL,
	nom_prenom_since Estampille NOT NULL, 

	courriel email NOT NULL,
	telephone phoneNumber NOT NULL,
	contact_since Estampille NOT NULL,
	
	adresseCode Adresse_Code NOT NULL,
	adresseCode_since Estampille NOT NULL,
	
	etudiant_transaction TSRANGE_sec NOT NULL
);

CREATE INDEX IF NOT EXISTS Etudiant_Courante_Log_INDEX
	ON Etudiant_Courante_Log USING GIST(matricule, etudiant_transaction);



--------Étudiant matricule validité--------
CREATE TABLE IF NOT EXISTS Etudiant_Matricule_Validite(
	matricule Etudiant_Matricule NOT NULL,
	etudiant_validite TSRANGE_sec NOT NULL
);

CREATE INDEX IF NOT EXISTS Etudiant_Matricule_Validite_INDEX
	ON Etudiant_Matricule_Validite USING GIST(matricule, etudiant_validite);

--Vérification
ALTER TABLE Etudiant_Matricule_Validite
--Redondance
	ADD CONSTRAINT Etudiant_Matricule_Validite_Redondance
		EXCLUDE USING GIST (matricule WITH =, 
							etudiant_validite WITH &&);
	
--Ciconcolocution
ALTER TABLE Etudiant_Matricule_Validite
	ADD CONSTRAINT Etudiant_Matricule_Validite_Circonlocution
		EXCLUDE USING GIST (matricule WITH =, 
							etudiant_validite WITH -|-);

--Contradiction
--Sans objet, pas d'attribut non clé



--------Étudiant matricule log--------
CREATE TABLE IF NOT EXISTS Etudiant_Matricule_Log(
	matricule Etudiant_Matricule NOT NULL,
	etudiant_validite TSRANGE_sec NOT NULL,
	etudiant_transaction TSRANGE_sec NOT NULL
);

CREATE INDEX IF NOT EXISTS Etudiant_Matricule_Log_INDEX
	ON Etudiant_Matricule_Log USING GIST(matricule, etudiant_validite, etudiant_transaction);



--------Étudiant nom, prénom validité--------
CREATE TABLE IF NOT EXISTS Etudiant_nom_prenom_Validite(
	matricule Etudiant_Matricule NOT NULL,
	
	prenom nom_prenom NOT NULL,
	nom nom_prenom NOT NULL,
	nom_prenom_validite TSRANGE_sec NOT NULL
);

CREATE INDEX IF NOT EXISTS Etudiant_nom_prenom_Validite_INDEX
	ON Etudiant_nom_prenom_Validite USING GIST(matricule, nom_prenom_validite);

--Vérification
ALTER TABLE Etudiant_nom_prenom_Validite
--Redondance
	ADD CONSTRAINT Etudiant_nom_prenom_Validite_Redondance
		EXCLUDE USING GIST (matricule WITH =,
							prenom WITH =,
							nom WITH =,
							nom_prenom_validite WITH &&);
	
--Ciconcolocution
ALTER TABLE Etudiant_nom_prenom_Validite
	ADD CONSTRAINT Etudiant_nom_prenom_Validite_Circonlocution
		EXCLUDE USING GIST (matricule WITH =,
							prenom WITH =,
							nom WITH =,
							nom_prenom_validite WITH -|-);

--Contradiction
ALTER TABLE Etudiant_nom_prenom_Validite
	ADD CONSTRAINT Etudiant_nom_prenom_Validite_Contradiction
		EXCLUDE USING GIST (matricule WITH =,
							prenom WITH <>,
							nom WITH <>,
							nom_prenom_validite WITH &&);
							
							
--------Étudiant nom, prénom log--------
CREATE TABLE IF NOT EXISTS Etudiant_nom_prenom_Log(
	matricule Etudiant_Matricule NOT NULL,
	
	prenom nom_prenom NOT NULL,
	nom nom_prenom NOT NULL,
	nom_prenom_validite TSRANGE_sec NOT NULL,
	nom_prenom_transaction TSRANGE_sec NOT NULL
);

CREATE INDEX IF NOT EXISTS Etudiant_nom_prenom_Log_INDEX
	ON Etudiant_nom_prenom_Log USING GIST(matricule, nom_prenom_validite, nom_prenom_transaction);
	
	
	
--------Étudiant contact validité--------
CREATE TABLE IF NOT EXISTS Etudiant_contact_Validite(
	matricule Etudiant_Matricule NOT NULL,
	
	courriel email NOT NULL,
	telephone phoneNumber NOT NULL,
	contact_validite TSRANGE_sec NOT NULL
);

CREATE INDEX IF NOT EXISTS Etudiant_contact_Validite_INDEX
	ON Etudiant_contact_Validite USING GIST(matricule, contact_validite);

--Vérification
ALTER TABLE Etudiant_contact_Validite
--Redondance
	ADD CONSTRAINT Etudiant_contact_Validite_Redondance
		EXCLUDE USING GIST (matricule WITH =,
							courriel WITH =,
							telephone WITH =,
							contact_validite WITH &&);
	
--Ciconcolocution
ALTER TABLE Etudiant_contact_Validite
	ADD CONSTRAINT Etudiant_contact_Validite_Circonlocution
		EXCLUDE USING GIST (matricule WITH =,
							courriel WITH =,
							telephone WITH =,
							contact_validite WITH -|-);

--Contradiction
ALTER TABLE Etudiant_contact_Validite
	ADD CONSTRAINT Etudiant_contact_Validite_Contradiction
		EXCLUDE USING GIST (matricule WITH =,
							courriel WITH <>,
							telephone WITH <>,
							contact_validite WITH &&);
							
							
--------Étudiant contact log--------
CREATE TABLE IF NOT EXISTS Etudiant_contact_Log(
	matricule Etudiant_Matricule NOT NULL,
	
	courriel email NOT NULL,
	telephone phoneNumber NOT NULL,
	contact_validite TSRANGE_sec NOT NULL,
	contact_transaction TSRANGE_sec NOT NULL
);

CREATE INDEX IF NOT EXISTS Etudiant_contact_Log_INDEX
	ON Etudiant_contact_Log USING GIST(matricule, contact_validite, contact_transaction);
	


--------Étudiant adresseCode validité--------
CREATE TABLE IF NOT EXISTS Etudiant_adresseCode_Validite(
	matricule Etudiant_Matricule NOT NULL,
	
	adresseCode Adresse_Code NOT NULL,
	adresseCode_validite TSRANGE_sec NOT NULL
);

CREATE INDEX IF NOT EXISTS Etudiant_adresseCode_validite_INDEX
	ON Etudiant_adresseCode_Validite USING GIST(matricule, adresseCode_validite);

--Vérification
ALTER TABLE Etudiant_adresseCode_Validite
--Redondance
	ADD CONSTRAINT Etudiant_adresseCode_Validite_Redondance
		EXCLUDE USING GIST (matricule WITH =,
							adresseCode WITH =,
							adresseCode_validite WITH &&);
	
--Ciconcolocution
ALTER TABLE Etudiant_adresseCode_Validite
	ADD CONSTRAINT Etudiant_adresseCode_Validite_Circonlocution
		EXCLUDE USING GIST (matricule WITH =,
							adresseCode WITH =,
							adresseCode_validite WITH -|-);

--Contradiction
ALTER TABLE Etudiant_adresseCode_Validite
	ADD CONSTRAINT Etudiant_adresseCode_Validite_Contradiction
		EXCLUDE USING GIST (matricule WITH =,
							adresseCode WITH <>,
							adresseCode_validite WITH &&);
							
							
--------Étudiant adresseCode log--------
CREATE TABLE IF NOT EXISTS Etudiant_adresseCode_Log(
	matricule Etudiant_Matricule NOT NULL,
	
	adresseCode INT NOT NULL,
	adresseCode_validite TSRANGE_sec NOT NULL,
	adresseCode_transaction TSRANGE_sec NOT NULL
);

CREATE INDEX IF NOT EXISTS Etudiant_adresseCode_Log_INDEX
	ON Etudiant_adresseCode_Log USING GIST(matricule, adresseCode_validite, adresseCode_transaction);