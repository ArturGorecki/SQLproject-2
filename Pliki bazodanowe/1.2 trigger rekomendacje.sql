CREATE OR ALTER TRIGGER dbo.trg_Rekomendacja ON dbo.Rekomendacja
	INSTEAD OF INSERT
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE
		@nadawca int,
		@odbiorca int,
		@obraz int,
		@artysta int;


	SET @nadawca = (SELECT id_uzytkownik_nadawca FROM inserted);
	SET @odbiorca = (SELECT id_uzytkownik_odbiorca FROM inserted);
	SET @obraz = (SELECT id_obraz FROM inserted);
	SET @artysta = (SELECT id_artysta FROM inserted);

	IF (SELECT COUNT(1) FROM dbo.Uzytkownik WHERE id_uzytkownik = @nadawca) = 0 
		THROW 50000, 'Nadawca musi istniec!', 1;
	IF (SELECT COUNT(1) FROM dbo.Uzytkownik WHERE id_uzytkownik = @odbiorca) = 0 
		THROW 50000, 'Odbiorca musi istniec!', 1;
	IF @nadawca = @odbiorca
		THROW 50001, 'Nie mozna wysylac rekomendacji samemu sobie!', 1;
	IF @obraz IS NULL AND @artysta IS NULL
		THROW 50002, 'Cos musi byc przedmiotem rekomendacji!', 1;
	IF @obraz IS NOT NULL AND @artysta IS NOT NULL
		THROW 50003, 'Nie mozna jednoczesnie polecic artysty i obrazu!', 1;
	ELSE
		INSERT INTO dbo.Rekomendacja(id_uzytkownik_nadawca, id_uzytkownik_odbiorca, id_obraz, id_artysta) 
		SELECT id_uzytkownik_nadawca, id_uzytkownik_odbiorca, id_obraz, id_artysta FROM inserted;
END
GO

-- błędne wykonanie - użytkownik poleca nieistniejącemu użytkownikowi
	INSERT INTO dbo.Rekomendacja(id_uzytkownik_nadawca, id_uzytkownik_odbiorca, id_obraz, id_artysta)
	VALUES (1, 3, 2, NULL);

-- błędne wykonanie - użytkownik poleca samemu sobie
	INSERT INTO dbo.Rekomendacja(id_uzytkownik_nadawca, id_uzytkownik_odbiorca, id_obraz, id_artysta)
	VALUES (1, 1, 2, NULL);

-- błędne wykonanie - rekomendacja niczego nie poleca
	INSERT INTO dbo.Rekomendacja(id_uzytkownik_nadawca, id_uzytkownik_odbiorca, id_obraz, id_artysta)
	VALUES (1, 2, NULL, NULL);

-- błędne wykonanie - rekomendacja zawiera oba pola
	INSERT INTO dbo.Rekomendacja(id_uzytkownik_nadawca, id_uzytkownik_odbiorca, id_obraz, id_artysta)
	VALUES (1, 2, 2, 3);

-- prawidłowe wywołanie
	INSERT INTO dbo.Rekomendacja(id_uzytkownik_nadawca, id_uzytkownik_odbiorca, id_obraz, id_artysta)
	VALUES (2, 1, NULL, 3)