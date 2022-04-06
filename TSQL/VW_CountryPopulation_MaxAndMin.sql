/****** Object:  View [WB].[VW_CountryPopulation_MaxAndMin]    Script Date: 4/6/2022 3:40:27 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

create view [WB].[VW_CountryPopulation_MaxAndMin] as 
with t0 as
(
	select *
	, most_year_country_id = row_number() over(partition by country order by [population % by year] desc)
	, least_year_country_id = row_number() over(partition by country order by [population % by year] asc)
	from [WB].[VW_PopulationPecentYear]
)
select *
, [Max or Min] = 'Max'
from t0
where most_year_country_id = 1

union all

select *
, [Max or Min] = 'Min'
from t0
where least_year_country_id = 1
GO


