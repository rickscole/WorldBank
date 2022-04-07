/****** Object:  View [WB].[VW_CountryGDP_MaxAndMin]    Script Date: 4/7/2022 3:12:12 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--select * from [WB].[VW_GDPChangeYearPairs]

--select
--country
--, max([GDP % by year])
--from [WB].[VW_GDPPecentYear]
--group by country

create view [WB].[VW_CountryGDP_MaxAndMin] as 
with t0 as
(
	select *
	, most_year_country_id = row_number() over(partition by country order by [GDP % by year] desc)
	, least_year_country_id = row_number() over(partition by country order by [GDP % by year] asc)
	from [WB].[VW_GDPPecentYear]
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


