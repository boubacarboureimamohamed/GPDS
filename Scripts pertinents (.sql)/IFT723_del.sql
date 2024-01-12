/*
-- =========================================================================== A
-- IFT723_del.sql
-- ---------------------------------------------------------------------------
Activité : IFT187_2023-1
Encodage : UTF-8, sans BOM; fin de ligne Unix (LF)
Plateforme : PostgreSQL 15
Responsable : Othman.El.Biyaali@USherbrooke.ca 
              Mohamed.Boubacar.Boureima@usherbrooke.ca 
              Maxime.Sourceaux@usherbrooke.ca 
              Alseny.Toumany.Soumah@usherbrooke.ca
Version : 1.0
Statut : en vigueur
Résumé : Retrait des données des tables du schéma IFT723.
-- =========================================================================== A
*/

/*
-- =========================================================================== B
Destruction des données des tables du schéma SQA.
Pour plus d'information, voir IFT723_cre.sql

Notes de mise en oeuvre
(a) aucune.
-- =========================================================================== B
*/

-- Localisation du schéma
set schema 'IFT723';

-- Vidage des tables
delete from Adresse ;
delete from Etudiant ;

/*
-- =========================================================================== Z
Contributeurs :
  (ELBO1901) Othman.El.Biyaali@USherbrooke.ca 
  (BOUM3688) Mohamed.Boubacar.Boureima@usherbrooke.ca 
  (SOUM3004) Maxime.Sourceaux@usherbrooke.ca 
  (SOUA2604) Alseny.Toumany.Soumah@usherbrooke.ca

Adresse, droits d’auteur et copyright :
  Département d’informatique
  Faculté des sciences
  Université de Sherbrooke
  Sherbrooke (Québec)  J1K 2R1
  Canada

-- -----------------------------------------------------------------------------
-- IFT723_del.sql
-- =========================================================================== Z
*/
