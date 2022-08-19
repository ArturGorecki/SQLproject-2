-- funkcja do wyświetlania raportu najlepiej ocenianych obrazów, w postaci ich średniej oceny, nazwy i autora
CREATE OR ALTER FUNCTION pokaz_top_obrazy (@ilosc int)
RETURNS TABLE
AS
RETURN
(select top(@ilosc) ROUND(avg(CAST(ocena.wartosc AS FLOAT)),2) as srednia_ocena,  obraz.nazwa, osoba.imie + ' ' + osoba.nazwisko as artysta, ocena.id_obraz  
		  from dbo.ocena inner join dbo.obraz on ocena.id_obraz=obraz.id_obraz 
						 inner join dbo.artysta on obraz.id_artysta = artysta.id_artysta 
						 inner join dbo.Osoba on artysta.id_osoba = osoba.id_osoba
		  group by ocena.id_obraz, obraz.nazwa, osoba.imie, osoba.nazwisko
		  order by srednia_ocena desc)

-- Wywołanie
SELECT * from pokaz_top_obrazy(5)
