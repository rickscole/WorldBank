/****** Object:  StoredProcedure [WB].[SP_InsertInto_GDP]    Script Date: 4/7/2022 9:14:15 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE procedure [WB].[SP_InsertInto_GDP] as


-- delete from actual table
delete from WB.TBL_GDP


-- insert into table
insert into WB.TBL_GDP
select 
sysdatetime()
, GDP = try_convert(float,GDP)
, Economy
, Time = try_convert(int,replace(time,'yr',''))
from stg.TBL_GDP


-- delete from staging table
delete from stg.TBL_GDP


GO


