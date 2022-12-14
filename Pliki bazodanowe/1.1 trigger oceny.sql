-- trigger do zapewnienia tego, że wartość oceny będzie się mieściła w założonym zakresie <1;10> ze skokiem 1.
CREATE OR ALTER TRIGGER dbo.trg_Ocena ON dbo.Ocena
	INSTEAD OF INSERT
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE
		@wartosc int
	SET @wartosc = (SELECT wartosc FROM inserted);
	IF @wartosc < 1 OR @wartosc > 10
		THROW 50001, 'Wartosc oceny musi sie miescic w przedziale 1-10!', 1;
	ELSE
		INSERT INTO dbo.Ocena(id_uzytkownik, id_obraz, wartosc, data_wystawienia) SELECT id_uzytkownik, id_obraz, wartosc, data_wystawienia FROM inserted;
END
GO


-- sprawdzenie działania Triggera
	-- spodziewany bład - za duża wartość
INSERT INTO dbo.Ocena(id_uzytkownik, id_obraz, wartosc, data_wystawienia)
VALUES
(2, 2, 11, '2022-06-17')
	-- spodziewany błąd - za mała wartość
INSERT INTO dbo.Ocena(id_uzytkownik, id_obraz, wartosc, data_wystawienia)
VALUES
(2, 2, 0, '2022-06-17')
	-- poprawne dodanie
INSERT INTO dbo.Ocena(id_uzytkownik, id_obraz, wartosc, data_wystawienia)
VALUES
(2, 2, 10, '2022-06-17')

SELECT * From dbo.ocena