USE Locations;

INSERT INTO CLIENTS (id_cli, nom, prenom, adresse, cpo, ville) VALUES(14, 'Boutaud',  'Sabine', 'Rue des platanes', '75002', 'Paris')

INSERT INTO FICHES ( id_cli, date_crea, date_paye, etat) VALUES( 14,  DATEADD(DAY, -15, GETDATE()), DATEADD(DAY, -13, GETDATE()), 'SO')


INSERT INTO Gamme (id_gam, libelle) VALUES('HG', 'haut de gamme')
INSERT INTO Gamme (id_gam, libelle) VALUES('EG', 'entre de gamme')
INSERT INTO Gamme (id_gam, libelle) VALUES('PR', 'Materiel pro')

INSERT INTO Categories (id_cate, libelle) VALUES('FOA', 'ski de fond alternatif')
INSERT INTO Categories (id_cate, libelle) VALUES('FOP', 'ski de fond patineur')

INSERT INTO Grille (id_gam, id_cate, prix_jour) VALUES('EG','FOA', 10)
INSERT INTO Grille (id_gam, id_cate, prix_jour) VALUES('HG','FOP', 30)
INSERT INTO Grille (id_gam, id_cate, prix_jour) VALUES('PR','FOP', 90)

INSERT INTO MODELES (designation, id_gam, id_cate) VALUES ('Fischer Cruiser', 'EG', 'FOA')
INSERT INTO MODELES (designation, id_gam, id_cate) VALUES ('Fischer SOSSkating VASA', 'HG', 'FOP')
INSERT INTO MODELES (designation, id_gam, id_cate) VALUES ('Fischer RCS CARBOLITE Skating', 'PR', 'FOP')

INSERT INTO ARTICLES (ref_art, id_modele) VALUES('F05', 1)
INSERT INTO ARTICLES (ref_art, id_modele) VALUES('F50', 2)
INSERT INTO ARTICLES (ref_art, id_modele) VALUES('F60', 3)

INSERT INTO LIGNESFIC (id_fic, id_lig, ref_art, date_depart, date_retour) VALUES (1001, 1, 'F05', DATEADD(DAY, -15, GETDATE()), DATEADD(DAY, -13, GETDATE()))
INSERT INTO LIGNESFIC (id_fic, id_lig, ref_art, date_depart, date_retour) VALUES (1001, 2, 'F50', DATEADD(DAY, -15, GETDATE()), DATEADD(DAY, -14, GETDATE()))
INSERT INTO LIGNESFIC (id_fic, id_lig, ref_art, date_depart, date_retour) VALUES (1001, 3, 'F60', DATEADD(DAY, -13, GETDATE()), DATEADD(DAY, -12, GETDATE()))
