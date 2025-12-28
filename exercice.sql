CREATE DATABASE bibliotheque CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE bibliotheque;
CREATE TABLE AUTEUR (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(100) NOT NULL
) ENGINE=InnoDB;
CREATE TABLE OUVRAGE (
    id INT AUTO_INCREMENT PRIMARY KEY,
    titre VARCHAR(255) NOT NULL,
    disponible BOOLEAN DEFAULT TRUE,
    auteur_id INT,
    CONSTRAINT fk_ouvrage_auteur 
        FOREIGN KEY (auteur_id) REFERENCES AUTEUR(id) 
        ON DELETE CASCADE
) ENGINE=InnoDB;
CREATE TABLE ABONNE (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL
) ENGINE=InnoDB;
CREATE TABLE EMPRUNT (
    ouvrage_id INT,
    abonne_id INT,
    date_debut DATE NOT NULL,
    date_fin DATE,
    PRIMARY KEY (ouvrage_id, abonne_id, date_debut),
    CONSTRAINT fk_emprunt_ouvrage FOREIGN KEY (ouvrage_id) REFERENCES OUVRAGE(id),
    CONSTRAINT fk_emprunt_abonne FOREIGN KEY (abonne_id) REFERENCES ABONNE(id),
    CONSTRAINT chk_dates CHECK (date_fin IS NULL OR date_fin >= date_debut)
) ENGINE=InnoDB;
SELECT titre FROM OUVRAGE WHERE disponible = TRUE;
SELECT * FROM ABONNE WHERE email LIKE '%@gmail.com';
SELECT * FROM EMPRUNT WHERE date_fin IS NULL;
SELECT a.nom, o.titre
FROM EMPRUNT e
JOIN ABONNE a ON e.abonne_id = a.id
JOIN OUVRAGE o ON e.ouvrage_id = o.id;
SELECT abonne_id, COUNT(*) as total_emprunts 
FROM EMPRUNT GROUP BY abonne_id;
SELECT au.nom, COUNT(o.id) as nb_livres
FROM AUTEUR au
LEFT JOIN OUVRAGE o ON au.id = o.auteur_id
GROUP BY au.id, au.nom
ORDER BY nb_livres DESC;
SELECT au.nom, COUNT(o.id) as nb_livres
FROM AUTEUR au
JOIN OUVRAGE o ON au.id = o.auteur_id
GROUP BY au.id, au.nom
HAVING nb_livres >= 3;
UPDATE OUVRAGE SET disponible = FALSE WHERE id = 2;
DELETE FROM EMPRUNT WHERE date_fin < '2025-01-01';
UPDATE EMPRUNT SET date_fin = CURDATE() 
WHERE ouvrage_id = 2 AND abonne_id = 1 AND date_fin IS NULL;
START TRANSACTION;
INSERT INTO ABONNE (nom, email) VALUES ('Jean Valjean', 'jean@v.fr');
SET @new_id = LAST_INSERT_ID();
INSERT INTO EMPRUNT (ouvrage_id, abonne_id, date_debut) VALUES (10, @new_id, CURDATE());
INSERT INTO EMPRUNT (ouvrage_id, abonne_id, date_debut) VALUES (11, @new_id, CURDATE());
COMMIT;
INSERT INTO OUVRAGE (id, titre, disponible) 
VALUES (5, 'Le Cid', TRUE)
ON DUPLICATE KEY UPDATE disponible = VALUES(disponible);
DELIMITER //
CREATE PROCEDURE p_creer_emprunt(IN p_ouvrage_id INT, IN p_abonne_id INT)
BEGIN
    DECLARE v_dispo BOOLEAN;
    SELECT disponible INTO v_dispo FROM OUVRAGE WHERE id = p_ouvrage_id;
    
    IF v_dispo THEN
        INSERT INTO EMPRUNT (ouvrage_id, abonne_id, date_debut) VALUES (p_ouvrage_id, p_abonne_id, CURDATE());
        UPDATE OUVRAGE SET disponible = FALSE WHERE id = p_ouvrage_id;
    ELSE
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Ouvrage non disponible';
    END IF;
END //
DELIMITER ;