USE AP
--2a
SELECT VendorId, SUM(PaymentTotal) AS PaymentSum FROM Invoices
GROUP BY VendorID

--2b
SELECT ven.VendorName, SUM(PaymentTotal) AS PaymentSum FROM AP.dbo.Vendors ven
JOIN AP.dbo.Invoices inv ON ven.VendorID = inv.VendorID
GROUP BY ven.VendorID, VendorName
ORDER BY VendorName

--2c
SELECT ven.VendorName, COUNT(inv.InvoiceNumber) AS InvoiceCount, 
	SUM(inv.InvoiceTotal) AS InvoiceSum FROM Vendors ven
JOIN Invoices inv ON ven.VendorID = inv.VendorID
GROUP BY ven.VendorName
ORDER BY COUNT(inv.InvoiceNumber) DESC

--2d
SELECT ven.VendorName, COUNT(inv.InvoiceNumber) AS InvoiceCount, 
	SUM(inv.InvoiceTotal) AS InvoiceSum FROM Vendors ven
JOIN Invoices inv ON ven.VendorID = inv.VendorID
GROUP BY ven.VendorName
HAVING SUM(inv.InvoiceTotal) > 500
ORDER BY InvoiceSum DESC

USE FinanceS24
--3a
SELECT Ticker, FORMAT(AVG([Close]), '#.##') AS AverageClosingPrice FROM FinanceS24.dbo.TS_DailyData
GROUP BY Ticker
ORDER BY Ticker

USE LibraryV2
--4a
SELECT pub.[Name], COUNT(CASE WHEN cat.Classification =  'Nonfiction' THEN 1 END) AS 'Nonfiction Books'
FROM LibraryV2.dbo.LBR_Publisher pub
JOIN LibraryV2.dbo.LBR_Book boo ON pub.Publisher_ID = boo.Publisher_ID
JOIN LibraryV2.dbo.LBR_JNC_BookCategorization boc ON boo.Book_ID = boc.Book_ID
JOIN LibraryV2.dbo.LBR_Categorization cat ON boc.Categorization_ID = cat.Categorization_ID
GROUP BY pub.[Name]

USE LibraryV1
--4b
SELECT pub.[Name], COUNT(CASE WHEN cat.Category =  'NonFiction' THEN 1 END) AS 'Nonfiction Books'
FROM LibraryV1.dbo.LBR_BookClassification cla
JOIN LibraryV1.dbo.LBR_Book boo ON cla.Classification_ID = boo.Classification_ID
JOIN LibraryV1.dbo.LBR_Publisher pub ON boo.Publisher_ID = pub.Publisher_ID
JOIN LibraryV1.dbo.LBR_BkCategory cat ON cla.Category_ID = cat.Category_ID
GROUP BY pub.[Name]

USE LibraryV2
--4c
SELECT AVG(LEN(Title)) AS 'Average length of a book title',
	MIN(LEN(Title)) AS 'Min length of a book title',
	MAX(LEN(Title)) AS 'Max length of a book title'
FROM LibraryV2.dbo.LBR_Book