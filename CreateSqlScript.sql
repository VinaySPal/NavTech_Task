USE master
CREATE DATABASE EntityMetadata
GO

USE [EntityMetadata]
GO

/****** Object:  UserDefinedTableType [dbo].[EntityConfigType]    Script Date: 8/20/2021 2:59:15 AM ******/
CREATE TYPE [dbo].[EntityConfigType] AS TABLE(
	[EntityName] [varchar](200) NOT NULL,
	[FieldName] [varchar](200) NOT NULL,
	[IsRequired] [bit] NOT NULL,
	[MaxLength] [int] NOT NULL,
	[FieldSource] [varchar](200) NULL
)
GO
/****** Object:  UserDefinedTableType [dbo].[StringList]    Script Date: 8/20/2021 2:59:15 AM ******/
CREATE TYPE [dbo].[StringList] AS TABLE(
	[Fields] [varchar](max) NULL
)
GO
/****** Object:  Table [dbo].[EntityConfiguration]    Script Date: 8/20/2021 2:59:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[EntityConfiguration](
	[EntityName] [varchar](200) NOT NULL,
	[FieldName] [varchar](200) NOT NULL,
	[IsRequired] [bit] NOT NULL,
	[MaxLength] [int] NOT NULL,
	[FieldSource] [varchar](200) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  StoredProcedure [dbo].[USP_GetEntityConfiguration]    Script Date: 8/20/2021 2:59:16 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[USP_GetEntityConfiguration]
(@Fields StringList READONLY)
AS
BEGIN
	SELECT * FROM EntityConfiguration WHERE FieldName in (SELECT DISTINCT Fields FROM @Fields)
END

GO
/****** Object:  StoredProcedure [dbo].[USP_SaveEntityConfiguration]    Script Date: 8/20/2021 2:59:16 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[USP_SaveEntityConfiguration]
(@EntityConfig EntityConfigType READONLY)
AS
BEGIN
	MERGE EntityConfiguration AS EC 
	USING @EntityConfig AS ECT
		ON EC.EntityName = ECT.EntityName AND EC.FieldName = ECT.FieldName 
	WHEN MATCHED THEN 
		UPDATE SET EC.IsRequired = ECT.IsRequired, EC.MaxLength = ECT.MaxLength, EC.FieldSource = ECT.FieldSource 
	WHEN NOT MATCHED THEN 
		INSERT (EntityName,FieldName,IsRequired,MaxLength,FieldSource) 
		VALUES (ECT.EntityName, ECT.FieldName, ECT.IsRequired, ECT.MaxLength, ECT.FieldSource);
END
GO
