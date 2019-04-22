use master
go 

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_NAME = 'GetVolumeInfo2')
begin
	EXEC ('CREATE PROC dbo.GetVolumeInfo2 AS SELECT ''PCR code''')
end
go

ALTER PROCEDURE  [dbo].[GetVolumeInfo2] 
(
	 @pCOLUMN_NAME varchar(128) = '' 
)
/*
*****************************************************************************************************************
**   
** VSS Filename         : N/A
** Database Object Name : 
** Author               : Hiten Bhavsar
** Create Date          : 04/02/2019      
** Project/System       : 
** Subproject/Subsystem : N/A
** Purpose/Description  : 
** Input Parameters     : 
** Output Parameters    : N/A
** Database             : master
** Tables               : 
** Function ID          :      
** **************************************************************************************************************     
** Modifications:      
** Date 	 Name  	 	Description      
** ----------- ---------------------- ---------------------------------------------------------------------------  
** 04/22/2019 hbhavsar	1st draft
** **************************************************************************************************************
*/
as   
BEGIN;
	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	SET QUOTED_IDENTIFIER ON;
	SET ANSI_PADDING ON;
	SET CONCAT_NULL_YIELDS_NULL ON;
	SET ANSI_WARNINGS ON;
	SET NUMERIC_ROUNDABORT OFF;
	SET ARITHABORT ON;



	SELECT distinct(volume_mount_point), 
	  total_bytes/1048576 as Size_in_MB, 
	  available_bytes/1048576 as Free_in_MB,
	  (select ((available_bytes/1048576* 1.0)/(total_bytes/1048576* 1.0) *100.00)) as FreePercentage
	FROM sys.master_files AS f CROSS APPLY 
	  sys.dm_os_volume_stats(f.database_id, f.file_id)
	group by volume_mount_point, total_bytes/1048576, 
	  available_bytes/1048576 order by 1
	  

END;
GO

/*

*/



 