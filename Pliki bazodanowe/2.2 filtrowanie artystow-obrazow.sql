-- procedura do przeglądania wszystkich dzieł z ich najwazniejszymi szczegółami, filtrując po tytule/artyscie
CREATE OR ALTER PROCEDURE up_filtruj_nazwy_obrazow (@tytul nvarchar(250) = NULL, @artysta nvarchar(355) = NULL)
AS
BEGIN
 SET NOCOUNT ON;
	IF @tytul IS NULL AND @artysta is NULL
		THROW 50001, 'Nalezy podac warunki filtrowania!', 1;


	IF @artysta IS NULL
		BEGIN
		--BEGIN TRY 
			IF	(SELECT COUNT(1) FROM 
					(select obraz.nazwa, osoba.imie + ' ' + osoba.nazwisko as artysta, ROUND(avg(CAST(ocena.wartosc AS FLOAT)),2) as srednia_ocena,
					YEAR(obraz.data_powstania) as rok_powstania, epoka.nazwa as epoka, obraz.rozmiar 
					from dbo.obraz inner join dbo.Artysta on obraz.id_artysta = artysta.id_artysta 
								   inner join dbo.osoba on osoba.id_osoba = artysta.id_osoba 
								   inner join dbo.epoka on epoka.id_epoka = Obraz.id_epoka
								   inner join dbo.ocena on ocena.id_obraz = Obraz.id_obraz
								   WHERE obraz.nazwa LIKE ('%'+@tytul+'%')
								   group by obraz.nazwa, osoba.imie, osoba.nazwisko, ocena.id_obraz, obraz.data_powstania, epoka.nazwa, obraz.rozmiar) as filtrowanie ) = 0

				THROW 50201, 'Brak wyników!', 1;
			ELSE
					select obraz.nazwa, osoba.imie + ' ' + osoba.nazwisko as artysta, ROUND(avg(CAST(ocena.wartosc AS FLOAT)),2) as srednia_ocena,
					YEAR(obraz.data_powstania) as rok_powstania, epoka.nazwa as epoka, obraz.rozmiar 
					from dbo.obraz inner join dbo.Artysta on obraz.id_artysta = artysta.id_artysta 
								   inner join dbo.osoba on osoba.id_osoba = artysta.id_osoba 
								   inner join dbo.epoka on epoka.id_epoka = Obraz.id_epoka
								   inner join dbo.ocena on ocena.id_obraz = Obraz.id_obraz
								   WHERE obraz.nazwa LIKE ('%'+@tytul+'%')
								   group by obraz.nazwa, osoba.imie, osoba.nazwisko, ocena.id_obraz, obraz.data_powstania, epoka.nazwa, obraz.rozmiar
						   
		/*END TRY
		BEGIN CATCH
			THROW 50101, 'Błąd filtrowania!', 1;
		END CATCH*/
	END
		
		IF @tytul IS NULL
			BEGIN
		--BEGIN TRY 
			IF	(SELECT COUNT(1) FROM 
					(select obraz.nazwa, osoba.imie + ' ' + osoba.nazwisko as artysta, ROUND(avg(CAST(ocena.wartosc AS FLOAT)),2) as srednia_ocena,
					YEAR(obraz.data_powstania) as rok_powstania, epoka.nazwa as epoka, obraz.rozmiar 
					from dbo.obraz inner join dbo.Artysta on obraz.id_artysta = artysta.id_artysta 
								   inner join dbo.osoba on osoba.id_osoba = artysta.id_osoba 
								   inner join dbo.epoka on epoka.id_epoka = Obraz.id_epoka
								   inner join dbo.ocena on ocena.id_obraz = Obraz.id_obraz
								   WHERE (osoba.imie + ' ' + osoba.nazwisko) LIKE  ('%'+@artysta+'%')
								   group by obraz.nazwa, osoba.imie, osoba.nazwisko, ocena.id_obraz, obraz.data_powstania, epoka.nazwa, obraz.rozmiar) as filtrowanie ) = 0

				THROW 50201, 'Brak wyników!', 1;
			ELSE
					select obraz.nazwa, osoba.imie + ' ' + osoba.nazwisko as artysta, ROUND(avg(CAST(ocena.wartosc AS FLOAT)),2) as srednia_ocena,
					YEAR(obraz.data_powstania) as rok_powstania, epoka.nazwa as epoka, obraz.rozmiar 
					from dbo.obraz inner join dbo.Artysta on obraz.id_artysta = artysta.id_artysta 
								   inner join dbo.osoba on osoba.id_osoba = artysta.id_osoba 
								   inner join dbo.epoka on epoka.id_epoka = Obraz.id_epoka
								   inner join dbo.ocena on ocena.id_obraz = Obraz.id_obraz
								   WHERE (osoba.imie + ' ' + osoba.nazwisko) LIKE  ('%'+@artysta+'%')
								   group by obraz.nazwa, osoba.imie, osoba.nazwisko, ocena.id_obraz, obraz.data_powstania, epoka.nazwa, obraz.rozmiar
						   
		/*END TRY
		BEGIN CATCH
			THROW 50101, 'Błąd filtrowania!', 1;
		END CATCH*/
	END

	IF @artysta IS NOT NULL AND @tytul IS NOT NULL
	BEGIN
		--BEGIN TRY 
			IF	(SELECT COUNT(1) FROM 
					(select obraz.nazwa, osoba.imie + ' ' + osoba.nazwisko as artysta, ROUND(avg(CAST(ocena.wartosc AS FLOAT)),2) as srednia_ocena,
					YEAR(obraz.data_powstania) as rok_powstania, epoka.nazwa as epoka, obraz.rozmiar 
					from dbo.obraz inner join dbo.Artysta on obraz.id_artysta = artysta.id_artysta 
								   inner join dbo.osoba on osoba.id_osoba = artysta.id_osoba 
								   inner join dbo.epoka on epoka.id_epoka = Obraz.id_epoka
								   inner join dbo.ocena on ocena.id_obraz = Obraz.id_obraz
								   WHERE (osoba.imie + ' ' + osoba.nazwisko) LIKE  ('%'+@artysta+'%') AND obraz.nazwa LIKE ('%'+@tytul+'%')
								   group by obraz.nazwa, osoba.imie, osoba.nazwisko, ocena.id_obraz, obraz.data_powstania, epoka.nazwa, obraz.rozmiar) as filtrowanie ) = 0

				THROW 50201, 'Brak wyników!', 1;
			ELSE
					select obraz.nazwa, osoba.imie + ' ' + osoba.nazwisko as artysta, ROUND(avg(CAST(ocena.wartosc AS FLOAT)),2) as srednia_ocena,
					YEAR(obraz.data_powstania) as rok_powstania, epoka.nazwa as epoka, obraz.rozmiar 
					from dbo.obraz inner join dbo.Artysta on obraz.id_artysta = artysta.id_artysta 
								   inner join dbo.osoba on osoba.id_osoba = artysta.id_osoba 
								   inner join dbo.epoka on epoka.id_epoka = Obraz.id_epoka
								   inner join dbo.ocena on ocena.id_obraz = Obraz.id_obraz
								   WHERE (osoba.imie + ' ' + osoba.nazwisko) LIKE  ('%'+@artysta+'%') AND obraz.nazwa LIKE ('%'+@tytul+'%')
								   group by obraz.nazwa, osoba.imie, osoba.nazwisko, ocena.id_obraz, obraz.data_powstania, epoka.nazwa, obraz.rozmiar
						   
		/*END TRY
		BEGIN CATCH
			THROW 50101, 'Błąd filtrowania!', 1;
		END CATCH*/
	END

	RETURN	
END

-- prawidlowe wywołanie
EXEC up_filtruj_nazwy_obrazow @artysta = 'Leo', @tytul = 'Da'

-- prawidlowe wywołanie
EXEC up_filtruj_nazwy_obrazow @artysta = '', @tytul = 'Mo'

-- prawidlowe wywołanie
EXEC up_filtruj_nazwy_obrazow @artysta = 'C', @tytul = ''

-- prawidlowe wywołanie
EXEC up_filtruj_nazwy_obrazow @artysta = 'Dal'

-- prawidlowe wywołanie
EXEC up_filtruj_nazwy_obrazow @tytul = 'Ost'

-- prawidlowe wywołanie
EXEC up_filtruj_nazwy_obrazow @artysta = '', @tytul = ''


-- prawidłowe wywołanie - ale brak wyników
EXEC up_filtruj_nazwy_obrazow @artysta = 'Matejko', @tytul = 'Bitwa'
-- prawidłowe wywołanie - ale brak wyników
EXEC up_filtruj_nazwy_obrazow @artysta = 'Matejko'
-- prawidłowe wywołanie - ale brak wyników
EXEC up_filtruj_nazwy_obrazow  @tytul = 'Bitwa'


-- nieprawidlowe wywołanie - brak filtrów
EXEC up_filtruj_nazwy_obrazow 
