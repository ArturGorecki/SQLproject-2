-- funkcja do wyświetlania raportu najpopularniejszych epok, wraz z ich przedstawicielami i iloscia obrazow przez nich stworzonych
CREATE OR ALTER FUNCTION pokaz_najpopularniejsze_epoki (@ilosc int)
RETURNS TABLE
AS
RETURN
(select top(@ilosc) epoka.nazwa, count(epoka.nazwa) as ilosc_obrazow, osoba.imie + ' ' + osoba.nazwisko as artysta
		from dbo.Epoka inner join dbo.Obraz on obraz.id_epoka = epoka.id_epoka 
					   inner join dbo.Artysta on artysta.id_artysta = obraz.id_artysta 
					   inner join dbo.Osoba on osoba.id_osoba = Artysta.id_osoba
		group by epoka.nazwa, osoba.imie, osoba.nazwisko
		order by ilosc_obrazow desc)

-- Wywołanie
SELECT * from pokaz_najpopularniejsze_epoki(2)