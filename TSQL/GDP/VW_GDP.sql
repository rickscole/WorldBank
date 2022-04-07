/****** Object:  View [WB].[VW_GDP]    Script Date: 4/7/2022 9:17:04 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




CREATE view [WB].[VW_GDP] as
select 
p.GDP
, Country = cnt.Name
, Year = p.Time
, cnt.GeographyCode
, cnt.IncomeCode
from wb.TBL_GDP p
left join WB.VW_CountryNameTranslations cnt
on p.Economy = cnt.Code
GO


