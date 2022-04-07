/****** Object:  View [WB].[VW_PopulationPecentYear]    Script Date: 4/6/2022 3:39:18 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

create view [WB].[VW_PopulationPecentYear] as
with ty as
(
	select
	year
	, population = sum(population)
	from wb.vw_population
	group by year
)
select 
p.Country
, p.Year
, p.GeographyCode
, p.IncomeCode
, p.Population
, [Population % by Year] = cast(p.Population as float)/ cast(ty.population as float) 
from wb.vw_population p
left join ty
on p.year = ty.year


GO


