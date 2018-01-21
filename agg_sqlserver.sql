SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE dbo.CalculateAggregates
AS
BEGIN

	SET NOCOUNT ON;

	DECLARE @StatsTable AS TABLE (
		[group] int,
		mad float
	);
	INSERT INTO @StatsTable
	EXEC sp_execute_external_script
	@language =N'R',
	@script=N'
	result <- aggregate(InputDataSet$value, by=list(InputDataSet$group), FUN=mad)
	colnames(result)<- c("group", "mad")
	OutputDataSet<-result
	',
	@input_data_1 =N'SELECT [group], value from dbo.testing_data'
	SELECT data1.[group], data1.mean, data2.mad FROM (
		SELECT [group], AVG(value) as mean from dbo.testing_data 
		group by [group]
	) data1 
	JOIN @StatsTable data2 ON data1.[group] = data2.[group]
END
GO
