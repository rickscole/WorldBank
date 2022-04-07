/****** Object:  Table [WB].[TBL_Population]    Script Date: 4/6/2022 3:34:53 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [WB].[TBL_Population](
	[PK_ID_Population] [int] IDENTITY(1,1) NOT NULL,
	[TS_Population] [datetime2](7) NULL,
	[Population] [bigint] NULL,
	[Economy] [nvarchar](100) NULL,
	[Time] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[PK_ID_Population] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO


