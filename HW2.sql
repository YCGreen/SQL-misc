--2a
USE AP;
SELECT VendorName, InvoiceNumber, InvoiceDate, InvoiceTotal - (PaymentTotal + CreditTotal) AS Balance
FROM AP.dbo.Vendors
JOIN AP.dbo.Invoices ON AP.dbo.Vendors.VendorID = AP.dbo.Invoices.VendorID
WHERE InvoiceTotal - (PaymentTotal + CreditTotal) != 0
ORDER BY AP.dbo.Vendors.VendorName ASC;

--2b
SELECT VendorName, DefaultAccountNo, AccountDescription FROM AP.dbo.Vendors
JOIN AP.dbo.GLAccounts ON AP.dbo.Vendors.DefaultAccountNo = AP.dbo.GLAccounts.AccountNo
ORDER BY AccountDescription, VendorName;

--2c
SELECT VendorName AS Vendor, InvoiceDate AS [Date], InvoiceNumber AS Number, InvoiceSequence AS  #, InvoiceLineItemAmount AS LineItem
FROM AP.dbo.Vendors ven
JOIN AP.dbo.Invoices inv ON ven.VendorID = inv.VendorID
JOIN AP.dbo.InvoiceLineItems ili ON inv.InvoiceID = ili.InvoiceID
ORDER BY Vendor, [Date], Number, #

--2d
SELECT gla.AccountNo, AccountDescription FROM AP.dbo.GLAccounts gla
LEFT OUTER JOIN AP.dbo.InvoiceLineItems inv ON inv.AccountNo = gla.AccountNo
WHERE inv.AccountNo IS NULL
ORDER BY gla.AccountNo

--2e
WITH VendorStates AS (
    SELECT 
        VendorName,
        CASE 
            WHEN VendorState != 'California' THEN 'Outside CA'
        END AS VendorState
    FROM AP.dbo.Vendors
)
SELECT VendorName, VendorState
FROM VendorStates
UNION ALL
SELECT VendorName, 'CA'
FROM AP.dbo.Vendors
ORDER BY VendorName

USE FinanceS24
--3a
SELECT FORMAT(IBM.[Date], 'MM-dd-yyyy') AS 'Date', IBM.[Close] AS 'IBM Close', GLD.[Close] AS 'GLD Close'
FROM (
    SELECT [Date], [Close]
    FROM FinanceS24.dbo.TS_DailyData
    WHERE Ticker = 'IBM'
) AS IBM
JOIN (
    SELECT [Date], [Close]
    FROM FinanceS24.dbo.TS_DailyData
    WHERE Ticker = 'GLD'
) AS GLD
ON IBM.[Date] = GLD.[Date];

--3b
SELECT FORMAT(IBM.[Date], 'MM-dd-yyyy') AS 'Date', IBM.[Close] AS 'IBM Close', GLD.[Close] AS 'GLD Close'
FROM (
    SELECT [Date], [Close]
    FROM FinanceS24.dbo.TS_DailyData
    WHERE Ticker = 'IBM'
) AS IBM
JOIN (
    SELECT [Date], [Close]
    FROM FinanceS24.dbo.TS_DailyData
    WHERE Ticker = 'GLD' 
) AS GLD
ON IBM.[Date] = GLD.[Date]
WHERE IBM.[Close] > GLD.[Close]

USE LibraryV1
--4a
SELECT Title, ISBN, loc.Location
FROM LibraryV1.dbo.LBR_Book boo
LEFT JOIN LibraryV1.dbo.LBR_Location loc ON loc.Location_ID = boo.Location_ID
ORDER BY Title ASC;

--4b
SELECT boo.Title, cat.Category, gen.Genre, fie.Field, sub.Subfield
FROM LibraryV1.dbo.LBR_Book boo
LEFT JOIN LibraryV1.dbo.LBR_BookClassification cla ON  cla.Classification_ID = boo.Classification_ID
LEFT JOIN LibraryV1.dbo.LBR_BkCategory cat ON cat.Category_ID = cla.Category_ID
LEFT JOIN LibraryV1.dbo.LBR_BkGenre gen ON gen.Genre_ID = cla.Genre_ID
LEFT JOIN LibraryV1.dbo.LBR_BkField fie ON fie.Field_ID = cla.Field_ID
LEFT JOIN LibraryV1.dbo.LBR_BkSubField sub ON sub.Subfield_ID = cla.SubField_ID
ORDER BY Title ASC;

--4c
SELECT boo.Title, ISNULL(cat.Category, 'N/A') AS Category, ISNULL(gen.Genre, 'N/A') AS Genre, 
	ISNULL(fie.Field, 'N/A') AS Field, ISNULL(sub.Subfield, 'N/A') AS Subfield
FROM LibraryV1.dbo.LBR_Book boo
LEFT JOIN LibraryV1.dbo.LBR_BookClassification cla ON  cla.Classification_ID = boo.Classification_ID
LEFT JOIN LibraryV1.dbo.LBR_BkCategory cat ON cat.Category_ID = cla.Category_ID
LEFT JOIN LibraryV1.dbo.LBR_BkGenre gen ON gen.Genre_ID = cla.Genre_ID
LEFT JOIN LibraryV1.dbo.LBR_BkField fie ON fie.Field_ID = cla.Field_ID
LEFT JOIN LibraryV1.dbo.LBR_BkSubField sub ON sub.Subfield_ID = cla.SubField_ID
ORDER BY Title ASC;