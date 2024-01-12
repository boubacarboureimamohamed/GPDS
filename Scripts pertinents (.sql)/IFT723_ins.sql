/*
-- =========================================================================== A
-- IFT723_ins.sql
-- ---------------------------------------------------------------------------
Activité : IFT187_2023-1
Encodage : UTF-8, sans BOM; fin de ligne Unix (LF)
Plateforme : PostgreSQL 12 à 15
Responsable : Othman.El.Biyaali@USherbrooke.ca 
              Mohamed.Boubacar.Boureima@usherbrooke.ca 
              Maxime.Sourceaux@usherbrooke.ca 
              Alseny.Toumany.Soumah@usherbrooke.ca
Version : 1.0
Statut : en vigueur
Résumé : Insertion des données de test pour les tables du schéma IFT723.
-- =========================================================================== A
*/

/*
Insertion des données valides à des fins de tests unitaires pour les tables
du schéma IFT723. Les données
ne sont pas nécessairement conforme à la réalité, bien que représentatives.
*/

-- Localisation du schéma
set schema 'IFT723';

-- Insert values for Adresse_Since_VS table
INSERT INTO Adresse_Since_VS (
  code, code_since,
  appartement, appartement_since,
  rue, rue_since,
  ville, ville_since,
  region, region_since,
  code_postal, code_postal_since,
  pays, pays_since
)
VALUES
  ('A001', '2023-01-01', 10, '2023-01-01', '123 Main St', '2023-01-01', 'Montreal', '2023-01-01', 'Quebec', '2023-01-01', 'H2X 1Y6', '2023-01-01', 'Canada', '2023-01-01'),
  ('A002', '2023-01-01', 5, '2023-01-01', '456 Oak St', '2023-01-01', 'Toronto', '2023-01-01', 'Ontario', '2023-01-01', 'M5J 2R6', '2023-01-01', 'Canada', '2023-01-01'),
  ('A003', '2023-01-01', 8, '2023-01-01', '789 Pine St', '2023-01-01', 'Vancouver', '2023-01-01', 'British Columbia', '2023-01-01', 'V6E 4M7', '2023-01-01', 'Canada', '2023-01-01'),
  ('A004', '2023-01-01', 15, '2023-01-01', '987 Elm St', '2023-01-01', 'Calgary', '2023-01-01', 'Alberta', '2023-01-01', 'T2P 1L9', '2023-01-01', 'Canada', '2023-01-01');


-- Insert values for Etudiant_Since_VS table
INSERT INTO Etudiant_Since_VS (
  matricule, matricule_since,
  nom_complet, nom_complet_since,
  courriel, courriel_since,
  telephone, telephone_since,
  adresse_id, adresse_id_since
)
VALUES
  ('M001', '2023-01-01', 'John Doe', '2023-01-01', 'john.doe@email.com', '2023-01-01', '123-456-7890', '2023-01-01', 'A001', '2023-01-01'),
  ('M002', '2023-01-01', 'Jane Smith', '2023-01-01', 'jane.smith@email.com', '2023-01-01', '987-654-3210', '2023-01-01', 'A002', '2023-01-01'),
  ('M003', '2023-01-01', 'Bob Johnson', '2023-01-01', 'bob.johnson@email.com', '2023-01-01', '555-123-4567', '2023-01-01', 'A003', '2023-01-01'),
  ('M004', '2023-01-01', 'Alice Brown', '2023-01-01', 'alice.brown@email.com', '2023-01-01', '777-888-9999', '2023-01-01', 'A004', '2023-01-01');


/*
-- =========================================================================== Z
Contributeurs :
 (ELBO1901) Othman.El.Biyaali@USherbrooke.ca 
 (BOUM3688) Mohamed.Boubacar.Boureima@usherbrooke.ca 
 (SOUM3004) Maxime.Sourceaux@usherbrooke.ca 
 (SOUA2604) Alseny.Toumany.Soumah@usherbrooke.ca

Adresse, droits d'auteur et copyright :
  Département d'informatique
  Faculté des sciences
  Université de Sherbrooke
  Sherbrooke (Québec)  J1K 2R1
  Canada
-- =========================================================================== Z
*/

