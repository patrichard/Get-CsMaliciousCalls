 function Get-CsMaliciousCalls {		
   [CmdletBinding(HelpUri = 'https://github.com/patrichard/Get-CsMaliciousCalls/blob/master/README.md')]
   
   Param(
     # Defines a specific server to query for information. 
     [ValidateNotNullOrEmpty()]
     [string] $Server,
    
     # If defined, specifies a specific SQL isntance to query for information. If not defined, the default instance is used.
     [string] $Instance,
    
     # Defines the SQL database to query.
     [ValidateSet ('cpsdyn','LcsCDR','LcsLog','Lis','lyss','mgc','mgccomp','QoEMetrics','rgsconfig','rgsdyn','rtcab','rtcshared','rtcxds','xds')]
     [ValidateNotNullOrEmpty()]
     [String] $Database = 'LcsCDR',
    
     # Specifies the query to make to the SQL server.
     [ValidateNotNullOrEmpty()]
     [string] $SQLQuery = "SELECT * FROM [LcsCDR].[dbo].[ErrorReportView] WHERE [MsDiagId] = '51017'"
   )
   try{
     If ($Instance){
       $SQLServer = "$($Server)\$($Instance)"
     }else{
       $SQLServer = $Server
     }
     $Datatable = New-Object -TypeName System.Data.DataTable
     $Connection = New-Object -TypeName System.Data.SqlClient.SqlConnection
     $Connection.ConnectionString = "server='$SQlServer';database='$Database';trusted_connection=true;"
     $Connection.Open()
     $Command = New-Object -TypeName System.Data.SqlClient.SqlCommand
     $Command.Connection = $Connection
     $Command.CommandText = $SQLQuery
	
     $Results = $Command.ExecuteReader()
	
     $Datatable.Load($Results)    
	
     return $Datatable
   }
   catch {
     throw $_.Exception
   }  
   finally{
     $Connection.Close()
   }
 } # end function Get-CsMaliciousCalls

# Get-CsMaliciousCalls -Server 'rch-sql-02' -Instance 'skypebe' | Format-Table