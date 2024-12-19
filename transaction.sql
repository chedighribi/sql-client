USE Locations;

BEGIN TRANSACTION;
BEGIN TRY
    INSERT INTO CLIENTS (id_cli, nom, prenom, adresse, cpo, ville) 
    VALUES (1001, 'Durand', 'Alice', '10 Rue des Lilas', '75001', 'Paris');
    COMMIT TRANSACTION;
    PRINT 'Insertion réussie pour CLIENTS (Durand, Alice).';
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
    PRINT 'Erreur lors de l''insertion dans CLIENTS : ' + ERROR_MESSAGE();
END CATCH;
