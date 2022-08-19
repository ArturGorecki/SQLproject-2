-- procedura do przeglądania wszystkich obrazów z ich najwazniejszymi szczegółami, stworzonymi między wybranymi latami
CREATE OR ALTER PROCEDURE up_sortuj_obrazy_rokiem (@rok_1 int, @rok_2 int = NULL, @decyzja nvarchar(8))

AS
BEGIN
 SET NOCOUNT ON;
	IF @rok_1 IS NULL
		THROW 50001, 'Pierwszy rok nie moze byc pusty!', 1;
	IF @decyzja IS NULL
		THROW 50002, 'Trzeba podac tryb sortowania!', 1;

	IF @decyzja = 'rowno'
	BEGIN
		IF @rok_2 IS NOT NULL
			THROW 50011, 'W przypadku zakresu "rowno" nie mozna podac pary lat', 1;
		ELSE  
				select obraz.nazwa, osoba.imie + ' ' + osoba.nazwisko as artysta, YEAR(obraz.data_powstania) as rok_powstania, epoka.nazwa, obraz.rozmiar 
				from dbo.obraz inner join dbo.Artysta on obraz.id_artysta = artysta.id_artysta 
							   inner join dbo.osoba on osoba.id_osoba = artysta.id_osoba 
							   inner join dbo.epoka on epoka.id_epoka = Obraz.id_epoka
							   WHERE YEAR(data_powstania) = @rok_1
	END
	IF @decyzja = 'od'
	BEGIN
		IF @rok_2 IS NOT NULL
			THROW 50011, 'W przypadku zakresu "od" nie mozna podac pary lat', 1;
		ELSE  
				select obraz.nazwa, osoba.imie + ' ' + osoba.nazwisko as artysta, YEAR(obraz.data_powstania) as rok_powstania, epoka.nazwa, obraz.rozmiar 
				from dbo.obraz inner join dbo.Artysta on obraz.id_artysta = artysta.id_artysta 
							   inner join dbo.osoba on osoba.id_osoba = artysta.id_osoba 
							   inner join dbo.epoka on epoka.id_epoka = Obraz.id_epoka
							   WHERE YEAR(data_powstania) >= @rok_1
	END
	IF @decyzja = 'do'
	BEGIN
		IF @rok_2 IS NOT NULL
			THROW 50012, 'W przypadku zakresu "do" nie mozna podac pary lat', 1;
		ELSE 
				select obraz.nazwa, osoba.imie + ' ' + osoba.nazwisko as artysta, YEAR(obraz.data_powstania) as rok_powstania, epoka.nazwa, obraz.rozmiar 
				from dbo.obraz inner join dbo.Artysta on obraz.id_artysta = artysta.id_artysta 
							   inner join dbo.osoba on osoba.id_osoba = artysta.id_osoba 
							   inner join dbo.epoka on epoka.id_epoka = Obraz.id_epoka
							   WHERE YEAR(data_powstania) <= @rok_1
	END
	IF @decyzja = 'pomiedzy'
		BEGIN
		IF @rok_2 IS  NULL
			THROW 50013, 'W przypadku zakresu "pomiedzy" trzeba podac pare lat!', 1;
		ELSE
			IF @rok_2 < @rok_1
				THROW 50031, 'Druga data nie moze byc mniejsza od pierwszej!', 1;
			IF @rok_1 = @rok_2
				THROW 50032, 'Daty nie moga byc rowne sobie', 1;
			ELSE
				select obraz.nazwa, osoba.imie + ' ' + osoba.nazwisko as artysta, YEAR(obraz.data_powstania) as rok_powstania, epoka.nazwa, obraz.rozmiar 
				from dbo.obraz inner join dbo.Artysta on obraz.id_artysta = artysta.id_artysta 
							   inner join dbo.osoba on osoba.id_osoba = artysta.id_osoba 
							   inner join dbo.epoka on epoka.id_epoka = Obraz.id_epoka
							   WHERE YEAR(data_powstania) BETWEEN @rok_1 AND @rok_2
		END
	IF @decyzja !=  'od' AND @decyzja != 'do'  AND @decyzja !=   'pomiedzy' AND @decyzja != 'rowno'
		THROW 50021, 'Podaj parametr w postaci "od"/"do"/"pomiedzy"!', 1;
	RETURN	
END


-- wywołanie nieprawidłowe - brak drugiej daty
EXEC up_sortuj_obrazy_rokiem @rok_1 = 1505, @decyzja = 'pomiedzy'

-- wywołanie nieprawidłowe - zła  decyzja
EXEC up_sortuj_obrazy_rokiem @rok_1 = 1800, @decyzja = 'dx'

-- wywołanie nieprawidłowe - brak pierwszego, koniecznego roku
EXEC up_sortuj_obrazy_rokiem @rok_2 = 1800, @decyzja = 'do'

-- wywołanie nieprawidłowe - za dużo lat
EXEC up_sortuj_obrazy_rokiem @rok_1 = 1800, @rok_2 = 1999, @decyzja = 'do'

-- wywołanie nieprawidłowe - daty nie sa sobie równe
EXEC up_sortuj_obrazy_rokiem @rok_1 = 1807, @rok_2 = 1807, @decyzja = 'pomiedzy'

-- wywołanie nieprawidłowe - daty są w złej kolejności
EXEC up_sortuj_obrazy_rokiem @rok_1 = 1807, @rok_2 = 1800, @decyzja = 'pomiedzy'


-- wywołanie prawidłowe
EXEC up_sortuj_obrazy_rokiem @rok_1 = 1500, @rok_2 = 1950, @decyzja = 'pomiedzy'

-- wywołanie prawidłowe
EXEC up_sortuj_obrazy_rokiem @rok_1 = 1600, @decyzja = 'do'

-- wywołanie prawidłowe
EXEC up_sortuj_obrazy_rokiem @rok_1 = 1500, @decyzja = 'od'

-- wywołanie prawidłowe
EXEC up_sortuj_obrazy_rokiem @rok_1 = 1507, @decyzja = 'rowno'