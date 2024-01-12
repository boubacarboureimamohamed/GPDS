/*
-- =========================================================================== A
-- IFT723_drop.sql
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
Résumé : Destruction des tables du schéma IFT723.
-- =========================================================================== A
*/

/*
-- =========================================================================== B
Destruction du schéma IFT723 et de tout ce qu'il contient.
Pour plus d'information, voir IFT723_cre.sql
-- =========================================================================== B
*/

drop schema if exists "IFT723" cascade;

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
-- IFT723_drop.sql
-- =========================================================================== Z
*/
