/****** Object:  View [WB].[VW_CountryNameTranslations]    Script Date: 4/7/2022 9:02:04 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

create view [WB].[VW_CountryNameTranslations] as
select
Code
, Name = replace(Name,'|',',')
, GeographyCode
, IncomeCode
from wb.tbl_countrynametranslations
GO


