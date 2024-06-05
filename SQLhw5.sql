USE FinanceS24

--1: showing each transaction on a date
SELECT tra.Ticker, FORMAT(tra.[Date], 'MM-dd-yyyy') AS Date, tra.Price, tra.Quantity, tsd.[Close] FROM FinanceS24.dbo.Transactions tra
JOIN FinanceS24.dbo.TS_DailyData tsd ON CAST(tsd.date AS DATE) = CAST(tra.date AS DATE) and tsd.ticker = tra.ticker 
ORDER BY tra.Ticker, tra.Date, tra.Quantity

--2: also cost and P/L

SELECT tra.Ticker, FORMAT(tra.[Date], 'MM-dd-yyyy') AS Date, tra.Price, tra.Quantity, tsd.[Close] FROM FinanceS24.dbo.Transactions tra
LEFT JOIN FinanceS24.dbo.TS_DailyData tsd ON CAST(tsd.date AS DATE) = CAST(tra.date AS DATE) and tsd.ticker = tra.ticker 
WHERE Quantity >= 1
ORDER BY tsd.Ticker, tsd.date, Quantity

--3: avg price per ticker
SELECT Ticker, AVG(TotalPrice)/NULLIF(SUM(Quantity), 0) AS AvgPrice FROM (
	SELECT Ticker, Price*Quantity AS TotalPrice, Quantity FROM FinanceS24.dbo.Transactions
	GROUP BY Ticker, Price, Quantity
) AS AvgPrice
GROUP BY Ticker
HAVING AVG(TotalPrice)/NULLIF(SUM(Quantity), 0) > 100

