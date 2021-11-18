-- Cleansed Date Dimesion Table
SELECT [DateKey]
      ,[FullDateAlternateKey] AS Date
      --,[DayNumberOfWeek]
      ,[EnglishDayNameOfWeek]
      --,[SpanishDayNameOfWeek]
      --,[FrenchDayNameOfWeek]
      --,[DayNumberOfMonth]
      --,[DayNumberOfYear]
      ,[WeekNumberOfYear] AS WeekNr
      ,[EnglishMonthName] AS Month,
	  LEFT([EnglishMonthName],3) AS MonthShorth
      --,[SpanishMonthName]
      --,[FrenchMonthName]
      ,[MonthNumberOfYear]  AS MonthNr
      ,[CalendarQuarter] AS Quarter
      ,[CalendarYear] AS YEAR
      --,[CalendarSemester]
      --,[FiscalQuarter]
      --,[FiscalYear]
      --,[FiscalSemester]
  FROM [AdventureWorksDW2019].[dbo].[DimDate]

  WHERE CalendarYear  >=2019