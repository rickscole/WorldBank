/****** Object:  View [WB].[VW_Population]    Script Date: 4/6/2022 3:36:09 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE view [WB].[VW_Population] as
select 
p.Population
, Country = cnt.Name
, Year = p.Time
, cnt.GeographyCode
, cnt.IncomeCode
from wb.TBL_Population p
left join WB.VW_CountryNameTranslations cnt
on p.Economy = cnt.Code
GO


