USE bibliotheque;
INSERT INTO auteur (nom)
VALUES 
  ('Victor Hugo'),
  ('George Orwell'),
  ('Jane Austen');
  SELECT id, nom FROM auteur WHERE nom='Victor Hugo';
  INSERT INTO ouvrage (titre, disponible, auteur_id)
VALUES 
  ('Les Misérables', TRUE, 1),
  ('1984', FALSE, 2),
  ('Pride and Prejudice', TRUE, 3);
  INSERT INTO abonne (nom, email)
VALUES 
  ('Karim', 'karim@mail.com'),
  ('Lucie', 'lucie@mail.com');
INSERT INTO emprunt (ouvrage_id, abonne_id, date_debut)
VALUES (2, 1, '2025-06-18');
SELECT * FROM emprunt WHERE id = LAST_INSERT_ID();
UPDATE ouvrage
SET disponible = FALSE
WHERE titre = 'Les Misérables';
UPDATE abonne
SET email = 'karim.new@mail.com'
WHERE nom = 'Karim';
UPDATE emprunt
SET date_fin = CURDATE()
WHERE id = 1;
DELETE FROM auteur
WHERE nom = 'George Orwell';
DELETE FROM ouvrage
WHERE id = 2;
DELETE FROM abonne
WHERE nom = 'Lucie';
START TRANSACTION;
INSERT INTO abonne (nom, email) VALUES ('Samir', 'samir@mail.com');
INSERT INTO emprunt (ouvrage_id, abonne_id, date_debut) VALUES (3, LAST_INSERT_ID(), '2025-06-19');
COMMIT;
ROLLBACK;