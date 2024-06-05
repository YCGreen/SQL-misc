USE MidtermS24

--1.1
SELECT TradeDate, Ticker, Quantity, Price 
FROM MidtermS24.dbo.Contract

--1.2
SELECT DISTINCT * FROM MidtermS24.dbo.TS_History
SELECT tsh.Ticker, COUNT(DISTINCT Transaction_ID) AS Trades FROM MidtermS24.dbo.TS_History tsh
LEFT JOIN MidtermS24.dbo.Contract con ON con.Ticker = tsh.Ticker
WHERE Date BETWEEN '2023-01-01' AND '2023-01-31'
GROUP BY tsh.Ticker

SELECT Ticker, COUNT(Transaction_ID) AS Trades FROM MidtermS24.dbo.Contract
WHERE TradeDate BETWEEN '2023-01-01' AND '2023-01-31'
GROUP BY Ticker


--1.3
SELECT Ticker, FORMAT(AVG(Volume), 'N') AS AvgVolume, FORMAT(AVG([Close]), '#.##') AS AvgClose FROM MidtermS24.dbo.TS_History
GROUP BY Ticker
SELECT * FROM MidtermS24.dbo.TS_History

--1.4
SELECT Ticker, FORMAT(MAX([Close] - [Open]), '#.##') AS MaxChange FROM MidtermS24.dbo.TS_History
GROUP BY Ticker

--2.1
SELECT Ticker, FORMAT(MAX([Close] - [Open]), '#.##') AS MaxChange, (
	SELECT FORMAT(Date, 'yyyy-MM-dd') FROM MidtermS24.dbo.TS_History
	WHERE [Close] - [Open] = MaxChange)
FROM MidtermS24.dbo.TS_History
GROUP BY Ticker, Date


--2.2
SELECT CONCAT(FirstName, ' ', LastName) AS 'Name', COUNT(DISTINCT con.Ticker) AS 'Equities' FROM MidtermS24.dbo.Trader tra
LEFT JOIN MidtermS24.dbo.Contract con ON tra.Trader_ID = con.Trader_ID
GROUP BY CONCAT(FirstName, ' ', LastName)

--2.3
SELECT Ticker, FORMAT(MAX(High/Low-1), 'P2') AS 'Max Relative Change' FROM MidtermS24.dbo.TS_History
GROUP BY Ticker
ORDER BY MAX(High/Low-1) ASC
SELECT * FROM MIdtermS24.dbo.TS_History

--2.4
SELECT DISTINCT TradeDate, con.Ticker, Price, Quantity, [Close], cou.Name AS CounterParty, tra.LastName
FROM MidtermS24.dbo.Contract con
 JOIN MidtermS24.dbo.Counterparty cou ON cou.Counterparty_ID = con.CounterParty_ID
 JOIN MidtermS24.dbo.TS_History tsh ON tsh.Ticker = con.Ticker
 JOIN MidtermS24.dbo.Trader tra ON tra.Trader_ID = con.Trader_ID
WHERE Date < '2023-02-07'
ORDER BY TradeDate, con.Ticker, tra.Lastname

--3.1
SELECT con.Ticker, TradeDate, Price, [Close], FORMAT(([Close]-Price) * Quantity, '#.##') AS Profit
FROM MidtermS24.dbo.Contract con
JOIN MidtermS24.dbo.TS_History tsh ON tsh.Ticker = con.Ticker
GROUP BY con.Ticker, TradeDate, Price, [Close], Quantity
HAVING SUM(([Close]-Price) * Quantity) > 0
ORDER BY Profit DESC

SELECT 
    con.Ticker, 
    con.TradeDate, 
    con.Price, 
    tsh.[Close], 
    ABS((tsh.[Close] - con.Price) * con.Quantity) AS Profit
FROM 
    MidtermS24.dbo.Contract con

JOIN MidtermS24.dbo.TS_History tsh ON tsh.Ticker = con.Ticker

WHERE 
    (con.Price < tsh.[Close] AND con.Quantity > 0) OR
    (con.Price > tsh.[Close] AND con.Quantity < 0)
ORDER BY 
    Profit DESC;


--3.2
SELECT Sector, FORMAT(SUM(ABS(Price * Quantity)), 'N') AS Value
FROM MidtermS24.dbo.Contract con
JOIN MidtermS24.dbo.Equity equ ON con.Ticker = equ.Ticker
GROUP BY equ.Sector
ORDER BY Value DESC;

--3.3
SELECT CONCAT(FirstName, ' ', LastName) AS 'Name', Ticker, COUNT(con.Ticker) AS 'Contracts' FROM MidtermS24.dbo.Trader tra
JOIN MidtermS24.dbo.Contract con ON tra.Trader_ID = con.Trader_ID
GROUP BY CONCAT(FirstName, ' ', LastName), Ticker
ORDER BY 'Name'