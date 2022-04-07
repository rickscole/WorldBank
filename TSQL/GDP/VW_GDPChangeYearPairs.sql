/****** Object:  View [WB].[VW_GDPChangeYearPairs]    Script Date: 4/7/2022 3:10:33 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE view [WB].[VW_GDPChangeYearPairs] as
with t0 as
(
	select
	a.Country
	, [Start Year] = a.year
	, [End Year] = b.year
	, [Difference in Years] = b.year - a.year
	, [Start GDP] = a.[GDP]
	, [End GDP] =  b.[GDP]
	, [GDP Difference] = b.GDP - a.GDP
	, [Start GDP % by Year] = a.[GDP % by Year]
	, [End GDP % by Year] =  b.[GDP % by Year]
	, [Change in % GDP] = b.[GDP % by Year] - a.[GDP % by Year]
	, [Rate of Change in % GDP] = b.[GDP % by Year] / a.[GDP % by Year] - 1
	, [GDP Rate of Change] = cast(b.GDP as float) / cast(a.GDP as float) - 1
	from WB.VW_GDPPecentYear a
	inner join WB.VW_GDPPecentYear b
	on a.Country = b.Country
	and a.year < b.year
	where a.GeographyCode != ''
)
select * 
from t0


GO


