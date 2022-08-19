CREATE OR ALTER PROCEDURE up_zmiana_nazwy_miasta(@nazwa_przed nvarchar(100), @nazwa_po nvarchar(100))
AS
BEGIN
 SET NOCOUNT ON;
 	-- sprawdzenie, czy pierwotne miasto istnieje
	IF (SELECT COUNT(1) FROM dbo.Galeria WHERE miasto = @nazwa_przed) > 0
		UPDATE dbo.Galeria
		SET miasto = @nazwa_po
		WHERE miasto = @nazwa_przed
	ELSE 
		THROW 50001, 'Brak podanego miasta!',1;

 RETURN
END

-- select
Select DISTINCT miasto from dbo.Galeria

-- poprawne wywołanie
EXEC up_zmiana_nazwy_miasta @nazwa_przed = 'Nowy Jork', @nazwa_po = 'New York'

-- niepoprawne wywołanie - brak miasta na liscie
EXEC up_zmiana_nazwy_miasta @nazwa_przed = 'Rzym', @nazwa_po = 'Rome'