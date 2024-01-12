SET SCHEMA 'IFT723';

--------Fonction pour la modification des tables de validités--------
--------Permet d'ajouter dans toutes les tables de validité---------
--Si on ajoute dans seulement une seule table, c'est comme si les autres attributs étaient nul durant la période. Ce qui n'est pas permis parce que les attributs ne peuvent pas être NULL
--Donc, il faut ajouter dans toutes les tables pour la même période.
CREATE OR REPLACE PROCEDURE etudiant_validite_ajout(matricule_ Etudiant_Matricule,
													prenom_ nom_prenom, 
													nom_ nom_prenom, 
													courriel_ email, 
													telephone_ phoneNumber,
													adresseCode_ Adresse_Code,
													date_debut_ Estampille,
													date_fin_ Estampille
													)
															 
AS $$
DECLARE 
	rangeAjout TSRANGE_sec;
	rangeAdjacentGauche TSRANGE_sec;
	rangeAdjacentDroite TSRANGE_sec;
BEGIN	
	
	IF (date_debut_ >= date_fin_) THEN
		RAISE EXCEPTION 'LA DATE DE FIN DOIT ETRE APRES LA DATE DE DEBUT';
		RETURN;
	END IF;
	
	rangeAjout = TSRANGE_sec(date_debut_, date_fin_, '[)');
	
	--Vérification s'il y a un chevauchement; 
		--Si oui, on arrete la procédure : On doit passer par un update
		--Si non, on coninue.
		
	--Vérification s'il y a des tuples adjacents; 
		--Si oui, on combine les tuples.
		--Si non, on ajoute les tuples normalement. 


	--Vérification de chevauchement
		IF 
			(SELECT matricule FROM Etudiant_Matricule_Validite WHERE matricule = matricule_ AND rangeAjout && etudiant_validite) IS NOT NULL
			 OR
			(SELECT matricule FROM Etudiant_nom_prenom_Validite WHERE matricule = matricule_ AND rangeAjout && nom_prenom_validite) IS NOT NULL
			 OR
			(SELECT matricule FROM Etudiant_contact_Validite WHERE matricule = matricule_ AND rangeAjout && contact_validite) IS NOT NULL
			 OR
			(SELECT matricule FROM Etudiant_adresseCode_Validite WHERE matricule = matricule_ AND rangeAjout && adresseCode_validite) IS NOT NULL		
		THEN
			RAISE EXCEPTION 'CHEVAUCHEMENT DE DONNEES; UTILISER UN UPDATE';
			RETURN;
		END IF;	


	--Etudiant_matricule--
	--Vérification s'il y a des tuples adjacents à gauche et à droite
	SELECT etudiant_validite INTO rangeAdjacentGauche FROM Etudiant_Matricule_Validite WHERE matricule = matricule_ AND rangeAjout -|- etudiant_validite AND etudiant_validite << rangeAjout;
	SELECT etudiant_validite INTO rangeAdjacentDroite FROM Etudiant_Matricule_Validite WHERE matricule = matricule_ AND rangeAjout -|- etudiant_validite AND etudiant_validite >> rangeAjout;
	
	--S'il est entouré
	IF (rangeAdjacentGauche IS NOT NULL) AND (rangeAdjacentDroite IS NOT NULL) THEN
		CALL etudiant_matricule_validite_effacer_PRIVATE(matricule_, rangeAdjacentGauche);
		CALL etudiant_matricule_validite_effacer_PRIVATE(matricule_, rangeAdjacentDroite);
		CALL etudiant_matricule_validite_ajout_PRIVATE(matricule_, lower(rangeAdjacentGauche), upper(rangeAdjacentDroite));
		
		
	--S'il y a seulement un tuple à gauche
	ELSIF ((rangeAdjacentGauche IS NOT NULL) AND (rangeAdjacentDroite IS NULL)) THEN
		CALL etudiant_matricule_validite_effacer_PRIVATE(matricule_, rangeAdjacentGauche);
		CALL etudiant_matricule_validite_ajout_PRIVATE(matricule_, lower(rangeAdjacentGauche), date_fin_);
		
	--S'il y a seulement un tuple à droite
	ELSIF ((rangeAdjacentGauche IS NULL) AND (rangeAdjacentDroite IS NOT NULL)) THEN
		CALL etudiant_matricule_validite_effacer_PRIVATE(matricule_, rangeAdjacentDroite);
		CALL etudiant_matricule_validite_ajout_PRIVATE(matricule_, date_debut_, upper(rangeAdjacentDroite));
	
	--Il n'y a aucun tuple qui sont adjacent
	ELSE	
		CALL etudiant_matricule_validite_ajout_PRIVATE(matricule_, date_debut_, date_fin_);
		
	END IF;
	
	
	
	--Etudiant_nom_prenom--
	--Vérification s'il y a des tuples adjacents à gauche et à droite
	SELECT nom_prenom_validite INTO rangeAdjacentGauche FROM Etudiant_nom_prenom_Validite WHERE matricule = matricule_ AND prenom = prenom_ AND nom = nom_ AND rangeAjout -|- nom_prenom_validite AND nom_prenom_validite << rangeAjout;
	SELECT nom_prenom_validite INTO rangeAdjacentDroite FROM Etudiant_nom_prenom_Validite WHERE matricule = matricule_ AND prenom = prenom_ AND nom = nom_ AND rangeAjout -|- nom_prenom_validite AND nom_prenom_validite >> rangeAjout;
	
	--S'il est entouré
	IF (rangeAdjacentGauche IS NOT NULL) AND (rangeAdjacentDroite IS NOT NULL) THEN
		CALL etudiant_nom_prenom_validite_effacer_PRIVATE(matricule_, rangeAdjacentGauche);
		CALL etudiant_nom_prenom_validite_effacer_PRIVATE(matricule_, rangeAdjacentDroite);
		CALL etudiant_nom_prenom_validite_ajout_PRIVATE(matricule_, nom_, prenom_, lower(rangeAdjacentGauche), upper(rangeAdjacentDroite));
		
		
	--S'il y a seulement un tuple à gauche
	ELSIF ((rangeAdjacentGauche IS NOT NULL) AND (rangeAdjacentDroite IS NULL)) THEN
		CALL etudiant_nom_prenom_validite_effacer_PRIVATE(matricule_, rangeAdjacentGauche);
		CALL etudiant_nom_prenom_validite_ajout_PRIVATE(matricule_, nom_, prenom_, lower(rangeAdjacentGauche), date_fin_);
		
	--S'il y a seulement un tuple à droite
	ELSIF ((rangeAdjacentGauche IS NULL) AND (rangeAdjacentDroite IS NOT NULL)) THEN
		CALL etudiant_nom_prenom_validite_effacer_PRIVATE(matricule_, rangeAdjacentDroite);
		CALL etudiant_nom_prenom_validite_ajout_PRIVATE(matricule_, nom_, prenom_, date_debut_, upper(rangeAdjacentDroite));
	
	--Il n'y a aucun tuple qui sont adjacent
	ELSE	
		CALL etudiant_nom_prenom_validite_ajout_PRIVATE(matricule_, nom_, prenom_, date_debut_, date_fin_);
		
	END IF;
	
	
	
	--Etudiant_contact--
	--Vérification s'il y a des tuples adjacents à gauche et à droite
	SELECT contact_validite INTO rangeAdjacentGauche FROM Etudiant_contact_Validite WHERE matricule = matricule_ AND courriel = courriel_ AND telephone = telephone_ AND rangeAjout -|- contact_validite AND contact_validite << rangeAjout;
	SELECT contact_validite INTO rangeAdjacentDroite FROM Etudiant_contact_Validite WHERE matricule = matricule_ AND courriel = courriel_ AND telephone = telephone_ AND rangeAjout -|- contact_validite AND contact_validite >> rangeAjout;
	
	--S'il est entouré
	IF (rangeAdjacentGauche IS NOT NULL) AND (rangeAdjacentDroite IS NOT NULL) THEN
		CALL etudiant_contact_validite_effacer_PRIVATE(matricule_, rangeAdjacentGauche);
		CALL etudiant_contact_validite_effacer_PRIVATE(matricule_, rangeAdjacentDroite);
		CALL etudiant_contact_validite_ajout_PRIVATE(matricule_, courriel_, telephone_, lower(rangeAdjacentGauche), upper(rangeAdjacentDroite));
		
		
	--S'il y a seulement un tuple à gauche
	ELSIF ((rangeAdjacentGauche IS NOT NULL) AND (rangeAdjacentDroite IS NULL)) THEN
		CALL etudiant_contact_validite_effacer_PRIVATE(matricule_, rangeAdjacentGauche);
		CALL etudiant_contact_validite_ajout_PRIVATE(matricule_, courriel_, telephone_, lower(rangeAdjacentGauche), date_fin_);
		
	--S'il y a seulement un tuple à droite
	ELSIF ((rangeAdjacentGauche IS NULL) AND (rangeAdjacentDroite IS NOT NULL)) THEN
		CALL etudiant_contact_validite_effacer_PRIVATE(matricule_, rangeAdjacentDroite);
		CALL etudiant_contact_validite_ajout_PRIVATE(matricule_, courriel_, telephone_, date_debut_, upper(rangeAdjacentDroite));
	
	--Il n'y a aucun tuple qui sont adjacent
	ELSE	
		CALL etudiant_contact_validite_ajout_PRIVATE(matricule_, courriel_, telephone_, date_debut_, date_fin_);
		
	END IF;
			
			
			
	--Etudiant_adresseCode--
	--Vérification s'il y a des tuples adjacents à gauche et à droite
	SELECT adresseCode_validite INTO rangeAdjacentGauche FROM Etudiant_adresseCode_Validite WHERE matricule = matricule_ AND adresseCode = adresseCode_ AND rangeAjout -|- adresseCode_validite AND adresseCode_validite << rangeAjout;
	SELECT adresseCode_validite INTO rangeAdjacentDroite FROM Etudiant_adresseCode_Validite WHERE matricule = matricule_ AND adresseCode = adresseCode_ AND rangeAjout -|- adresseCode_validite AND adresseCode_validite >> rangeAjout;
	
	--S'il est entouré
	IF (rangeAdjacentGauche IS NOT NULL) AND (rangeAdjacentDroite IS NOT NULL) THEN
		CALL etudiant_adresseCode_validite_effacer_PRIVATE(matricule_, rangeAdjacentGauche);
		CALL etudiant_adresseCode_validite_effacer_PRIVATE(matricule_, rangeAdjacentDroite);
		CALL etudiant_adresseCode_validite_ajout_PRIVATE(matricule_, adresseCode_, lower(rangeAdjacentGauche), upper(rangeAdjacentDroite));
		
		
	--S'il y a seulement un tuple à gauche
	ELSIF ((rangeAdjacentGauche IS NOT NULL) AND (rangeAdjacentDroite IS NULL)) THEN
		CALL etudiant_adresseCode_validite_effacer_PRIVATE(matricule_, rangeAdjacentGauche);
		CALL etudiant_adresseCode_validite_ajout_PRIVATE(matricule_, adresseCode_, lower(rangeAdjacentGauche), date_fin_);
		
	--S'il y a seulement un tuple à droite
	ELSIF ((rangeAdjacentGauche IS NULL) AND (rangeAdjacentDroite IS NOT NULL)) THEN
		CALL etudiant_adresseCode_validite_effacer_PRIVATE(matricule_, rangeAdjacentDroite);
		CALL etudiant_adresseCode_validite_ajout_PRIVATE(matricule_, adresseCode_, date_debut_, upper(rangeAdjacentDroite));
	
	--Il n'y a aucun tuple qui sont adjacent
	ELSE	
		CALL etudiant_adresseCode_validite_ajout_PRIVATE(matricule_, adresseCode_, date_debut_, date_fin_);
		
	END IF;
		
END;
$$ LANGUAGE plpgsql;


--------Permet de mettre à jour toutes les tables de validité---------
--Si on modifie dans seulement une seule table, il se pourrait que certains attributs soient NULL pour certaine période, ce qui n'est pas permis parce que les attributs ne peuvent pas être NULL
--Donc, il faut modifier dans toutes les tables pour la même période.
CREATE OR REPLACE PROCEDURE etudiant_validite_modification(matricule_ Etudiant_Matricule,
														   prenom_ nom_prenom, 
														   nom_ nom_prenom, 
														   courriel_ email, 
														   telephone_ phoneNumber,
														   adresseCode_ Adresse_Code,
														   date_debut_ Estampille,
														   date_fin_ Estampille
														   )
															 
AS $$
DECLARE 

BEGIN	
	
	--Un update est l'équivalent d'effacer puis de ré-insérer
	call etudiant_validite_effacer(matricule_, date_debut_, date_fin_);
	call etudiant_validite_ajout(matricule_, prenom_, nom_, courriel_, telephone_, adresseCode_, date_debut_, date_fin_);

END;
$$ LANGUAGE plpgsql;



--------Permet d'effacer dans toutes les tables de validité---------
--Si on efface dans seulement une seule table, il se pourrait que certains attributs soient NULL pour certaine période, ce qui n'est pas permis parce que les attributs ne peuvent pas être NULL
--Donc, il faut effacer dans toutes les tables pour la même période.
CREATE OR REPLACE PROCEDURE etudiant_validite_effacer(matricule_ Etudiant_Matricule,
													  date_effacement_debut_ Estampille,
													  date_effacement_fin_ Estampille
													  )
															 
AS $$
DECLARE 
	rangeEffacement TSRANGE_sec;
	rec RECORD;
BEGIN	
	IF (date_effacement_debut_ >= date_effacement_fin_) THEN
		RAISE EXCEPTION 'LA DATE DE FIN DOIT ETRE APRES LA DATE DE DEBUT';
		RETURN;
	END IF;
	
	
	rangeEffacement = TSRANGE_sec(date_effacement_debut_, date_effacement_fin_, '[)');
		
		
	--À faire pour toutes les tables de validitées
	
	--Si le nouveau range est contenu dans un autre tuple : On sépare l'ancien tuple entre avant et après; Situation unique
	--Ancien   : ==========
	--Effacer  :    ====
	--Résultat : ===    ===
	
	--Si des elements sont contenus dans le range : On les effaces; Peut arriver sur plusieurs tuples
	--Ancien 1 :     ====
	--Ancien 2 :		 =====
	--Effacer  :    ===========
	--Résultat :    	
	
	--S'il y a chevauchement & ne s'étend pas sur la droite : On modifie l'ancien tuple jusqu'au début de l'effacement; Situation unique
    --Ancien   : =======
	--Effacer  :      =====
	--Résultat : =====
	
	--S'il y a chevauchement & ne s'étend pas sur la gauche : On modifie l'ancien tuple jusqu'à la fin de l'effacement; Situation unique
    --Ancien   :    =======
	--Effacer  : =====
	--Résultat :      =====
	
	
	
	 	------Matricule_validité------
		--Contenu dans un autre tuple--
		FOR rec IN SELECT * 
				   FROM Etudiant_Matricule_Validite 
				   WHERE matricule = matricule_ AND rangeEffacement <@ etudiant_validite
		LOOP
			CALL etudiant_matricule_validite_effacer_PRIVATE(matricule_, rec.etudiant_validite);
			CALL etudiant_matricule_validite_ajout_PRIVATE(matricule_, lower(rec.etudiant_validite), date_effacement_debut_);
			CALL etudiant_matricule_validite_ajout_PRIVATE(matricule_, date_effacement_fin_, upper(rec.etudiant_validite));
		END LOOP;
		
		
		--Element contenu dans le range--
		FOR rec IN SELECT * 
				   FROM Etudiant_Matricule_Validite 
				   WHERE matricule = matricule_ AND rangeEffacement @> etudiant_validite
		LOOP
			CALL etudiant_matricule_validite_effacer_PRIVATE(matricule_, rec.etudiant_validite);			
		END LOOP;
		
		
		
		--Chevauchement et ne s'étend pas sur la droite--
		FOR rec IN SELECT * 
				   FROM Etudiant_Matricule_Validite 
				   WHERE matricule = matricule_ AND rangeEffacement && etudiant_validite AND etudiant_validite &< rangeEffacement
		LOOP
			CALL etudiant_matricule_validite_effacer_PRIVATE(matricule_, rec.etudiant_validite);
			CALL etudiant_matricule_validite_ajout_PRIVATE(matricule_, lower(rec.etudiant_validite), date_effacement_debut_);
		END LOOP;
		
		
		--Chevauchement et ne s'étend pas sur la gauche
		FOR rec IN SELECT * 
				   FROM Etudiant_Matricule_Validite 
				   WHERE matricule = matricule_ AND rangeEffacement && etudiant_validite AND etudiant_validite &> rangeEffacement
		LOOP
			CALL etudiant_matricule_validite_effacer_PRIVATE(matricule_, rec.etudiant_validite);
			CALL etudiant_matricule_validite_ajout_PRIVATE(matricule_, date_effacement_fin_, upper(rec.etudiant_validite));
		END LOOP;
		
		
		------Nom_prenom_validité------
		--Contenu dans un autre tuple--
		FOR rec IN SELECT * 
				   FROM Etudiant_nom_prenom_Validite 
				   WHERE matricule = matricule_ AND rangeEffacement <@ nom_prenom_validite
		LOOP
			CALL etudiant_nom_prenom_validite_effacer_PRIVATE(matricule_, rec.nom_prenom_validite);
			CALL etudiant_nom_prenom_validite_ajout_PRIVATE(matricule_, rec.nom, rec.prenom, lower(rec.nom_prenom_validite), date_effacement_debut_);
			CALL etudiant_nom_prenom_validite_ajout_PRIVATE(matricule_, rec.nom, rec.prenom, date_effacement_fin_, upper(rec.nom_prenom_validite));
		END LOOP;
		
		--Element contenu dans le range--
				FOR rec IN SELECT * 
				   FROM Etudiant_nom_prenom_Validite 
				   WHERE matricule = matricule_ AND rangeEffacement @> nom_prenom_validite
		LOOP
			CALL etudiant_nom_prenom_validite_effacer_PRIVATE(matricule_, rec.nom_prenom_validite);
		END LOOP;
		
		
		--Chevauchement et ne s'étend pas sur la droite--
		FOR rec IN SELECT * 
				   FROM Etudiant_nom_prenom_Validite 
				   WHERE matricule = matricule_ AND rangeEffacement && nom_prenom_validite AND nom_prenom_validite &< rangeEffacement
		LOOP
			CALL etudiant_nom_prenom_validite_effacer_PRIVATE(matricule_, rec.nom_prenom_validite);
			CALL etudiant_nom_prenom_validite_ajout_PRIVATE(matricule_, rec.nom, rec.prenom, lower(rec.nom_prenom_validite), date_effacement_debut_);
		END LOOP;
		
		
		--Chevauchement et ne s'étend pas sur la gauche
		FOR rec IN SELECT * 
				   FROM Etudiant_nom_prenom_Validite 
				   WHERE matricule = matricule_ AND rangeEffacement && nom_prenom_validite AND nom_prenom_validite &> rangeEffacement
		LOOP
			CALL etudiant_nom_prenom_validite_effacer_PRIVATE(matricule_, rec.nom_prenom_validite);
			CALL etudiant_nom_prenom_validite_ajout_PRIVATE(matricule_, rec.nom, rec.prenom, date_effacement_fin_, upper(rec.nom_prenom_validite));
		END LOOP;
		
		
		------contact_validité------
		--Contenu dans un autre tuple--
		FOR rec IN SELECT * 
				   FROM Etudiant_contact_Validite 
				   WHERE matricule = matricule_ AND rangeEffacement <@ contact_validite
		LOOP
			CALL etudiant_contact_validite_effacer_PRIVATE(matricule_, rec.contact_validite);
			CALL etudiant_contact_validite_ajout_PRIVATE(matricule_, rec.courriel, rec.telephone, lower(rec.contact_validite), date_effacement_debut_);
			CALL etudiant_contact_validite_ajout_PRIVATE(matricule_, rec.courriel, rec.telephone, date_effacement_fin_, upper(rec.contact_validite));
		END LOOP;
			
		--Element contenu dans le range--
		FOR rec IN SELECT * 
				   FROM Etudiant_contact_Validite 
				   WHERE matricule = matricule_ AND rangeEffacement @> contact_validite
		LOOP
			CALL etudiant_contact_validite_effacer_PRIVATE(matricule_, rec.contact_validite);
		END LOOP;
		
		
		--Chevauchement et ne s'étend pas sur la droite--
		FOR rec IN SELECT * 
				   FROM Etudiant_contact_Validite 
				   WHERE matricule = matricule_ AND rangeEffacement && contact_validite AND contact_validite &< rangeEffacement
		LOOP
			CALL etudiant_contact_validite_effacer_PRIVATE(matricule_, rec.contact_validite);
			CALL etudiant_contact_validite_ajout_PRIVATE(matricule_, rec.courriel, rec.telephone, lower(rec.contact_validite), date_effacement_debut_);
		END LOOP;
		
		
		--Chevauchement et ne s'étend pas sur la gauche
		FOR rec IN SELECT * 
				   FROM Etudiant_contact_Validite 
				   WHERE matricule = matricule_ AND rangeEffacement && contact_validite AND contact_validite &> rangeEffacement
		LOOP
			CALL etudiant_contact_validite_effacer_PRIVATE(matricule_, rec.contact_validite);
			CALL etudiant_contact_validite_ajout_PRIVATE(matricule_, rec.courriel, rec.telephone, date_effacement_fin_, upper(rec.contact_validite));
		END LOOP;
		
		
		
		------adresseCode_validité------
		--Contenu dans un autre tuple--
		FOR rec IN SELECT * 
				   FROM Etudiant_adresseCode_Validite 
				   WHERE matricule = matricule_ AND rangeEffacement <@ adresseCode_validite
		LOOP
			CALL etudiant_adresseCode_validite_effacer_PRIVATE(matricule_, rec.adresseCode_validite);
			CALL etudiant_adresseCode_validite_ajout_PRIVATE(matricule_, rec.adresseCode, lower(rec.adresseCode_validite), date_effacement_debut_);
			CALL etudiant_adresseCode_validite_ajout_PRIVATE(matricule_, rec.adresseCode, date_effacement_fin_, upper(rec.adresseCode_validite));
		END LOOP;

		--Element contenu dans le range--
		FOR rec IN SELECT * 
				   FROM Etudiant_adresseCode_Validite 
				   WHERE matricule = matricule_ AND rangeEffacement @> adresseCode_validite
		LOOP
			CALL etudiant_adresseCode_validite_effacer_PRIVATE(matricule_, rec.adresseCode_validite);
		END LOOP;
		
		
		--Chevauchement et ne s'étend pas sur la droite--
		FOR rec IN SELECT * 
				   FROM Etudiant_adresseCode_Validite 
				   WHERE matricule = matricule_ AND rangeEffacement && adresseCode_validite AND adresseCode_validite &< rangeEffacement
		LOOP
			CALL etudiant_adresseCode_validite_effacer_PRIVATE(matricule_, rec.adresseCode_validite);
			CALL etudiant_adresseCode_validite_ajout_PRIVATE(matricule_, rec.adresseCode, lower(rec.adresseCode_validite), date_effacement_debut_);
		END LOOP;
		
		
		--Chevauchement et ne s'étend pas sur la gauche
		FOR rec IN SELECT * 
				   FROM Etudiant_adresseCode_Validite 
				   WHERE matricule = matricule_ AND rangeEffacement && adresseCode_validite AND adresseCode_validite &> rangeEffacement
		LOOP
			CALL etudiant_adresseCode_validite_effacer_PRIVATE(matricule_, rec.adresseCode_validite);
			CALL etudiant_adresseCode_validite_ajout_PRIVATE(matricule_, rec.adresseCode, date_effacement_fin_, upper(rec.adresseCode_validite));
		END LOOP;
		
		
		
END;
$$ LANGUAGE plpgsql;



--------Permet d'ajouter dans la table Etudiant_matricule--------
CREATE OR REPLACE PROCEDURE etudiant_matricule_validite_ajout_PRIVATE(matricule Etudiant_Matricule,
															          date_debut Estampille,
															  		  date_fin Estampille
															          )
															 
AS $$
BEGIN	

	INSERT INTO Etudiant_matricule_validite(matricule,
											etudiant_validite
										   )
		VALUES (
			matricule,
			TSRANGE_sec(date_debut, date_fin, '[)')
		);
		
END;
$$ LANGUAGE plpgsql;

--------Permet de mettre à jour un tuple dans la table Etudiant_matricule--------
CREATE OR REPLACE PROCEDURE etudiant_matricule_validite_modification_PRIVATE(matricule_ Etudiant_Matricule,
															                 range_date_initiale TSRANGE_sec,
																		     date_debut_nouveau Estampille,
																	         date_fin_nouveau Estampille
															                )
															 
AS $$
BEGIN	

	UPDATE Etudiant_matricule_validite
	SET etudiant_validite = TSRANGE_sec(date_debut_nouveau, date_fin_nouveau, '[)')
	WHERE matricule = matricule_ AND
	      etudiant_validite = range_date_initiale;
		
END;
$$ LANGUAGE plpgsql;

--------Permet d'effacer un tuple dans la table Etudiant_matricule--------
CREATE OR REPLACE PROCEDURE etudiant_matricule_validite_effacer_PRIVATE(matricule_ Etudiant_Matricule,
															            range_date TSRANGE_sec
															            )
															 
AS $$
BEGIN	

	DELETE FROM Etudiant_matricule_validite
	WHERE matricule = matricule_ AND
	      etudiant_validite = range_date;
		
END;
$$ LANGUAGE plpgsql;


--------Permet d'ajouter dans la table Etudiant_nom_prenom--------
CREATE OR REPLACE PROCEDURE etudiant_nom_prenom_validite_ajout_PRIVATE(matricule Etudiant_Matricule,
															           nom nom_prenom,
															           prenom nom_prenom,
															           date_debut Estampille,
															           date_fin Estampille
															          )
															 
AS $$
BEGIN	

	INSERT INTO Etudiant_nom_prenom_validite(matricule,
											 nom,
											 prenom,
											 nom_prenom_validite
										    )
		VALUES (
			matricule,
			nom,
			prenom,
			TSRANGE_sec(date_debut, date_fin, '[)')
		);
		
END;
$$ LANGUAGE plpgsql;


--------Permet de mettre à jour un tuple dans la table Etudiant_nom_prenom--------
CREATE OR REPLACE PROCEDURE etudiant_nom_prenom_validite_modification_PRIVATE(matricule_ Etudiant_Matricule,
															                  range_date_initiale TSRANGE_sec,
																			  nom_nouveau nom_prenom,
																			  prenom_nouveau nom_prenom,
																		      date_debut_nouveau Estampille,
																	          date_fin_nouveau Estampille
															                 )
															 
AS $$
BEGIN	

	UPDATE Etudiant_nom_prenom_validite
	SET nom = nom_nouveau,
		prenom = prenom_nouveau,
	    nom_prenom_validite = TSRANGE_sec(date_debut_nouveau, date_fin_nouveau, '[)')
	WHERE matricule = matricule_ AND
	      nom_prenom_validite = range_date_initiale;
		
END;
$$ LANGUAGE plpgsql;

--------Permet d'effacer un tuple dans la table Etudiant_nom_prenom--------
CREATE OR REPLACE PROCEDURE etudiant_nom_prenom_validite_effacer_PRIVATE(matricule_ Etudiant_Matricule,
															             range_date TSRANGE_sec
															             )
															 
AS $$
BEGIN	

	DELETE FROM Etudiant_nom_prenom_validite
	WHERE matricule = matricule_ AND
	      nom_prenom_validite = range_date;
		
END;
$$ LANGUAGE plpgsql;

--------Permet d'ajouter dans la table de Etudiant_contact--------
CREATE OR REPLACE PROCEDURE etudiant_contact_validite_ajout_PRIVATE(matricule Etudiant_Matricule,
															        courriel email,
															        telephone phoneNumber,
															        date_debut Estampille,
															        date_fin Estampille
														        	)
															 
AS $$
BEGIN	

	INSERT INTO Etudiant_contact_validite(matricule,
											 courriel,
											 telephone,
											 contact_validite
										    )
		VALUES (
			matricule,
			courriel,
			telephone,
			TSRANGE_sec(date_debut, date_fin, '[)')
		);
		
END;
$$ LANGUAGE plpgsql;


--------Permet de mettre à jour un tuple dans la table Etudiant_contact--------
CREATE OR REPLACE PROCEDURE etudiant_contact_validite_modification_PRIVATE(matricule_ Etudiant_Matricule,
															               range_date_initiale TSRANGE_sec,
																		   courriel_nouveau email,
																		   telephone_nouveau phoneNumber,
																		   date_debut_nouveau Estampille,
																	       date_fin_nouveau Estampille
															               )
															 
AS $$
BEGIN	

	UPDATE Etudiant_contact_validite
	SET courriel = courriel_nouveau,
		telephone = telephone_nouveau,
	    contact_validite = TSRANGE_sec(date_debut_nouveau, date_fin_nouveau, '[)')
	WHERE matricule = matricule_ AND
	      contact_validite = range_date_initiale;
		
END;
$$ LANGUAGE plpgsql;

--------Permet d'effacer un tuple dans la table Etudiant_contact--------
CREATE OR REPLACE PROCEDURE etudiant_contact_validite_effacer_PRIVATE(matricule_ Etudiant_Matricule,
															          range_date TSRANGE_sec
															          )
															 
AS $$
BEGIN	

	DELETE FROM Etudiant_contact_validite
	WHERE matricule = matricule_ AND
	      contact_validite = range_date;
		
END;
$$ LANGUAGE plpgsql;


--------Permet d'ajouter dans la table Etudiant_adresseCode--------
CREATE OR REPLACE PROCEDURE etudiant_adresseCode_validite_ajout_PRIVATE(matricule Etudiant_Matricule,
															          adresseCode Adresse_Code,
															          date_debut Estampille,
															          date_fin Estampille
															          )
															 
AS $$
BEGIN	

	INSERT INTO Etudiant_adresseCode_validite(matricule,
										  adresseCode,
										  adresseCode_validite
										  )
		VALUES (
			matricule,
			adresseCode,
			TSRANGE_sec(date_debut, date_fin, '[)')
		);
		
END;
$$ LANGUAGE plpgsql;


--------Permet de mettre à jour un tuple dans la table Etudiant_adresseCode--------
CREATE OR REPLACE PROCEDURE etudiant_adresseCode_validite_modification_PRIVATE(matricule_ Etudiant_Matricule,
															                  range_date_initiale TSRANGE_sec,
																			  adresseCode_nouveau Adresse_Code,
																		      date_debut_nouveau Estampille,
																	          date_fin_nouveau Estampille
															                 )
															 
AS $$
BEGIN	

	UPDATE Etudiant_adresseCode_validite
	SET adresseCode = adresseCode_nouveau,
	    adresseCode_validite = TSRANGE_sec(date_debut_nouveau, date_fin_nouveau, '[)')
	WHERE matricule = matricule_ AND
	      adresseCode_validite = range_date_initiale;
		
END;
$$ LANGUAGE plpgsql;

--------Permet d'effacer un tuple dans la table Etudiant_adresseCode--------
CREATE OR REPLACE PROCEDURE etudiant_adresseCode_validite_effacer_PRIVATE(matricule_ Etudiant_Matricule,
															            range_date TSRANGE_sec
															            )
															 
AS $$
BEGIN	

	DELETE FROM Etudiant_adresseCode_validite
	WHERE matricule = matricule_ AND
	      adresseCode_validite = range_date;
		
END;
$$ LANGUAGE plpgsql;




-------------------------------------------------------
--------Permet d'ajouter dans la table courante--------
--------Permet d'ajouter à un moment précis--------
CREATE OR REPLACE PROCEDURE etudiant_courante_ajout_at(matricule_ Etudiant_Matricule,
													  prenom_ nom_prenom, 
													  nom_ nom_prenom, 
													  courriel_ email, 
													  telephone_ phoneNumber,
													  adresseCode_ Adresse_Code,
													  date_ajout_ Estampille
													  )
AS $$
BEGIN	

	--On vérifie que la date d'ajout est plus grande que les dates pour la même clé dans les tables de validité
	--On ne peut pas ajouter un tuple valide qui est plus vieux qu'un tuple fermé
	--TO DO
	
	INSERT INTO Etudiant_Courante(matricule,
								  matricule_since, 
								  prenom,
								  nom,
								  nom_prenom_since,
								  courriel, 
								  telephone,
								  contact_since,
								  adresseCode,
								  adresseCode_since
								  )
		VALUES (
			matricule_,
			date_ajout_,
			prenom_,
			nom_,
			date_ajout_,
			courriel_,
			telephone_,
			date_ajout_,
			adresseCode_,
			date_ajout_
		);
		
END;
$$ LANGUAGE plpgsql;


--------Permet d'ajouter maintenant--------
CREATE OR REPLACE PROCEDURE etudiant_courante_ajout_now(matricule_ Etudiant_Matricule,
													  	prenom_ nom_prenom, 
													  	nom_ nom_prenom, 
													  	courriel_ email, 
													  	telephone_	phoneNumber,
													  	adresseCode_ Adresse_Code
													  	)
AS $$
BEGIN	
	
	CALL etudiant_courante_ajout_at(matricule_, 
									prenom_, 
									nom_, 
									courriel_, 
									telephone_, 
									adresseCode_, 
									NOW()::Estampille);

END;
$$ LANGUAGE plpgsql;



--Permet de modifier le nom ou le prénom dans la table courante--
--Permet de modifier à un moment précis
CREATE OR REPLACE PROCEDURE etudiant_courante_modifier_nom_prenom_at(matricule_ Etudiant_Matricule,
													  				 prenom_ nom_prenom, 
													  				 nom_ nom_prenom, 
													  				 date_changement Estampille
													  	            )
AS $$
DECLARE
	prenom_avant nom_prenom;
	nom_avant nom_prenom;
	nom_prenom_since_avant Estampille;
BEGIN	
	
	--La date de retrait ne peut qu'être après la date initiale
	SELECT prenom, nom, nom_prenom_since INTO prenom_avant, nom_avant, nom_prenom_since_avant 
	FROM etudiant_courante WHERE matricule = matricule_;
	
	IF (nom_prenom_since_avant >= date_changement) THEN
		RAISE EXCEPTION 'LA DATE DOIT ETRE APRES LA DATE COURANTE';
		RETURN;
	END IF;
	
	--Sauvegarde de l'ancienne valeur dans la table de validité
	CALL etudiant_nom_prenom_validite_ajout_PRIVATE(matricule_,
											        nom_avant,
											        prenom_avant,
											        nom_prenom_since_avant,
											        date_changement);
													
	--Modification dans la table courante
	UPDATE Etudiant_Courante SET prenom = prenom_, nom = nom_, nom_prenom_since = date_changement  WHERE matricule = matricule_;
	
END;
$$ LANGUAGE plpgsql;


--Permet de modifier maintenant
CREATE OR REPLACE PROCEDURE etudiant_courante_modifier_nom_prenom_now(matricule_ Etudiant_Matricule,
													  				  prenom_ nom_prenom, 
													  				  nom_ nom_prenom 
													  	             )
AS $$
BEGIN	
	
	CALL etudiant_courante_modifier_nom_prenom_at(matricule_,
												  prenom_, 
												  nom_, 
												  NOW()::Estampille
												  );
	
END;
$$ LANGUAGE plpgsql;




--Permet de modifier les informations de contact dans la table courante--
--Permet de modifier à un moment précis
CREATE OR REPLACE PROCEDURE etudiant_courante_modifier_contact_at(matricule_ Etudiant_Matricule,
													  			  courriel_ email, 
													  			  telephone_ phoneNumber, 
													  			  date_changement Estampille
													  	          )
AS $$
DECLARE
	courriel_avant email;
	telephone_avant phoneNumber;
	contact_since_avant Estampille;
BEGIN	
	
	--La date de retrait ne peut qu'être après la date initiale
	SELECT courriel, telephone, contact_since INTO courriel_avant, telephone_avant, contact_since_avant 
	FROM etudiant_courante WHERE matricule = matricule_;
	
	IF (contact_since_avant >= date_changement) THEN
		RAISE EXCEPTION 'LA DATE DOIT ETRE APRES LA DATE COURANTE';
		RETURN;
	END IF;
	
	--Sauvegarde de l'ancienne valeur dans la table de validité
	CALL etudiant_contact_validite_ajout_PRIVATE(matricule_,
											     courriel_avant,
											     telephone_avant,
											     contact_since_avant,
											     date_changement);
													
	--Modification dans la table courante
	UPDATE Etudiant_Courante SET courriel = courriel_, telephone = telephone_, contact_since = date_changement  WHERE matricule = matricule_;
	
END;
$$ LANGUAGE plpgsql;


--Permet de modifier maintenant
CREATE OR REPLACE PROCEDURE etudiant_courante_modifier_contact_now(matricule_ Etudiant_Matricule,
													  			   courriel_ email, 
													  			   telephone_ phoneNumber
													  	           )
AS $$
BEGIN	
	
	CALL etudiant_courante_modifier_contact_at(matricule_,
											   courriel_, 
											   telephone_, 
											   NOW()::Estampille
											   );
	
END;
$$ LANGUAGE plpgsql;


--Permet de modifier l'adresseCode dans la table courante--
--Permet de modifier à un moment précis
CREATE OR REPLACE PROCEDURE etudiant_courante_modifier_adresseCode_at(matricule_ Etudiant_Matricule,
													  			    adresseCode_ Adresse_Code, 
													  			    date_changement Estampille
													  	            )
AS $$
DECLARE
	adresseCode_avant Adresse_Code;
	adresseCode_since_avant Estampille;
BEGIN	
	
	--La date de retrait ne peut qu'être après la date initiale
	SELECT adresseCode, adresseCode_since INTO adresseCode_avant, adresseCode_since_avant FROM etudiant_courante WHERE matricule = matricule_;
	
	IF (adresseCode_since_avant >= date_changement) THEN
		RAISE EXCEPTION 'LA DATE DOIT ETRE APRES LA DATE COURANTE';
		RETURN;
	END IF;
	
	--Sauvegarde de l'ancienne valeur dans la table de validité
	CALL etudiant_adresseCode_validite_ajout_PRIVATE(matricule_,
											       adresseCode_avant,
											       adresseCode_since_avant,
											       date_changement);
													
	--Modification dans la table courante
	UPDATE Etudiant_Courante SET adresseCode = adresseCode_, adresseCode_since = date_changement  WHERE matricule = matricule_;
	
END;
$$ LANGUAGE plpgsql;


--Permet de modifier maintenant
CREATE OR REPLACE PROCEDURE etudiant_courante_modifier_adresseCode_now(matricule_ Etudiant_Matricule,
													  			     adresseCode_ Adresse_Code
													  	             )
AS $$
BEGIN	
	
	CALL etudiant_courante_modifier_adresseCode_at(matricule_,
											   adresseCode_, 
											   NOW()::Estampille
											   );
	
END;
$$ LANGUAGE plpgsql;

--Permet d'effacer de la table courante
--Permet d'effacer à un moment précis
CREATE OR REPLACE PROCEDURE etudiant_courante_retrait_at(matricule_ Etudiant_Matricule,
													  	 date_retrait_ Estampille
													    )
AS $$
DECLARE
	matricule_since_ Estampille;
	
	prenom_ nom_prenom;
	nom_ nom_prenom;
	nom_prenom_since_ Estampille; 

	courriel_ email;	
	telephone_ phoneNumber;
	contact_since_ Estampille;
	
	adresseCode_ Adresse_Code;
	adresseCode_since_ Estampille;

BEGIN	
	
	
	SELECT matricule_since,  
		   prenom,
		   nom,
		   nom_prenom_since,
		   courriel,
		   telephone,
		   contact_since,
		   adresseCode,
		   adresseCode_since
		   
	INTO matricule_since_,
	     prenom_,
		 nom_,
		 nom_prenom_since_,
		 courriel_,
		 telephone_,
		 contact_since_,
		 adresseCode_,
		 adresseCode_since_
		 
	FROM etudiant_courante WHERE matricule = matricule_;
	
	--La date de retrait ne peut qu'être après les dates d'ajout
	IF (GREATEST(matricule_since_, nom_prenom_since_, contact_since_, adresseCode_since_) >= date_retrait_) THEN
		RAISE EXCEPTION 'LA DATE D EFFACEMENT DOIT ETRE APRES LES DATES D AJOUT';
		RETURN;
	END IF;
	
	--Sauvegarde des données dans les tables de validitées
	--Sauvegarde du matricule	
	CALL etudiant_matricule_validite_ajout_PRIVATE(matricule_, 
										           matricule_since_, 
										           date_retrait_);
	
	--Sauvegarde du nom et prénom
	CALL etudiant_nom_prenom_validite_ajout_PRIVATE(matricule_,
											        nom_,
											        prenom_,
											        nom_prenom_since_,
											        date_retrait_);

	--Sauvegarde des informations de contact
	CALL etudiant_contact_validite_ajout_PRIVATE(matricule_,
										         courriel_,
										         telephone_,
										         contact_since_,
										         date_retrait_);
										 
	--Sauvegarde de l'adresse
	CALL etudiant_adresseCode_validite_ajout_PRIVATE(matricule_,
										           adresseCode_,
										           adresseCode_since_,
										           date_retrait_);

	--On efface la ligne dans la table courante
	DELETE FROM Etudiant_Courante WHERE matricule = matricule_;
	
END;
$$ LANGUAGE plpgsql;

--Permet d'effacer maintenant
CREATE OR REPLACE PROCEDURE etudiant_courante_retrait_now(matricule_ Etudiant_Matricule)
AS $$

BEGIN	
	CALL etudiant_courante_retrait_at(matricule_, 
									  NOW()::Estampille);
	
END;
$$ LANGUAGE plpgsql;