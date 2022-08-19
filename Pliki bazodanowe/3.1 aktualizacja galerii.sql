CREATE OR ALTER PROCEDURE up_zmiana_galerii (
@galeria_przed int = NULL, 
@galeria_po int = NULL, 
@nazwa_galerii nvarchar(100) = NULL,
@nazwa_panstwa nvarchar(100) = NULL,
@nazwa_miasta nvarchar(100) = NULL,
@adres_galerii nvarchar(255) = NULL
)
AS
BEGIN
 SET NOCOUNT ON;
	IF @galeria_po IS NULL AND @galeria_przed IS NOT NULL AND @nazwa_panstwa IS NOT NULL AND @nazwa_galerii IS NOT NULL AND @nazwa_miasta IS NOT NULL AND @adres_galerii IS NOT NULL
	-- gdy trzeba dodać nową galerię
	BEGIN TRY
		-- sprawdzenie, czy panstwo istnieje
		DECLARE @temp_id_panstwa int = '';
		BEGIN
			-- panstwo nie istnieje -> trzeba dodac
			BEGIN TRY
			IF (SELECT COUNT(1) FROM dbo.Panstwo WHERE Panstwo.nazwa = @nazwa_panstwa) = 0
				BEGIN
					INSERT INTO dbo.Panstwo(nazwa) VALUES (@nazwa_panstwa)
					SET @temp_id_panstwa =  (SELECT Panstwo.id_panstwo FROM Dbo.Panstwo WHERE nazwa = @nazwa_panstwa)
				END
			-- panstwo istnieje
			ELSE
				SET @temp_id_panstwa =  (SELECT Panstwo.id_panstwo FROM Dbo.Panstwo WHERE nazwa = @nazwa_panstwa)

			END TRY
			BEGIN CATCH
				THROW 50011, 'Błąd w pobieraniu ID Państwa', 1;
			END CATCH
		END


		-- dodanie galerii
		BEGIN TRY
			INSERT INTO dbo.Galeria(nazwa, id_panstwo, miasto, adres)
			VALUES(@nazwa_galerii, @temp_id_panstwa, @nazwa_miasta, @adres_galerii)
		END TRY
		BEGIN CATCH
			THROW 50021, 'Błąd dodania galerii', 1;
		END CATCH

		-- pobranie adresu nowo-powstałej galerii
		DECLARE @temp_id_galerii int = '';
		BEGIN TRY
			SET @temp_id_galerii = (SELECT id_galeria FROM DBO.Galeria
									WHERE nazwa = @nazwa_galerii);
		END TRY
		BEGIN CATCH
			THROW 50031, 'Błąd pobrania ID nowo-dodanej galerii', 1;
		END CATCH

		-- zmiana id galerii, do której odwołuje się obraz
		BEGIN TRY
			UPDATE dbo.Obraz
			SET id_galeria = @temp_id_galerii
			WHERE id_galeria = @galeria_przed
		END TRY
		BEGIN CATCH
			THROW 50041, 'Błąd w aktualizacji ID Galerii', 1;
		END CATCH

	END TRY
	BEGIN CATCH
		THROW 51001, 'Błąd w procesie aktualizacji galerii', 1;
	END CATCH
	

	-- po prostu update
	IF @galeria_po IS NOT NULL AND @galeria_przed IS NOT NULL AND @nazwa_galerii IS NULL AND @nazwa_miasta IS NULL AND @nazwa_panstwa IS NULL AND @adres_galerii IS NULL

		-- sprawdzenie, czy pierwotna galeria istnieje
		IF (SELECT COUNT(1) FROM dbo.Galeria WHERE id_galeria = @galeria_przed) = 1
			-- sprawdzenie, czy docelowa galeria istnieje
			IF (SELECT COUNT(1) FROM dbo.Galeria WHERE id_galeria = @galeria_po) = 1
				UPDATE dbo.Obraz
				SET id_galeria = @galeria_po
				WHERE id_galeria = @galeria_przed
			ELSE
				THROW 50092, 'Docelowa galeria nie istnieje!', 1;
		ELSE
			THROW 50091, 'Podana pierwotna galeria nie istnieje', 1;

 	RETURN	
END

-- zmiana galerii na istniejącą
EXEC up_zmiana_galerii @galeria_przed = 5, @galeria_po = 3

-- zamiana galerii dodając nową w istniejącym mieście
EXEC up_zmiana_galerii @galeria_przed = 1, @nazwa_galerii = 'Galeria Wydziału Ekonomiczno-Socjologicznego UŁ', 
					   @adres_galerii = 'POW 3/5', @nazwa_miasta = 'Łódź', @nazwa_panstwa = 'Polska'

-- zmiana galerii dodając nowe Państwo
EXEC up_zmiana_galerii @galeria_przed = 1, @nazwa_galerii = 'University of Cambridge Gallery', 
					   @adres_galerii = 'The Old Schools, Trinity Ln, Cambridge CB2 1TN', @nazwa_miasta = 'Cambridge', @nazwa_panstwa = 'Anglia'

-- nieprawidłowe wykonanie - brak pierwotnej galerii
EXEC up_zmiana_galerii @galeria_przed = 6, @galeria_po = 1

-- nieprawidłowe wykonanie - brak galerii docelowej 
EXEC up_zmiana_galerii @galeria_przed = 1, @galeria_po = 6


-- select podglądowy
select obraz.id_galeria, Galeria.nazwa, Galeria.adres, galeria.id_panstwo, Panstwo.nazwa, galeria.miasto, obraz.nazwa from dbo.Galeria inner join dbo.Panstwo on galeria.id_panstwo=panstwo.id_panstwo inner join dbo.Obraz on obraz.id_galeria = galeria.id_galeria