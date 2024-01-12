
-- Définition du schéma
create schema if not exists "IFT723";
set schema 'IFT723';

-- DONE 2023-11-29 (ELBO1901)-(BOUM3688)-(SOUM3004)-(SOUA2604) Placer une API standardisée dans un contexte ÉMIR.
-- Adresse Courante
-- Évaluation
CREATE OR REPLACE FUNCTION adresse_courante_eva_gen(adresse_code Adresse_Code)
RETURNS TABLE (
  code Adresse_Code,
  appartement Adresse_Appartement,
  rue Adresse_Rue,
  ville Adresse_Ville,
  region Adresse_Region,
  code_postal Adresse_CP,
  pays Adresse_Pays,
  code_since Estampille,
  appartement_since Estampille,
  rue_since Estampille,
  ville_since Estampille,
  region_since Estampille,
  code_postal_since Estampille,
  pays_since Estampille
) AS $$
BEGIN
  RETURN QUERY SELECT 
    a.code, a.appartement, a.rue, a.ville, a.region, a.code_postal, a.pays, a.code_since, a.appartement_since, a.rue_since, a.ville_since, a.region_since, a.code_postal_since, a.pays_since
  FROM 
    Adresse_Courante a 
  WHERE 
    a.code = adresse_code;
END;
$$ LANGUAGE plpgsql;


-- Modification
CREATE OR REPLACE PROCEDURE adresse_courante_mod_gen_sst_exs(
  adresse_code Adresse_Code,
  adresse_appartement Adresse_Appartement,
  adresse_rue Adresse_Rue,
  adresse_ville Adresse_Ville,
  adresse_region Adresse_Region,
  adresse_code_postal Adresse_CP,
  adresse_pays Adresse_Pays
)
AS $$
BEGIN
  UPDATE Adresse_Courante SET 
    appartement = adresse_appartement,
    rue = adresse_rue,
    ville = adresse_ville,
    region = adresse_region,
    code_postal = adresse_code_postal,
    pays = adresse_pays
  WHERE code = adresse_code;
END;
$$ LANGUAGE plpgsql;


-- Insertion  
CREATE OR REPLACE PROCEDURE adresse_courante_ins_gen_sst_exs(
  adresse_code Adresse_Code,
  adresse_appartement Adresse_Appartement,
  adresse_rue Adresse_Rue,
  adresse_ville Adresse_Ville,
  adresse_region Adresse_Region,
  adresse_code_postal Adresse_CP,
  adresse_pays Adresse_Pays
)
AS $$
BEGIN
  INSERT INTO Adresse_Courante (
    code, appartement, rue, ville, region, code_postal, pays
  ) VALUES (
    adresse_code, adresse_appartement, adresse_rue, adresse_ville, adresse_region, adresse_code_postal, adresse_pays
  );
END;
$$ LANGUAGE plpgsql;


-- Retrait
CREATE OR REPLACE PROCEDURE adresse_courante_ret_gen_sst(adresse_code Adresse_Code)
AS $$
BEGIN
  DELETE FROM Adresse_Courante WHERE code = adresse_code;
END;
$$ LANGUAGE plpgsql;


-- Adresse_Code_Validite
--
-- Évaluation
CREATE OR REPLACE FUNCTION adresse_code_validite_eva_gen(adresse_code Adresse_Code)
RETURNS TABLE (
  code Adresse_Code,
  adresse_validite TSRANGE_sec
) AS $$
BEGIN
  RETURN QUERY SELECT 
    acv.code, acv.adresse_validite
  FROM 
    Adresse_Code_Validite acv 
  WHERE 
    acv.code = adresse_code;
END;
$$ LANGUAGE plpgsql;


-- Modification
CREATE OR REPLACE PROCEDURE adresse_code_validite_mod_gen_sst_exs(
  adresse_code Adresse_Code,
  adresse_validite TSRANGE_sec
)
AS $$
BEGIN
  UPDATE Adresse_Code_Validite SET 
    adresse_validite = adresse_validite
  WHERE code = adresse_code;
END;
$$ LANGUAGE plpgsql;


-- Insertion
CREATE OR REPLACE PROCEDURE adresse_code_validite_ins_gen_sst_exs(
  adresse_code Adresse_Code,
  adresse_validite TSRANGE_sec
)
AS $$
BEGIN
  INSERT INTO Adresse_Code_Validite (
    code, adresse_validite
  ) VALUES (
    adresse_code, adresse_validite
  );
END;
$$ LANGUAGE plpgsql;


-- Retrait
CREATE OR REPLACE PROCEDURE adresse_code_validite_ret_gen_sst(adresse_code Adresse_Code)
AS $$
BEGIN
  DELETE FROM Adresse_Code_Validite WHERE code = adresse_code;
END;
$$ LANGUAGE plpgsql;


-- Adresse_Courante_Log
-- Évaluation
CREATE OR REPLACE FUNCTION adresse_courante_log_eva_gen(adresse_code Adresse_Code)
RETURNS TABLE (
  code Adresse_Code,
  appartement Adresse_Appartement,
  rue Adresse_Rue,
  ville Adresse_Ville,
  region Adresse_Region,
  code_postal Adresse_CP,
  pays Adresse_Pays,
  adresse_transaction TSRANGE_sec
) AS $$
BEGIN
  RETURN QUERY SELECT 
    acl.code, acl.appartement, acl.rue, acl.ville, acl.region, acl.code_postal, acl.pays, acl.adresse_transaction
  FROM 
    Adresse_Courante_Log acl 
  WHERE 
    acl.code = adresse_code;
END;
$$ LANGUAGE plpgsql;


-- Modification
CREATE OR REPLACE PROCEDURE adresse_courante_log_mod_gen_sst_exs(
  adresse_code Adresse_Code,
  adresse_appartement Adresse_Appartement,
  adresse_rue Adresse_Rue,
  adresse_ville Adresse_Ville,
  adresse_region Adresse_Region,
  adresse_code_postal Adresse_CP,
  adresse_pays Adresse_Pays,
  adresse_transaction TSRANGE_sec
)
AS $$
BEGIN
  UPDATE Adresse_Courante_Log SET 
    appartement = adresse_appartement,
    rue = adresse_rue,
    ville = adresse_ville,
    region = adresse_region,
    code_postal = adresse_code_postal,
    pays = adresse_pays,
    adresse_transaction = adresse_transaction
  WHERE code = adresse_code;
END;
$$ LANGUAGE plpgsql;


-- Insertion
CREATE OR REPLACE PROCEDURE adresse_courante_log_ins_gen_sst_exs(
  adresse_code Adresse_Code,
  adresse_appartement Adresse_Appartement,
  adresse_rue Adresse_Rue,
  adresse_ville Adresse_Ville,
  adresse_region Adresse_Region,
  adresse_code_postal Adresse_CP,
  adresse_pays Adresse_Pays,
  adresse_transaction TSRANGE_sec
)
AS $$
BEGIN
  INSERT INTO Adresse_Courante_Log (
    code, appartement, rue, ville, region, code_postal, pays, adresse_transaction
  ) VALUES (
    adresse_code, adresse_appartement, adresse_rue, adresse_ville, adresse_region, adresse_code_postal, adresse_pays, adresse_transaction
  );
END;
$$ LANGUAGE plpgsql;


-- Retrait
CREATE OR REPLACE PROCEDURE adresse_courante_log_ret_gen_sst(adresse_code Adresse_Code)
AS $$
BEGIN
  DELETE FROM Adresse_Courante_Log WHERE code = adresse_code;
END;
$$ LANGUAGE plpgsql;


-- Adresse_Code_Log
-- Evaluation
CREATE OR REPLACE FUNCTION adresse_code_log_eva_gen(adresse_code Adresse_Code)
RETURNS TABLE (
  code Adresse_Code,
  adresse_validite TSRANGE_sec,
  adresse_transaction TSRANGE_sec
) AS $$
BEGIN
  RETURN QUERY SELECT 
    acl.code, acl.adresse_validite, acl.adresse_transaction
  FROM 
    Adresse_Code_Log acl 
  WHERE 
    acl.code = adresse_code;
END;
$$ LANGUAGE plpgsql;


-- Modification
CREATE OR REPLACE PROCEDURE adresse_code_log_mod_gen_sst_exs(
  adresse_code Adresse_Code,
  adresse_validite TSRANGE_sec,
  adresse_transaction TSRANGE_sec
)
AS $$
BEGIN
  UPDATE Adresse_Code_Log SET 
    adresse_validite = adresse_validite,
    adresse_transaction = adresse_transaction
  WHERE code = adresse_code;
END;
$$ LANGUAGE plpgsql;


-- Insertion
CREATE OR REPLACE PROCEDURE adresse_code_log_ins_gen_sst_exs(
  adresse_code Adresse_Code,
  adresse_validite TSRANGE_sec,
  adresse_transaction TSRANGE_sec
)
AS $$
BEGIN
  INSERT INTO Adresse_Code_Log (
    code, adresse_validite, adresse_transaction
  ) VALUES (
    adresse_code, adresse_validite, adresse_transaction
  );
END;
$$ LANGUAGE plpgsql;


-- Retrait
CREATE OR REPLACE PROCEDURE adresse_code_log_ret_gen_sst(adresse_code Adresse_Code)
AS $$
BEGIN
  DELETE FROM Adresse_Code_Log WHERE code = adresse_code;
END;
$$ LANGUAGE plpgsql;


-- Adresse_Rue_Ville_Region_Pays_Validite
-- Evaluation
CREATE OR REPLACE FUNCTION adresse_rue_ville_region_pays_validite_eva_gen(adresse_code Adresse_Code)
RETURNS TABLE (
  code Adresse_Code,
  rue Adresse_Rue,
  ville Adresse_Ville,
  region Adresse_Region,
  pays Adresse_Pays,
  rue_ville_region_pays_validite TSRANGE_sec
) AS $$
BEGIN
  RETURN QUERY SELECT 
    arvrpv.code, arvrpv.rue, arvrpv.ville, arvrpv.region, arvrpv.pays, arvrpv.rue_ville_region_pays_validite
  FROM 
    Adresse_Rue_Ville_Region_Pays_Validite arvrpv 
  WHERE 
    arvrpv.code = adresse_code;
END;
$$ LANGUAGE plpgsql;


-- Modification
CREATE OR REPLACE PROCEDURE adresse_rue_ville_region_pays_validite_mod_gen_sst_exs(
  adresse_code Adresse_Code,
  adresse_rue Adresse_Rue,
  adresse_ville Adresse_Ville,
  adresse_region Adresse_Region,
  adresse_pays Adresse_Pays,
  adresse_rue_ville_region_pays_validite TSRANGE_sec
)
AS $$
BEGIN
  UPDATE Adresse_Rue_Ville_Region_Pays_Validite SET 
    rue = adresse_rue,
    ville = adresse_ville,
    region = adresse_region,
    pays = adresse_pays,
    rue_ville_region_pays_validite = adresse_rue_ville_region_pays_validite
  WHERE code = adresse_code;
END;
$$ LANGUAGE plpgsql;


-- Insertion
CREATE OR REPLACE PROCEDURE adresse_rue_ville_region_pays_validite_ins_gen_sst_exs(
  adresse_code Adresse_Code,
  adresse_rue Adresse_Rue,
  adresse_ville Adresse_Ville,
  adresse_region Adresse_Region,
  adresse_pays Adresse_Pays,
  adresse_rue_ville_region_pays_validite TSRANGE_sec
)
AS $$
BEGIN
  INSERT INTO Adresse_Rue_Ville_Region_Pays_Validite (
    code, rue, ville, region, pays, rue_ville_region_pays_validite
  ) VALUES (
    adresse_code, adresse_rue, adresse_ville, adresse_region, adresse_pays, adresse_rue_ville_region_pays_validite
  );
END;
$$ LANGUAGE plpgsql;


-- Retrait
CREATE OR REPLACE PROCEDURE adresse_rue_ville_region_pays_validite_ret_gen_sst(adresse_code Adresse_Code)
AS $$
BEGIN
  DELETE FROM Adresse_Rue_Ville_Region_Pays_Validite WHERE code = adresse_code;
END;
$$ LANGUAGE plpgsql;


-- DONE 2023-11-29 (ELBO1901)-(BOUM3688)-(SOUM3004)-(SOUA2604) Placer une API standardisée dans un contexte ÉMIR.
-- Etudiant_Courante
-- Evaluation
CREATE OR REPLACE FUNCTION etudiant_courante_eva_gen(etudiant_matricule Etudiant_Matricule)
RETURNS TABLE (
  matricule Etudiant_Matricule,
  prenom nom_prenom,
  nom nom_prenom,
  courriel email,
  telephone phoneNumber,
  adresseID INT,
  matricule_since Estampille,
  nom_prenom_since Estampille,
  contact_since Estampille,
  adresseID_since Estampille
) AS $$
BEGIN
  RETURN QUERY SELECT 
    ec.matricule, ec.prenom, ec.nom, ec.courriel, ec.telephone, ec.adresseID, ec.matricule_since, ec.nom_prenom_since, ec.contact_since, ec.adresseID_since
  FROM 
    Etudiant_Courante ec 
  WHERE 
    ec.matricule = etudiant_matricule;
END;
$$ LANGUAGE plpgsql;


-- Modification
CREATE OR REPLACE PROCEDURE etudiant_courante_mod_gen_sst_exs(
  etudiant_matricule Etudiant_Matricule,
  etudiant_prenom nom_prenom,
  etudiant_nom nom_prenom,
  etudiant_courriel email,
  etudiant_telephone phoneNumber,
  etudiant_adresseID INT
)
AS $$
BEGIN
  UPDATE Etudiant_Courante SET 
    prenom = etudiant_prenom,
    nom = etudiant_nom,
    courriel = etudiant_courriel,
    telephone = etudiant_telephone,
    adresseID = etudiant_adresseID
  WHERE matricule = etudiant_matricule;
END;
$$ LANGUAGE plpgsql;


-- Insertion
CREATE OR REPLACE PROCEDURE etudiant_courante_ins_gen_sst_exs(
  etudiant_matricule Etudiant_Matricule,
  etudiant_prenom nom_prenom,
  etudiant_nom nom_prenom,
  etudiant_courriel email,
  etudiant_telephone phoneNumber,
  etudiant_adresseID INT
)
AS $$
BEGIN
  INSERT INTO Etudiant_Courante (
    matricule, prenom, nom, courriel, telephone, adresseID
  ) VALUES (
    etudiant_matricule, etudiant_prenom, etudiant_nom, etudiant_courriel, etudiant_telephone, etudiant_adresseID
  );
END;
$$ LANGUAGE plpgsql;


-- Retrait
CREATE OR REPLACE PROCEDURE etudiant_courante_ret_gen_sst(etudiant_matricule Etudiant_Matricule)
AS $$
BEGIN
  DELETE FROM Etudiant_Courante WHERE matricule = etudiant_matricule;
END;
$$ LANGUAGE plpgsql;


-- Etudiant_Matricule_Validite
-- Evaluation
CREATE OR REPLACE FUNCTION etudiant_matricule_validite_eva_gen(etudiant_matricule Etudiant_Matricule)
RETURNS TABLE (
  matricule Etudiant_Matricule,
  etudiant_validite TSRANGE_sec
) AS $$
BEGIN
  RETURN QUERY SELECT 
    emv.matricule, emv.etudiant_validite
  FROM 
    Etudiant_Matricule_Validite emv 
  WHERE 
    emv.matricule = etudiant_matricule;
END;
$$ LANGUAGE plpgsql;


-- Modification
CREATE OR REPLACE PROCEDURE etudiant_matricule_validite_mod_gen_sst_exs(
  etudiant_matricule Etudiant_Matricule,
  etudiant_validite TSRANGE_sec
)
AS $$
BEGIN
  UPDATE Etudiant_Matricule_Validite SET 
    etudiant_validite = etudiant_validite
  WHERE matricule = etudiant_matricule;
END;
$$ LANGUAGE plpgsql;


-- Insertion
CREATE OR REPLACE PROCEDURE etudiant_matricule_validite_ins_gen_sst_exs(
  etudiant_matricule Etudiant_Matricule,
  etudiant_validite TSRANGE_sec
)
AS $$
BEGIN
  INSERT INTO Etudiant_Matricule_Validite (
    matricule, etudiant_validite
  ) VALUES (
    etudiant_matricule, etudiant_validite
  );
END;
$$ LANGUAGE plpgsql;


-- Retrait
CREATE OR REPLACE PROCEDURE etudiant_matricule_validite_ret_gen_sst(etudiant_matricule Etudiant_Matricule)
AS $$
BEGIN
  DELETE FROM Etudiant_Matricule_Validite WHERE matricule = etudiant_matricule;
END;
$$ LANGUAGE plpgsql;


-- Etudiant_Courante_Log
-- Evaluation
CREATE OR REPLACE FUNCTION etudiant_courante_log_eva_gen(etudiant_matricule Etudiant_Matricule)
RETURNS TABLE (
  matricule Etudiant_Matricule,
  prenom nom_prenom,
  nom nom_prenom,
  courriel email,
  telephone phoneNumber,
  adresseID INT,
  etudiant_transaction TSRANGE_sec
) AS $$
BEGIN
  RETURN QUERY SELECT 
    ecl.matricule, ecl.prenom, ecl.nom, ecl.courriel, ecl.telephone, ecl.adresseID, ecl.etudiant_transaction
  FROM 
    Etudiant_Courante_Log ecl 
  WHERE 
    ecl.matricule = etudiant_matricule;
END;
$$ LANGUAGE plpgsql;


-- Modification
CREATE OR REPLACE PROCEDURE etudiant_courante_log_mod_gen_sst_exs(
  etudiant_matricule Etudiant_Matricule,
  etudiant_prenom nom_prenom,
  etudiant_nom nom_prenom,
  etudiant_courriel email,
  etudiant_telephone phoneNumber,
  etudiant_adresseID INT,
  etudiant_transaction TSRANGE_sec
)
AS $$
BEGIN
  UPDATE Etudiant_Courante_Log SET 
    prenom = etudiant_prenom,
    nom = etudiant_nom,
    courriel = etudiant_courriel,
    telephone = etudiant_telephone,
    adresseID = etudiant_adresseID,
    etudiant_transaction = etudiant_transaction
  WHERE matricule = etudiant_matricule;
END;
$$ LANGUAGE plpgsql;


-- Insertion
CREATE OR REPLACE PROCEDURE etudiant_courante_log_ins_gen_sst_exs(
  etudiant_matricule Etudiant_Matricule,
  etudiant_prenom nom_prenom,
  etudiant_nom nom_prenom,
  etudiant_courriel email,
  etudiant_telephone phoneNumber,
  etudiant_adresseID INT,
  etudiant_transaction TSRANGE_sec
)
AS $$
BEGIN
  INSERT INTO Etudiant_Courante_Log (
    matricule, prenom, nom, courriel, telephone, adresseID, etudiant_transaction
  ) VALUES (
    etudiant_matricule, etudiant_prenom, etudiant_nom, etudiant_courriel, etudiant_telephone, etudiant_adresseID, etudiant_transaction
  );
END;
$$ LANGUAGE plpgsql;


-- Retrait
CREATE OR REPLACE PROCEDURE etudiant_courante_log_ret_gen_sst(etudiant_matricule Etudiant_Matricule)
AS $$
BEGIN
  DELETE FROM Etudiant_Courante_Log WHERE matricule = etudiant_matricule;
END;
$$ LANGUAGE plpgsql;


-- Etudiant_Matricule_Log
-- Evaluation
CREATE OR REPLACE FUNCTION etudiant_matricule_log_eva_gen(etudiant_matricule Etudiant_Matricule)
RETURNS TABLE (
  matricule Etudiant_Matricule,
  etudiant_validite TSRANGE_sec,
  etudiant_transaction TSRANGE_sec
) AS $$
BEGIN
  RETURN QUERY SELECT 
    eml.matricule, eml.etudiant_validite, eml.etudiant_transaction
  FROM 
    Etudiant_Matricule_Log eml 
  WHERE 
    eml.matricule = etudiant_matricule;
END;
$$ LANGUAGE plpgsql;


-- Modification
CREATE OR REPLACE PROCEDURE etudiant_matricule_log_mod_gen_sst_exs(
  etudiant_matricule Etudiant_Matricule,
  etudiant_validite TSRANGE_sec,
  etudiant_transaction TSRANGE_sec
)
AS $$
BEGIN
  UPDATE Etudiant_Matricule_Log SET 
    etudiant_validite = etudiant_validite,
    etudiant_transaction = etudiant_transaction
  WHERE matricule = etudiant_matricule;
END;
$$ LANGUAGE plpgsql;


-- Insertion
CREATE OR REPLACE PROCEDURE etudiant_matricule_log_ins_gen_sst_exs(
  etudiant_matricule Etudiant_Matricule,
  etudiant_validite TSRANGE_sec,
  etudiant_transaction TSRANGE_sec
)
AS $$
BEGIN
  INSERT INTO Etudiant_Matricule_Log (
    matricule, etudiant_validite, etudiant_transaction
  ) VALUES (
    etudiant_matricule, etudiant_validite, etudiant_transaction
  );
END;
$$ LANGUAGE plpgsql;


-- Retrait
CREATE OR REPLACE PROCEDURE etudiant_matricule_log_ret_gen_sst(etudiant_matricule Etudiant_Matricule)
AS $$
BEGIN
  DELETE FROM Etudiant_Matricule_Log WHERE matricule = etudiant_matricule;
END;
$$ LANGUAGE plpgsql;


-- Etudiant_nom_prenom_Validite
-- Evaluation
CREATE OR REPLACE FUNCTION etudiant_nom_prenom_validite_eva_gen(etudiant_matricule Etudiant_Matricule)
RETURNS TABLE (
  matricule Etudiant_Matricule,
  prenom nom_prenom,
  nom nom_prenom,
  nom_prenom_validite TSRANGE_sec
) AS $$
BEGIN
  RETURN QUERY SELECT 
    enpv.matricule, enpv.prenom, enpv.nom, enpv.nom_prenom_validite
  FROM 
    Etudiant_nom_prenom_Validite enpv 
  WHERE 
    enpv.matricule = etudiant_matricule;
END;
$$ LANGUAGE plpgsql;


-- Modification
CREATE OR REPLACE PROCEDURE etudiant_nom_prenom_validite_mod_gen_sst_exs(
  etudiant_matricule Etudiant_Matricule,
  etudiant_prenom nom_prenom,
  etudiant_nom nom_prenom,
  etudiant_nom_prenom_validite TSRANGE_sec
)
AS $$
BEGIN
  UPDATE Etudiant_nom_prenom_Validite SET 
    prenom = etudiant_prenom,
    nom = etudiant_nom,
    nom_prenom_validite = etudiant_nom_prenom_validite
  WHERE matricule = etudiant_matricule;
END;
$$ LANGUAGE plpgsql;


-- Insertion
CREATE OR REPLACE PROCEDURE etudiant_nom_prenom_validite_ins_gen_sst_exs(
  etudiant_matricule Etudiant_Matricule,
  etudiant_prenom nom_prenom,
  etudiant_nom nom_prenom,
  etudiant_nom_prenom_validite TSRANGE_sec
)
AS $$
BEGIN
  INSERT INTO Etudiant_nom_prenom_Validite (
    matricule, prenom, nom, nom_prenom_validite
  ) VALUES (
    etudiant_matricule, etudiant_prenom, etudiant_nom, etudiant_nom_prenom_validite
  );
END;
$$ LANGUAGE plpgsql;


-- Retrait
CREATE OR REPLACE PROCEDURE etudiant_nom_prenom_validite_ret_gen_sst(etudiant_matricule Etudiant_Matricule)
AS $$
BEGIN
  DELETE FROM Etudiant_nom_prenom_Validite WHERE matricule = etudiant_matricule;
END;
$$ LANGUAGE plpgsql;



/* ============================================================================== Z API.sql ------------------------------------------------------------------------------ Z .Contributeurs
(ELBO1901) Othman.El.Biyaali@USherbrooke.ca 
(BOUM3688) Mohamed.Boubacar.Boureima@usherbrooke.ca 
(SOUM3004) Maxime.Sourceaux@usherbrooke.ca 
(SOUA2604) Alseny.Toumany.Soumah@usherbrooke.ca
.Droits, licences et adresses Copyright 2023-2024, GRIIS Le code est sous licence
LILIQ-R 1.1 (https://forge.gouv.qc.ca/licence/liliq-v1-1/. La documentation est sous licence
CC-BY 4.0 .
Faculté des sciences Université de Sherbrooke (Québec) J1K 2R1 CANADA
http://griis.ca
.Tâches projetées
2023-11-15 (Équipe ELBO1901) : Compléter le schéma * Compléter les contraintes.
.Tâches réalisées
2023-11-15 (Équipe ELBO1901) : Création
* CREATE TABLE Etudiant.
* avec les modules BD012 et BD100 (voir [mod]) ;
* avec les modifications apportées au standard BD190 (voir [mod]).
.Références
[mod] : 
============================================================================== Z */


