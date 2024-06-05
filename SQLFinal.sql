--A
--i
SELECT Title FROM Film WHERE [Year] >= 1950 AND [Year] < 1960
ORDER BY LEN(Title)

--ii
SELECT FORMAT(AVG((RetailPrice * Quantity)/Quantity), '##.##') AS AvgRetailPrice FROM Inventory

--iii

SELECT DISTINCT Title AS MaxDiff FROM Inventory inv
JOIN Film fil ON inv.Item_ID = fil.Film_ID
WHERE RetailPrice * WholesalePrice = (SELECT MAX(RetailPrice * WholesalePrice) FROM Inventory)

--iv
SELECT FirstName, LastName, COUNT(jnc.Film_ID) AS FilmCount FROM Actor act
JOIN JNC_FilmActor jnc ON jnc.Actor_ID = act.Actor_ID
JOIN Film fil ON jnc.Film_ID = fil.Film_ID
GROUP BY FirstName, LastName
ORDER BY LastName

--v
SELECT DISTINCT Title, Quantity, SUM(RetailPrice) AS SumRetail FROM Inventory inv
JOIN [Location] loc ON loc.Location_ID = inv.Location_ID
JOIN Film fil ON fil.Film_ID = inv.Item_ID
WHERE City = 'Brooklyn'
GROUP BY Title, Quantity
ORDER BY Title

--B
--i
SELECT FirstName, LastName, Title, COUNT(jnc.Role) AS RoleCount FROM Actor act
JOIN JNC_FilmActor jnc ON jnc.Actor_ID = act.Actor_ID
JOIN Film fil ON jnc.Film_ID = fil.Film_ID
GROUP BY FirstName, LastName, Title
HAVING COUNT(jnc.Role) > 1
ORDER BY LastName

--ii
SELECT DISTINCT FirstName + ' ' +  COALESCE(MiddleInitials + ' ', '') + LastName AS Actor FROM Actor act
JOIN JNC_FilmActor jnc ON jnc.Actor_ID = act.Actor_ID
JOIN Film fil ON jnc.Film_ID = fil.Film_ID
JOIN Inventory inv ON inv.Item_ID = fil.Film_ID
JOIN [Location] loc ON loc.Location_ID = inv.Location_ID
WHERE loc.City != 'Brooklyn'


--iii

--find Gary Cooper ID
SELECT Actor_ID FROM Actor
WHERE LastName = 'Cooper' AND FirstName = 'Gary'

--select films with Gary Cooper
SELECT DISTINCT Film_ID FROM JNC_FilmActor
WHERE Actor_ID = 1

--select people in films with him
SELECT DISTINCT FirstName + ' ' +  COALESCE(MiddleInitials + ' ', '') + LastName AS Actor FROM Actor act
JOIN JNC_FilmActor jnc ON jnc.Actor_ID = act.Actor_ID
JOIN Film fil ON jnc.Film_ID = fil.Film_ID
WHERE jnc.Film_ID IN 
			(SELECT DISTINCT Film_ID FROM JNC_FilmActor WHERE Actor_ID = 
						(SELECT Actor_ID FROM Actor
							WHERE LastName = 'Cooper' AND FirstName = 'Gary'))

--iv
--Alfred producer ID
SELECT Producer_ID FROM Producer
WHERE LastName = 'Hitchcock' AND FirstName = 'Alfred'

--find films produced by Alfred
SELECT Film_ID FROM JNC_FilmProducer jfp
WHERE Producer_ID = 15

--find actors in those films
SELECT DISTINCT act.FirstName + ' ' +  COALESCE(act.MiddleInitials + ' ', '') + act.LastName AS Actor FROM Actor act
JOIN JNC_FilmActor jfa ON jfa.Actor_ID = act.Actor_ID
JOIN Film fil ON fil.Film_ID = jfa.Film_ID
JOIN JNC_FilmProducer jnf ON jnf.Film_ID = fil.Film_ID
JOIN Producer pro ON pro.Producer_ID = jnf.Producer_ID
WHERE fil.Film_ID IN (SELECT Film_ID FROM JNC_FilmProducer jfp
		WHERE Producer_ID = 
			(SELECT Producer_ID FROM Producer
				WHERE LastName = 'Hitchcock' AND FirstName = 'Alfred'))

--v
SELECT Director_ID FROM Director
WHERE LastName = 'Brooks' AND FirstName = 'Mel'

SELECT Film_ID FROM Film
WHERE Director_ID = 9

SELECT DISTINCT pro.FirstName + ' ' + pro.LastName AS Producer FROM Producer pro
JOIN JNC_FilmProducer jnc ON jnc.Producer_ID = pro.Producer_ID
JOIN Film fil ON fil.Film_ID = jnc.Film_ID
JOIN Director dir ON dir.Director_ID = fil.Director_ID
WHERE fil.Film_ID IN (SELECT Film_ID FROM Film
						WHERE Director_ID = 
							(SELECT Director_ID FROM Director
								WHERE LastName = 'Brooks' AND FirstName = 'Mel'))
