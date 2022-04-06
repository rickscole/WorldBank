/****** Object:  StoredProcedure [WB].[SP_InsertInto_Population]    Script Date: 4/6/2022 3:32:31 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [WB].[SP_InsertInto_Population] as


-- delete from actual table
delete from WB.TBL_Population


-- insert into table
insert into WB.TBL_Population
select 
sysdatetime()
, Population = try_convert(bigint,population)
, Economy
, Time = try_convert(int,replace(time,'yr',''))
from stg.TBL_Population


-- delete from staging table
delete from stg.TBL_Population


GO


