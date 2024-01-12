SET SCHEMA 'IFT723';

--Fonction d'ajout dans la table courante--
--CALL etudiant_courante_ajout_at('1000111000', 'max', 'S', 'maxS@test.ca', '0001112222', 1, '2016-06-22 19:10:25');
--CALL etudiant_courante_ajout_now('1000111001', 'max2', 'S', 'max2S@test.ca', '3334445555', 2);

--Fonction modification de la table courante
--CALL etudiant_courante_modifier_nom_prenom_at('1000111000', 'max_2', 'S_2', '2017-06-22 19:10:25');
--CALL etudiant_courante_modifier_nom_prenom_now('1000111001', 'max2_2', 'S_2');
--CALL etudiant_courante_modifier_contact_at('1000111000', 'maxS_2@test.ca', '6667778888', '2017-06-22 19:10:25');
--CALL etudiant_courante_modifier_contact_now('1000111001', 'max2_2S@test.ca', '1234567890');
--CALL etudiant_courante_modifier_adresseID_at('1000111000', 3, '2017-06-22 19:10:25');
--CALL etudiant_courante_modifier_adresseID_now('1000111001', 4)

--Fonction effacement dans la table courante--
--CALL etudiant_courante_retrait_at('1000111000', '2018-06-22 19:10:25');
--CALL etudiant_courante_retrait_now('1000111001');


--Fonction pour l'ajout des tables de validités
--CALL etudiant_validite_ajout('1000111000', 'max', 's', 'test@abc.ca', '1112223333', 1, '2016-06-22 19:15:25','2017-06-22 19:15:25');
--CALL etudiant_validite_ajout('1000111000', 'max', 's', 'test@abc.ca', '1112223333', 1, '2018-06-22 19:15:25','2019-06-22 19:15:25');

--Fonction pour forcer la résolution de données adjacente des tables de validités
--CALL etudiant_validite_ajout('1000111000', 'max', 's', 'test2@abc.ca', '4445556666', 2, '2017-06-22 19:15:25','2018-06-22 19:15:25');

--Fonction pour modifier des tables de validités
--CALL etudiant_validite_modification('1000111000', 'max_2', 's_2', 'test_3@abc.ca', '7778889999', 3, '2017-06-22 19:15:25','2018-06-22 19:15:25')


--Fonction pour l'effacement des tables de validités
	--Si le nouveau range est contenu dans un autre element
	--Ancien   : ==========
	--Effacer  :    ====
	--Résultat : ===    ===
--CALL etudiant_validite_ajout('1000111000', 'max', 's', 'test@abc.ca', '1112223333', 1, '2015-06-22 19:15:25','2018-06-22 19:15:25');	
--CALL etudiant_validite_effacer('1000111000', '2016-06-22 19:15:25', '2017-06-22 19:15:25');

	
	--Si des elements sont contenus dans le range
	--Ancien 1 :     ====
	--Ancien 2 :		 =====
	--Effacer  :    ===========
	--Résultat :    	
--CALL etudiant_validite_ajout('1000111000', 'max', 's', 'test@abc.ca', '1112223333', 1, '2015-06-22 19:15:25','2016-06-22 19:15:25');
--CALL etudiant_validite_ajout('1000111000', 'max', 's', 'test@abc.ca', '1112223333', 1, '2017-06-22 19:15:25','2018-06-22 19:15:25');	
--CALL etudiant_validite_effacer('1000111000', '2014-06-22 19:15:25', '2019-06-22 19:15:25');
	
	
	--S'il y a chevauchement & ne s'étend pas sur la droite
    --Ancien   : =======
	--Effacer  :      =====
	--Résultat : =====
--CALL etudiant_validite_ajout('1000111000', 'max', 's', 'test@abc.ca', '1112223333', 1, '2017-06-22 19:15:25','2019-06-22 19:15:25');	
--CALL etudiant_validite_effacer('1000111000', '2018-06-22 19:15:25', '2020-06-22 19:15:25');	
	
	
	--S'il y a chevauchement & ne s'étend pas sur la gauche
    --Ancien   :    =======
	--Effacer  : =====
	--Résultat :      =====
--CALL etudiant_validite_ajout('1000111000', 'max', 's', 'test@abc.ca', '1112223333', 1, '2017-06-22 19:15:25','2019-06-22 19:15:25');	
--CALL etudiant_validite_effacer('1000111000', '2016-06-22 19:15:25', '2018-06-22 19:15:25');	
	
	