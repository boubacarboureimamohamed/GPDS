SET SCHEMA 'IFT723';

--INSERT INTO Adresse_Courante (adresseID,  adresseID_since, appartement, rue, ville, region,  code_postal, pays, Localisation_since) VALUES (1, '2017-06-22 19:10:25', '2', 'testRue', 'testVille', 'Qc',  'A1A 1A1', 'CA', '2017-06-22 19:10:25');
--UPDATE Adresse_Courante SET appartement = '52' WHERE adresseID = 1;
--DELETE FROM Adresse_Courante WHERE adresseID = 1;

--INSERT INTO Adresse_adresseID_Validite (adresseID, adresseID_validite) VALUES (1, TSRANGE_sec('2017-06-22 19:10:25', '2018-06-22 19:10:25', '[)'));
--UPDATE Adresse_adresseID_Validite SET adresseID_validite = TSRANGE_sec('2015-06-22 19:10:25', '2019-06-22 19:10:25', '[)');
--DELETE FROM Adresse_adresseID_Validite WHERE adresseID = 1;

--INSERT INTO Adresse_Localisation_Validite (adresseID, appartement, rue, ville, region,  code_postal, pays, Localisation_Validite) VALUES (1, '2', 'testRue', 'testVille', 'Qc',  'A1A 1A1', 'CA', TSRANGE_sec('2017-06-22 19:10:25', '2018-06-22 19:10:25', '[)'));
--UPDATE Adresse_Localisation_Validite SET appartement = '52' WHERE adresseID = 1;
--DELETE FROM Adresse_Localisation_Validite WHERE adresseID = 1;

--CALL Adresse_adresseID_Validite_ajout_PRIVATE(1, '2017-06-22 19:10:25', '2018-06-22 19:10:25');
--CALL Adresse_adresseID_Validite_modification_PRIVATE(1, TSRANGE_sec('2017-06-22 19:10:25', '2018-06-22 19:10:25', '[)'), '2015-06-22 19:10:25', '2019-06-22 19:10:25');
--CALL Adresse_adresseID_Validite_effacer_PRIVATE(1, TSRANGE_sec('2015-06-22 19:10:25', '2019-06-22 19:10:25', '[)'));


--CALL etudiant_Localisation_validite_ajout_PRIVATE(1, '2', 'testRue', 'testVille', 'Qc', 'A1A 1A1', 'Ca', '2017-06-22 19:10:25', '2018-06-22 19:10:25');
--CALL etudiant_Localisation_validite_modification_PRIVATE(1, TSRANGE_sec('2017-06-22 19:10:25', '2018-06-22 19:10:25', '[)'), '52', 'testRue', 'testVille', 'Qc', 'A1A 1A1', 'Ca','2015-06-22 19:10:25', '2019-06-22 19:10:25');
--CALL etudiant_Localisation_validite_effacer_PRIVATE(1, TSRANGE_sec('2015-06-22 19:10:25', '2019-06-22 19:10:25', '[)'));


--Fonction d'ajout dans la table courante
--CALL Adresse_Courante_ajout_at(1, '1', 'testRue', 'testVille', 'Qc',  'A1A 1A1', 'CA', '2017-06-22 19:10:25');
--CALL Adresse_Courante_ajout_now(2, '2', 'testRue2', 'testVille2', 'Qc2',  'A2A 2A2', 'CA');

--Fonction de modification de la table courante
--CALL Adresse_Courante_modifier_Localisation_at(1, '1', 'testRue_2', 'testVille_2', 'Qc_2',  'A1A 1A1', 'CA', '2019-06-22 19:10:25');
--CALL Adresse_Courante_modifier_Localisation_now(2, '2', 'testRue2_2', 'testVille2_@', 'Qc2_2',  'A2A 2A2', 'CA');

--Fonction d'effacement de la table courante
--CALL Adresse_Courante_retrait_at(1, '2020-06-22 19:10:25');
--CALL Adresse_Courante_retrait_now(2);

--Fonction pour l'ajout dans les tables de validités
--CALL adresse_validite_ajout(1, '1', 'testRue', 'testVille', 'Qc',  'A1A 1A1', 'CA', '2016-06-22 19:10:25', '2017-06-22 19:10:25');
--CALL adresse_validite_ajout(1, '1', 'testRue', 'testVille', 'Qc',  'A1A 1A1', 'CA', '2018-06-22 19:10:25', '2019-06-22 19:10:25');

--Fonction pour forcer la résolution de données adjacentes des tables de validités
--CALL adresse_validite_ajout(1, '1', 'testRue', 'testVille', 'Qc',  'A1A 1A1', 'CA', '2017-06-22 19:10:25', '2018-06-22 19:10:25');

--Fonction pour modifier les tables de validités
CALL adresse_validite_modification(1, '1', 'testRue_2', 'testVille_2', 'Qc_2',  'A1A 1A1', 'CA', '2017-06-22 19:10:25', '2018-06-22 19:10:25');
