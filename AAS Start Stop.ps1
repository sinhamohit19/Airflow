param (
[Parameter (Mandatory=$true)] [string] $SubscriptionName,
[Parameter (Mandatory=$true)] [string] $ResourceGroupName,
[Parameter (Mandatory=$true)] [string] $AnalysisServers,
[Parameter (Mandatory=$true)] [string] $Operation,

)


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

foreach($serverName in $AnalysisServers)
{
	$ServerDetails = Get-AzAnalysisServicesServer -ResourceGroupName $ResourceGroupName -Name $serverName
	"Name->"+$ServerDetails.state
	if ($ServerDetails.state -eq "Paused")
	{
		if($Operation -eq "start")
		{
			$resultDatabase= Resume-AzAnalysisServicesServer -Name $ServerDetails.Name -ResourceGroupName $ResourceGroupName
			"Resume database"+ $ServerDetails.Name
		}
	}
	if ($ServerDetails.state -eq "Succeeded")
	{
		if($Operation -eq "stop")
		{
			$resultDatabase= Suspend-AzAnalysisServicesServer -Name $ServerDetails.Name -ResourceGroupName $ResourceGroupName
			"Suspend database"+ $ServerDetails.Name
		}
	}
	$resultDatabase
}