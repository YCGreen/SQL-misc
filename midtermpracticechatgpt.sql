USE MidtermS24

SELECT * FROM MidtermS24.dbo.Contract
SELECT * FROM MidtermS24.dbo.Trader
SELECT * FROM MidtermS24.dbo.TS_History
SELECT * FROM MidtermS24.dbo.Counterparty
SELECT * FROM MidtermS24.dbo.Equity

--1.1
SELECT DISTINCT Ticker, FORMAT(TradeDate, 'yyyy-MM-dd') AS 'Date' FROM MidtermS24.dbo.Contract
WHERE TradeDate > '2023-01-01'

--1.2
SELECT DISTINCT tra.Firstname, tra.Lastname FROM MidtermS24.dbo.Contract con
JOIN MidtermS24.dbo.Counterparty cou ON cou.Counterparty_ID = con.CounterParty_ID
JOIN MidtermS24.dbo.Trader tra ON con.Trader_ID = tra.Trader_ID
WHERE cou.Counterparty_ID = 1

--1.3
SELECT Ticker, Quantity, Price FROM MidtermS24.dbo.Contract
WHERE Price > 100

--1.4
SELECT DISTINCT cou.Name FROM MidtermS24.dbo.Counterparty cou
JOIN MidtermS24.dbo.Contract con ON con.CounterParty_ID = cou.Counterparty_ID
WHERE con.Trader_ID = 1

--1.5
SELECT DISTINCT Ticker FROM MidtermS24.dbo.Contract
WHERE Trader_ID = 2

--2.1 
SELECT TradeDate, Quantity FROM MidtermS24.dbo.Contract
WHERE Quantity > 200

--2.2
SELECT DISTINCT Ticker, High 
FROM MidtermS24.dbo.TS_History
WHERE High > (SELECT AVG(High) FROM MidtermS24.dbo.TS_History);

--2.3
SELECT equ.Ticker, Sector, Name FROM MidtermS24.dbo.Equity equ
LEFT JOIN MidtermS24.dbo.Contract con ON con.Ticker = equ.Ticker
WHERE Sector = 'Technology' AND con.Ticker IS Null

--2.4
SELECT Name, SUM(con.Quantity) AS TotalQuantity FROM MidtermS24.dbo.Counterparty cou
LEFT JOIN MidtermS24.dbo.Contract con ON cou.Counterparty_ID = con.CounterParty_ID
GROUP BY Name

--2.5
SELECT tra.Trader_ID, LastName, FirstName, SUM(con.Quantity) AS Quantity FROM MidtermS24.dbo.Trader tra
LEFT JOIN MidtermS24.dbo.Contract con ON con.Trader_ID = tra.Trader_ID
GROUP BY tra.Trader_ID, LastName, FirstName

--3.1
SELECT TOP 3 T.Trader_ID, T.Lastname, T.Firstname, SUM(C.Quantity) AS TotalQuantityTraded
FROM MidtermS24.dbo.Trader T
JOIN MidtermS24.dbo.Contract C ON T.Trader_ID = C.Trader_ID
GROUP BY T.Trader_ID, T.Lastname, T.Firstname
ORDER BY TotalQuantityTraded DESC

--3.2
SELECT cou.CounterParty_ID, Name, Address, SUM(Quantity) AS Quantity FROM MidtermS24.dbo.Counterparty cou
JOIN MidtermS24.dbo.Contract con ON con.CounterParty_ID = cou.CounterParty_ID
GROUP BY cou.Counterparty_ID, Name, Address
HAVING SUM(Quantity) > 500

--3.3
SELECT Ticker, Date, [Close],
	FORMAT(LAG([Close], 1, 0) OVER(ORDER BY Date), '#.##') AS DiffPrice
FROM MidtermS24.dbo.TS_History
ORDER BY Ticker

--ANSWER
SELECT Ticker, Date, [Close], 
       [Close] - LAG([Close]) OVER(PARTITION BY Ticker ORDER BY Date) AS PriceDifference
FROM MidtermS24.dbo.TS_History
ORDER BY Ticker, Date;

--3.4
SELECT tra.Trader_ID, LastName, FirstName, SUM(con.Quantity) AS Quantity FROM MidtermS24.dbo.Trader tra
JOIN MidtermS24.dbo.Contract con ON con.Trader_ID = tra.Trader_ID
GROUP BY tra.Trader_ID, FIrstName, LastName
HAVING SUM(Quantity) > 0

--3.5
SELECT con.CounterParty_ID, cou.Name, AVG(Price*Quantity) AS AveragePrice FROM MidtermS24.dbo.Contract con
JOIN MidtermS24.dbo.Counterparty cou ON cou.Counterparty_ID = con.CounterParty_ID
GROUP BY con.CounterParty_ID, cou.Name
ORDER BY AveragePrice DESC