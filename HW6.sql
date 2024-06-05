USE FinanceS24

CREATE TABLE [dbo].[TS_MR_DailyData]
(
[Values_ID] [int] NOT NULL IDENTITY(1,1),
[Ticker] [varchar](10) NOT NULL,
[Date] [smalldatetime] NOT NULL,
[Open] [float] NOT NULL,
[High] [float] NOT NULL,
[Low] [float] NOT NULL,
[Close] [float] NOT NULL,
[Volume] [bigint] NULL,
[TimeStamp] [datetime] NOT NULL,
CONSTRAINT [PK_TS_MR_Values] PRIMARY KEY CLUSTERED
( [Values_ID] ASC ),
CONSTRAINT [IX_TS_MR_Values] UNIQUE NONCLUSTERED
( [Date] ASC, [Ticker] ASC, [TimeStamp] ASC )
) ON [PRIMARY]


INSERT INTO TS_MR_DailyData
SELECT ticker, date, [open], [high], [low], [close], volume, getdate()
FROM TS_DailyData

INSERT INTO TS_MR_DailyData (ticker, date, [open], [high], [low], [close], volume, timestamp)
VALUES('ZM', '2024-01-29', 3, 3, 3, 3, 3, getDate())

CREATE View TS_vMR_DailyData AS
WITH MostRecent AS
(SELECT Ticker
,Date
,ts = max(Timestamp)
FROM TS_MR_DailyData
GROUP BY Ticker, Date)

SELECT Ticker = tsmr.Ticker
,Date = tsmr.Date
,[Open] = tsmr.[Open]
,High = tsmr.High
,Low = tsmr.Low
,[Close] = tsmr.[Close]
,Volume = tsmr.Volume
,TimeStamp = tsmr.Timestamp
FROM TS_MR_DailyData tsmr JOIN MostRecent mr
ON mr.ts = tsmr.TimeStamp
AND mr.date = tsmr.date
AND mr.Ticker = tsmr.Ticker


SELECT * FROM TS_vMR_DailyData