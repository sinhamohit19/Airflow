param (
[Parameter (Mandatory=$true)] [string] $DatabaseName,
[Parameter (Mandatory=$true)| [string] $ResourceGroupName,
[Parameter (Mandatory=$true)][string] $ServerName,
[Parameter (Mandatory=$true)] [string] $operation, 
[Parameter (Mandatory=$true)][String] $SubscriptionName
)

"->"+Operation

$ErrorActionPreference = "Stop"

try
{
"Logging in to Azure..." 
Connect-AzAccount -Identity
}
catch{

Write-Error -Message $_.Exception 
throw $_.Exception
}

Get-AzSubscription -SubscriptionName $SubscriptionName | Set-AzContext

$databases= Get-AzSqlDatabase -ResourceGroupName $ResourceGroupName -ServerName $ServerName
$databases= $databases | Where-Object {$_.Edition -eq "DataWarehouse"}
foreach($database in $databases.databasename)
{
	if ($database.status -eq "Online")
	{
		if ($operation -eq "stop")
		{
			$resultDatabase = suspend-AzSqlDatabase -ServerName $ServerName -DatabaseName $DatabaseName -ResourceGroupName $ResourceGroupName
			"suspend database $database"
		}
		else{
		$operation+" not required on "+$database
		}
		
	}
	if ($database.status -eq "Paused")
	{
		if ($operation -eq "start")
		{
			$resultDatabase = Resume-AzSqlDatabase -ServerName $ServerName -DatabaseName $DatabaseName -ResourceGroupName $ResourceGroupName
			"Resume database $database"
		}
		else{
		$operation+" not required on "+$database
		}
		
	}
	$resultDatabase.status
}
