USE MASTER;
GO

IF NOT EXISTS (SELECT name FROM sys.sql_logins WHERE name = 'user_loc')
BEGIN
	CREATE login user_loc WITH password='Pa$$w0rd';
END;
GO

IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = 'Locations')
BEGIN
	CREATE DATABASE Locations;
END
GO

USE Locations;
GO

CREATE USER userlocation FOR login user_loc;
EXEC sp_addrolemember 'db_owner', 'userlocation';
GO



IF EXISTS (SELECT name FROM sys.all_objects WHERE name='clients_seq')
	BEGIN
		ALTER SEQUENCE SQ_Clients RESTART;
	END;
ELSE
	BEGIN
		CREATE SEQUENCE SQ_Clients AS NUMERIC(6) START WITH 1000 INCREMENT BY 1;
	END;
GO

CREATE TABLE CLIENTS(
    id_cli NUMERIC(6) CONSTRAINT PK_Clients PRIMARY KEY,
    nom VARCHAR(30) NOT NULL,
    prenom VARCHAR(30) NULL,
    adresse VARCHAR(120) NULL, 
    cpo CHAR(5) NOT NULL CONSTRAINT CK_Clients_cpo CHECK(CONVERT(NUMERIC(5),cpo) BETWEEN 1000 AND 95999),
    ville VARCHAR(80) NOT NULL CONSTRAINT df_clients_ville DEFAULT 'Nantes',
)

CREATE TABLE FICHES(
    id_fic NUMERIC(6) IDENTITY(1001,1) CONSTRAINT PK_Fiches PRIMARY KEY,
    id_cli NUMERIC(6) NULL,
    date_crea DATETIME2 NOT NULL CONSTRAINT df_fiches_crea DEFAULT GETDATE(),
    date_paye DATETIME2 NULL,
	etat		CHAR(2)			NOT NULL	CONSTRAINT CK_Fiches_etat CHECK(etat IN('EC', 'RE', 'SO')) 
											CONSTRAINT DF_Fiches_etat DEFAULT 'EC',
    CONSTRAINT FK_Fiches_Clients FOREIGN key (id_cli) REFERENCES CLIENTS(id_cli) ON DELETE SET NULL,
	CONSTRAINT CK_Fiches_ctrlDates CHECK(date_paye IS NULL OR date_paye > date_crea),
	CONSTRAINT CK_Fiches_datePayeEtat CHECK((date_paye IS NOT NULL AND etat = 'SO') OR (date_paye IS NULL AND etat <> 'SO'))
)
CREATE TABLE Gamme(
    id_gam CHAR(2) NOT NULL CONSTRAINT PK_Gamme PRIMARY KEY,
    libelle VARCHAR(30) NOT NULL CONSTRAINT UC_Gamme UNIQUE
)
CREATE TABLE Categories(
    id_cate CHAR(4) CONSTRAINT PK_Categories PRIMARY KEY,
    libelle VARCHAR(30) NOT NULL CONSTRAINT UC_Categories UNIQUE
)

CREATE TABLE Grille(
    id_gam CHAR(2),
    id_cate CHAR(4) NOT NULL,
    prix_jour NUMERIC(5,2) NOT NULL CONSTRAINT CK_Grille_prix CHECK(prix_jour >= 0),
    CONSTRAINT PK_Grille PRIMARY KEY (id_gam, id_cate),
    CONSTRAINT FK_Grille_Gamme FOREIGN KEY(id_gam) REFERENCES Gamme(id_gam),
    CONSTRAINT FK_Grille_Categories FOREIGN KEY(id_cate) REFERENCES Categories(id_cate)
)
CREATE TABLE MODELES(
id_modele INT IDENTITY CONSTRAINT PK_Modeles PRIMARY KEY,
designation VARCHAR(80) NOT NULL, 
id_gam CHAR(2) NOT NULL,
id_cate CHAR(4) NOT NULL,
	CONSTRAINT FK_Modeles_Grille FOREIGN KEY(id_gam, id_cate) REFERENCES Grille(id_gam, id_cate)
)
CREATE TABLE ARTICLES(
    ref_art CHAR(3) NOT NULL CONSTRAINT PK_Articles PRIMARY KEY,
    id_modele INT NOT NULL
    CONSTRAINT FK_Articles_Modeles REFERENCES MODELES (id_modele)
)
CREATE TABLE LIGNESFIC(
    id_fic NUMERIC(6) NOT NULL CONSTRAINT Fk_Lignefic_Fiches FOREIGN key (id_fic) REFERENCES FICHES (id_fic) ON DELETE CASCADE ON UPDATE CASCADE,
    id_lig NUMERIC(2) NOT NULL,
    ref_art CHAR(3) NOT NULL CONSTRAINT Fk_Lignefic_Articles FOREIGN key (ref_art) REFERENCES ARTICLES (ref_art) ON UPDATE CASCADE,
    date_depart DATETIME2 NOT NULL CONSTRAINT df_Lignesfic_depart DEFAULT GETDATE(),
    date_retour DATETIME2 NULL,
    CONSTRAINT PK_Lignesfic PRIMARY KEY(id_fic, id_lig),
    CONSTRAINT CK_LignesFic_dates CHECK(date_retour IS NULL OR date_retour > date_depart),
)

ALTER TABLE LIGNESFIC ADD duree AS CEILING(DATEDIFF(DAY, date_depart, date_retour));

CREATE INDEX IDX_Clients_NomPrenom
ON CLIENTS (nom, prenom)
INCLUDE (ville);

DROP TABLE LIGNESFIC, Articles, Modeles, Grille, Categories,Gamme,Fiches,Clients;