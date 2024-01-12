SET SCHEMA 'IFT723';

--------Triggger pour sauvegarder dans les tables de logs--------
--------Trigger de la table Etudiant_courante--------
CREATE OR REPLACE FUNCTION Etudiant_courante_sauvegarde_Log() RETURNS TRIGGER AS $$
DECLARE
	range1 TSRANGE;
	
BEGIN	
	IF TG_OP = 'INSERT' THEN --Dans le cas d'un insert
		--Lors d'une insertion, on doit créer la ligne dans le log de la table courante
		--On ajoute dans la table de log
		INSERT INTO Etudiant_Courante_Log (matricule, 
										   matricule_since, 
										   prenom, 
										   nom, 
										   nom_prenom_since,
										   courriel, 
										   telephone, 
										   contact_since, 
										   adresseCode, 
										   adresseCode_since, 
										   etudiant_transaction)
		VALUES (
			NEW.matricule,
			NEW.matricule_since,
			NEW.prenom,
			NEW.nom,
			NEW.nom_prenom_since,
			NEW.courriel,
			NEW.telephone,
			NEW.contact_since,
			NEW.adresseCode,
			NEW.adresseCode_since,
			TSRANGE_sec(NOW()::TIMESTAMP, NULL, '[)')
		);
		RETURN NEW;
		
	ELSIF TG_OP = 'UPDATE' THEN --Dans le cas d'un update
	
		--On ne permet pas la modification du matricule
		IF OLD.matricule != NEW.matricule THEN
			RAISE EXCEPTION 'CANT MODIFY MATRICULE';
			RETURN NULL;
		END IF;
		
		
		--Lors d'un upadte, il faut fermer le tuple correspondant dans la table de log, puis ouvrir une nouvelle ligne
		--On ferme la ligne
		SELECT etudiant_transaction INTO range1 FROM Etudiant_Courante_Log WHERE matricule = OLD.matricule AND (UPPER(etudiant_transaction) IS NULL);
		
		UPDATE Etudiant_Courante_Log
		SET etudiant_transaction = TSRANGE_sec(lower(range1), NOW()::TIMESTAMP, '[)')
		WHERE matricule = OLD.matricule AND (UPPER(etudiant_transaction) IS NULL);
					
		--On insère une ligne
		INSERT INTO Etudiant_Courante_Log (matricule, 
										   matricule_since, 
										   prenom, 
										   nom, 
										   nom_prenom_since,
										   courriel, 
										   telephone, 
										   contact_since, 
										   adresseCode, 
										   adresseCode_since, 
										   etudiant_transaction)
		VALUES (
			NEW.matricule,
			NEW.matricule_since,
			NEW.prenom,
			NEW.nom,
			NEW.nom_prenom_since,
			NEW.courriel,
			NEW.telephone,
			NEW.contact_since,
			NEW.adresseCode,
			NEW.adresseCode_since,
			TSRANGE_sec(NOW()::TIMESTAMP, NULL, '[)')
		);
		
		RETURN NEW;
		
	ELSE --Dans le cas d'un delete
		--Lors d'un delete, il faut fermer le tuple correspondant dans la table de log de la table courante.
		SELECT etudiant_transaction INTO range1 FROM Etudiant_Courante_Log WHERE matricule = OLD.matricule AND (UPPER(etudiant_transaction) IS NULL);
		
		UPDATE Etudiant_Courante_Log
		SET etudiant_transaction = TSRANGE_sec(lower(range1), NOW()::TIMESTAMP, '[)')
		WHERE matricule = OLD.matricule AND (UPPER(etudiant_transaction) IS NULL);
		
		RETURN OLD;
		
	END IF;
	RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER Etudiant_courante_sauvegarde_Log_Trigger BEFORE INSERT OR UPDATE OR DELETE
ON Etudiant_Courante FOR EACH ROW EXECUTE PROCEDURE Etudiant_courante_sauvegarde_Log();


--------Trigger de la table Etudiant_matricule--------
CREATE OR REPLACE FUNCTION Etudiant_matricule_validite_Log() RETURNS TRIGGER AS $$
DECLARE
	range1 TSRANGE;
	
BEGIN	
	IF TG_OP = 'INSERT' THEN --Dans le cas d'un insert
		--Lors d'une insertion, on doit créer la ligne dans le log de la table courante
		--On ajoute dans la table de log
		INSERT INTO Etudiant_Matricule_Log (matricule,
											etudiant_validite,
											etudiant_transaction)
		VALUES (
			NEW.matricule,
			NEW.etudiant_validite,
			TSRANGE_sec(NOW()::TIMESTAMP, NULL, '[)')
		);
		RETURN NEW;
		
	ELSIF TG_OP = 'UPDATE' THEN --Dans le cas d'un update
	
		--On ne permet pas la modification du matricule
		IF OLD.matricule != NEW.matricule THEN
			RAISE EXCEPTION 'CANT MODIFY MATRICULE';
			RETURN NULL;
		END IF;
		
		
		--Lors d'un upadte, il faut fermer le tuple correspondant dans la table de log, puis ouvrir une nouvelle ligne
		--On ferme la ligne
		SELECT etudiant_transaction INTO range1 FROM Etudiant_Matricule_Log WHERE matricule = OLD.matricule AND (UPPER(etudiant_transaction) IS NULL);
		
		UPDATE Etudiant_Matricule_Log
		SET etudiant_transaction = TSRANGE_sec(lower(range1), NOW()::TIMESTAMP, '[)')
		WHERE matricule = OLD.matricule AND (UPPER(etudiant_transaction) IS NULL);
					
		--On insère une ligne
		INSERT INTO Etudiant_Matricule_Log (matricule,
											etudiant_validite,
											etudiant_transaction)
		VALUES (
			NEW.matricule,
			NEW.etudiant_validite,
			TSRANGE_sec(NOW()::TIMESTAMP, NULL, '[)')
		);
		
		RETURN NEW;
		
	ELSE --Dans le cas d'un delete
		--Lors d'un delete, il faut fermer le tuple correspondant dans la table de log de la table courante.
		SELECT etudiant_transaction INTO range1 FROM Etudiant_Matricule_Log WHERE matricule = OLD.matricule AND (UPPER(etudiant_transaction) IS NULL);
		
		UPDATE Etudiant_Matricule_Log
		SET etudiant_transaction = TSRANGE_sec(lower(range1), NOW()::TIMESTAMP, '[)')
		WHERE matricule = OLD.matricule AND (UPPER(etudiant_transaction) IS NULL);
		
		RETURN OLD;
		
	END IF;
	RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER Etudiant_matricule_validite_sauvegarde_Log_Trigger BEFORE INSERT OR UPDATE OR DELETE
ON Etudiant_matricule_validite FOR EACH ROW EXECUTE PROCEDURE Etudiant_matricule_validite_Log();


--------Trigger de la table Etudiant_nom_prenom--------
CREATE OR REPLACE FUNCTION Etudiant_nom_prenom_validite_Log() RETURNS TRIGGER AS $$
DECLARE
	range1 TSRANGE;
	
BEGIN	
	IF TG_OP = 'INSERT' THEN --Dans le cas d'un insert
		--Lors d'une insertion, on doit créer la ligne dans le log de la table courante
		--On ajoute dans la table de log
		INSERT INTO Etudiant_nom_prenom_Log (matricule,
											 prenom,
											 nom,
											 nom_prenom_validite,
											 nom_prenom_transaction
											)
		VALUES (
			NEW.matricule,
			NEW.prenom,
			NEW.nom,
			NEW.nom_prenom_validite,
			TSRANGE_sec(NOW()::TIMESTAMP, NULL, '[)')
		);
		RETURN NEW;
		
	ELSIF TG_OP = 'UPDATE' THEN --Dans le cas d'un update
	
		--On ne permet pas la modification du matricule
		IF OLD.matricule != NEW.matricule THEN
			RAISE EXCEPTION 'CANT MODIFY MATRICULE';
			RETURN NULL;
		END IF;
		
		
		--Lors d'un upadte, il faut fermer le tuple correspondant dans la table de log, puis ouvrir une nouvelle ligne
		--On ferme la ligne
		SELECT nom_prenom_transaction INTO range1 FROM Etudiant_nom_prenom_Log WHERE matricule = OLD.matricule AND (UPPER(nom_prenom_transaction) IS NULL);
		
		UPDATE Etudiant_nom_prenom_Log
		SET nom_prenom_transaction = TSRANGE_sec(lower(range1), NOW()::TIMESTAMP, '[)')
		WHERE matricule = OLD.matricule AND (UPPER(nom_prenom_transaction) IS NULL);
					
		--On insère une ligne
		INSERT INTO Etudiant_nom_prenom_Log (matricule,
											 prenom,
											 nom,
											 nom_prenom_validite,
											 nom_prenom_transaction
											)
		VALUES (
			NEW.matricule,
			NEW.prenom,
			NEW.nom,
			NEW.nom_prenom_validite,
			TSRANGE_sec(NOW()::TIMESTAMP, NULL, '[)')
		);
		
		RETURN NEW;
		
	ELSE --Dans le cas d'un delete
		--Lors d'un delete, il faut fermer le tuple correspondant dans la table de log de la table courante.
		SELECT nom_prenom_transaction INTO range1 FROM Etudiant_nom_prenom_Log WHERE matricule = OLD.matricule AND (UPPER(nom_prenom_transaction) IS NULL);
		
		UPDATE Etudiant_nom_prenom_Log
		SET nom_prenom_transaction = TSRANGE_sec(lower(range1), NOW()::TIMESTAMP, '[)')
		WHERE matricule = OLD.matricule AND (UPPER(nom_prenom_transaction) IS NULL);
		
		RETURN OLD;
		
	END IF;
	RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER Etudiant_nom_prenom_validite_sauvegarde_Log_Trigger BEFORE INSERT OR UPDATE OR DELETE
ON Etudiant_nom_prenom_validite FOR EACH ROW EXECUTE PROCEDURE Etudiant_nom_prenom_validite_Log();


--------Trigger de la table Etudiant_contact--------
CREATE OR REPLACE FUNCTION Etudiant_contact_validite_Log() RETURNS TRIGGER AS $$
DECLARE
	range1 TSRANGE;
	
BEGIN	
	IF TG_OP = 'INSERT' THEN --Dans le cas d'un insert
		--Lors d'une insertion, on doit créer la ligne dans le log de la table courante
		--On ajoute dans la table de log
		INSERT INTO Etudiant_contact_Log (matricule,
										  courriel,
										  telephone,
										  contact_validite,
										  contact_transaction
										 )
		VALUES (
			NEW.matricule,
			NEW.courriel,
			NEW.telephone,
			NEW.contact_validite,
			TSRANGE_sec(NOW()::TIMESTAMP, NULL, '[)')
		);
		RETURN NEW;
		
	ELSIF TG_OP = 'UPDATE' THEN --Dans le cas d'un update
	
		--On ne permet pas la modification du matricule
		IF OLD.matricule != NEW.matricule THEN
			RAISE EXCEPTION 'CANT MODIFY MATRICULE';
			RETURN NULL;
		END IF;
		
		
		--Lors d'un upadte, il faut fermer le tuple correspondant dans la table de log, puis ouvrir une nouvelle ligne
		--On ferme la ligne
		SELECT contact_transaction INTO range1 FROM Etudiant_contact_Log WHERE matricule = OLD.matricule AND (UPPER(contact_transaction) IS NULL);
		
		UPDATE Etudiant_contact_Log
		SET contact_transaction = TSRANGE_sec(lower(range1), NOW()::TIMESTAMP, '[)')
		WHERE matricule = OLD.matricule AND (UPPER(contact_transaction) IS NULL);
					
		--On insère une ligne
		INSERT INTO Etudiant_contact_Log (matricule,
										  courriel,
										  telephone,
										  contact_validite,
										  contact_transaction
										 )
		VALUES (
			NEW.matricule,
			NEW.courriel,
			NEW.telephone,
			NEW.contact_validite,
			TSRANGE_sec(NOW()::TIMESTAMP, NULL, '[)')
		);
		
		RETURN NEW;
		
	ELSE --Dans le cas d'un delete
		--Lors d'un delete, il faut fermer le tuple correspondant dans la table de log de la table courante.
		SELECT contact_transaction INTO range1 FROM Etudiant_contact_Log WHERE matricule = OLD.matricule AND (UPPER(contact_transaction) IS NULL);
		
		UPDATE Etudiant_contact_Log
		SET contact_transaction = TSRANGE_sec(lower(range1), NOW()::TIMESTAMP, '[)')
		WHERE matricule = OLD.matricule AND (UPPER(contact_transaction) IS NULL);
		
		RETURN OLD;
		
	END IF;
	RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER Etudiant_contact_validite_sauvegarde_Log_Trigger BEFORE INSERT OR UPDATE OR DELETE
ON Etudiant_contact_validite FOR EACH ROW EXECUTE PROCEDURE Etudiant_contact_validite_Log();

--------Trigger de la table Etudiant_adresseCode--------
CREATE OR REPLACE FUNCTION Etudiant_adresseCode_validite_Log() RETURNS TRIGGER AS $$
DECLARE
	range1 TSRANGE;
	
BEGIN	
	IF TG_OP = 'INSERT' THEN --Dans le cas d'un insert
		--Lors d'une insertion, on doit créer la ligne dans le log de la table courante
		--On ajoute dans la table de log
		INSERT INTO Etudiant_adresseCode_Log (matricule,
										  	adresseCode,
											adresseCode_validite,
										  	adresseCode_transaction
										 )
		VALUES (
			NEW.matricule,
			NEW.adresseCode,
			NEW.adresseCode_validite,
			TSRANGE_sec(NOW()::TIMESTAMP, NULL, '[)')
		);
		RETURN NEW;
		
	ELSIF TG_OP = 'UPDATE' THEN --Dans le cas d'un update
	
		--On ne permet pas la modification du matricule
		IF OLD.matricule != NEW.matricule THEN
			RAISE EXCEPTION 'CANT MODIFY MATRICULE';
			RETURN NULL;
		END IF;
		
		
		--Lors d'un upadte, il faut fermer le tuple correspondant dans la table de log, puis ouvrir une nouvelle ligne
		--On ferme la ligne
		SELECT adresseCode_transaction INTO range1 FROM Etudiant_adresseCode_Log WHERE matricule = OLD.matricule AND (UPPER(adresseCode_transaction) IS NULL);
		
		UPDATE Etudiant_adresseCode_Log
		SET adresseCode_transaction = TSRANGE_sec(lower(range1), NOW()::TIMESTAMP, '[)')
		WHERE matricule = OLD.matricule AND (UPPER(adresseCode_transaction) IS NULL);
					
		--On insère une ligne
		INSERT INTO Etudiant_adresseCode_Log (matricule,
										  	adresseCode,
											adresseCode_validite,
										  	adresseCode_transaction
										 )
		VALUES (
			NEW.matricule,
			NEW.adresseCode,
			NEW.adresseCode_validite,
			TSRANGE_sec(NOW()::TIMESTAMP, NULL, '[)')
		);
		
		RETURN NEW;
		
	ELSE --Dans le cas d'un delete
		--Lors d'un delete, il faut fermer le tuple correspondant dans la table de log de la table courante.
		SELECT adresseCode_transaction INTO range1 FROM Etudiant_adresseCode_Log WHERE matricule = OLD.matricule AND (UPPER(adresseCode_transaction) IS NULL);
		
		UPDATE Etudiant_adresseCode_Log
		SET adresseCode_transaction = TSRANGE_sec(lower(range1), NOW()::TIMESTAMP, '[)')
		WHERE matricule = OLD.matricule AND (UPPER(adresseCode_transaction) IS NULL);
		
		RETURN OLD;
		
	END IF;
	RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER Etudiant_adresseCode_validite_sauvegarde_Log_Trigger BEFORE INSERT OR UPDATE OR DELETE
ON Etudiant_adresseCode_validite FOR EACH ROW EXECUTE PROCEDURE Etudiant_adresseCode_validite_Log();