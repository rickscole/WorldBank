/****** Object:  View [WB].[VW_PopulationChangeYearPairs]    Script Date: 4/6/2022 3:43:26 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE view [WB].[VW_PopulationChangeYearPairs] as
with t0 as
(
	select
	a.Country
	, [Start Year] = a.year
	, [End Year] = b.year
	, [Difference in Years] = b.year - a.year
	, [Start Population] = a.[Population]
	, [End Population] =  b.[Population]
	, [Population Difference] = b.Population - a.Population
	, [Start Population % by Year] = a.[Population % by Year]
	, [End Population % by Year] =  b.[Population % by Year]
	, [Change in % Population] = b.[Population % by Year] - a.[Population % by Year]
	, [Rate of Change in % Population] = b.[Population % by Year] / a.[Population % by Year] - 1
	, [Population Rate of Change] = cast(b.Population as float) / cast(a.Population as float) - 1
	from WB.VW_PopulationPecentYear a
	inner join WB.VW_PopulationPecentYear b
	on a.Country = b.Country
	and a.year < b.year
	where a.GeographyCode != ''
)
select * 
from t0


GO


