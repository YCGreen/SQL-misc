USE MidtermS23

--1.1
SELECT Title FROM Book WHERE Publisher_ID = 1
ORDER BY Title

--1.2
SELECT FirstName, MiddleInitials, LastName FROM Writer

--1.3
SELECT boo.Title, wri.LastName, pub.[Name] FROM JNC_BookWriter jnc 
JOIN Writer wri ON jnc.Writer_ID = wri.Writer_ID
JOIN Book boo ON jnc.Book_ID = boo.Book_ID
JOIN Publisher pub ON boo.Publisher_ID = pub.Publisher_ID
WHERE LOWER(LEFT(boo.Title, 1)) BETWEEN 'D' AND 'H'
ORDER BY boo.Title

--1.4
SELECT boo.Title FROM Inventory inv
JOIN Book boo ON inv.Item_ID = boo.Book_ID
WHERE inv.RetailPrice > 44
ORDER BY boo.Title

--1.5
SELECT boo.Title FROM Inventory inv
JOIN Book boo ON inv.Item_ID = boo.Book_ID
WHERE inv.RetailPrice >= 25
ORDER BY boo.Title


--2.1
SELECT Title FROM Book boo
JOIN Inventory inv ON inv.Item_ID = boo.Book_ID
WHERE inv.Quantity > 12

--2.2
SELECT SUM(Price) AS TotalProceeds, MAX(Price) AS MaxPrice, MIN(Price) AS MinPrice FROM Sales

--2.3 
SELECT boo.Title, inv.RetailPrice, pub.[Name] FROM Book boo
JOIN Inventory inv ON inv.Item_ID = boo.Book_ID
JOIN Publisher pub ON pub.Publisher_ID = boo.Publisher_ID
JOIN Sales sal ON sal.Item_ID = inv.Item_ID
WHERE boo.[Year] > 1999 AND sal.Quantity = 0

--2.4
SELECT SUM(inv.Quantity) AS 'Number of Books', FORMAT(SUM(sal.Quantity * inv.RetailPrice)/SUM(inv.Quantity), '#.##') AS 'Average Retail Price' FROM Inventory inv
JOIN Sales sal ON inv.Item_ID = sal.Item_ID

--2.5
SELECT SalesDate, boo.Title, wri.LastName, pub.[Name] AS Publisher, sal.Quantity, sal.Price, loc.City FROM Sales sal
JOIN Book boo ON boo.Book_ID = sal.Item_ID
JOIN Publisher pub ON boo.Publisher_ID = pub.Publisher_ID
JOIN [Location] loc ON sal.Location_ID = loc.Location_ID
JOIN JNC_BookWriter jnc ON boo.Book_ID = jnc.Book_ID
JOIN Writer wri ON wri.Writer_ID = jnc.Writer_ID


--3.1
SELECT wri.FirstName + ' ' + wri.LastName AS Author, COUNT(jnc.Book_ID) AS BooksWritten FROM JNC_BookWriter jnc
JOIN Writer wri ON jnc.Writer_ID = wri.Writer_ID
JOIN Book boo ON jnc.Book_ID = boo.Book_ID
GROUP BY wri.FirstName, wri.LastName
ORDER BY COUNT(jnc.Book_ID) DESC

--3.2
SELECT wri.FirstName + ' ' + ISNULL(wri.MiddleInitials + ' ', ' ') + wri.LastName AS Author,
SUM(inv.RetailPrice) AS RetailPrice, SUM(inv.WholeSalePrice) AS WholesalePrice
FROM Inventory inv
JOIN Book boo ON inv.Item_ID = boo.Book_ID
JOIN JNC_BookWriter jnc ON boo.Book_ID = jnc.Book_ID
JOIN Writer wri ON jnc.Writer_ID = wri.Writer_ID
GROUP BY wri.FirstName, wri.MiddleInitials, wri.LastName

--3.3
SELECT boo.Title, inv.Quantity, MIN(inv.WholeSalePrice) AS MinPrice, 
AVG(sal.Quantity * inv.WholeSalePrice) AS AvgWPrice, AVG(sal.Quantity * inv.RetailPrice) AS AvgRPrice, MAX(inv.RetailPrice) AS MaxPrice
FROM Inventory inv
JOIN Book boo ON inv.Item_ID = boo.Book_ID
JOIN JNC_BookWriter jnc ON boo.Book_ID = jnc.Book_ID
JOIN Writer wri ON jnc.Writer_ID = wri.Writer_ID
JOIN Sales sal ON inv.Item_ID = sal.Item_ID
GROUP BY boo.Title, inv.Quantity

--3.4
SELECT boo.Title, inv.Quantity, MIN(inv.WholeSalePrice) AS MinPrice, MAX(inv.RetailPrice) AS MaxPrice FROM Book boo
JOIN Inventory inv ON boo.Book_ID = inv.Item_ID
JOIN Sales sal ON inv.Item_ID = sal.Item_ID
WHERE sal.Quantity = 0
GROUP BY boo.Title, inv.Quantity

