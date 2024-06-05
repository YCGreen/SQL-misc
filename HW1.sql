--3a
USE AP
SELECT VendorContactLName, VendorContactFName, VendorName FROM AP.dbo.Vendors
ORDER BY VendorContactLName, VendorContactFName

--3b
SELECT InvoiceNumber AS Number, InvoiceTotal AS Total, PaymentTotal+CreditTotal AS Credits, InvoiceTotal - PaymentTotal+CreditTotal AS Balance FROM AP.dbo.Invoices


--3c
SELECT VendorContactLName + ', ' + VendorContactFName FROM AP.dbo.Vendors
ORDER BY VendorContactLName, VendorContactFName

--4a
USE FinanceS24
SELECT Date, FORMAT([Close]-[Open], '#.00') AS IntraDayChange FROM FinanceS24.dbo.TS_DailyData
WHERE Ticker = 'GLD' AND ([Close]-[Open]) > 2.50
ORDER BY IntraDayChange DESC

--4b
SELECT Date, FORMAT(ABS([Close]-[Open]), '#.00') AS IntraDayChange FROM FinanceS24.dbo.TS_DailyData
WHERE Ticker = 'GLD' AND ABS([Close]-[Open]) > 2.50
ORDER BY IntraDayChange DESC

--4c
SELECT Date, FORMAT([High]-[Low], '#.00') AS IntraDayRange FROM FinanceS24.dbo.TS_DailyData
WHERE Ticker = 'GLD' AND [High]-[Low] > 2.50
ORDER BY IntraDayRange DESC

--4d
SELECT Date, FORMAT([Close]-[Open], '#.00') AS IntraDayChange, FORMAT([High]-[Low], '#.00') AS IntraDayRange FROM FinanceS24.dbo.TS_DailyData
WHERE Ticker = 'GLD' AND [High]-[Low] > 2.50
ORDER BY IntraDayRange DESC

--5a
USE LibraryV1
SELECT Title, ISBN FROM LibraryV1.dbo.LBR_Book
WHERE LEN(Title) > 40
ORDER BY LEN(Title) DESC

--5b
SELECT Title, ISBN FROM LibraryV1.dbo.LBR_Book
WHERE LEN(Title) > 40 OR LEN(Title) < 20
ORDER BY LEN(Title), Title

--5c
SELECT Title, ISBN FROM LibraryV1.dbo.LBR_Book
WHERE LEN(Title) < 40 AND LEN(Title) > 20
ORDER BY LEN(Title), Title 

--5d
SELECT Title FROM LibraryV1.dbo.LBR_Book
WHERE Title LIKE '%pro%'
ORDER BY Title