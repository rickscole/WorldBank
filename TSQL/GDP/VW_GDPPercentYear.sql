/****** Object:  View [WB].[VW_GDPPecentYear]    Script Date: 4/7/2022 3:09:17 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


create view [WB].[VW_GDPPecentYear] as
with ty as
(
	select
	year
	, GDP = sum(GDP)
	from wb.vw_gdp
	group by year
)
select 
p.Country
, p.Year
, p.GeographyCode
, p.IncomeCode
, p.GDP
, [GDP % by Year] = cast(p.GDP as float)/ cast(ty.gdp as float) 
from wb.vw_gdp p
left join ty
on p.year = ty.year


GO


