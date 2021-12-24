if(!(Get-Module -Name Pode -ListAvailable -ErrorAction SilentlyContinue))
{
	throw "You must install the Pode module."
}

Start-PodeServer {

	New-PodeLoggingMethod -Terminal | Enable-PodeErrorLogging -Level Error, Debug, Verbose

	Set-PodeViewEngine -Type Pode

	Enable-PodeSessionMiddleware -Duration 1200 -Extend

	########################################################################################
	#Region Server Level Thread Safe 'state' objects
	Lock-PodeObject -ScriptBlock {
		Set-PodeState -Name 'ApplicationRoot' -Value @{ 'ApplicationRoot' = $PSScriptRoot } | Out-Null
	}
	#EndRegion Server Level Thread Safe Objects

	########################################################################################
	#Region Additional state objects
	Set-PodeState -Name 'ClientIDs' -Value @{'IDs' = @() } | Out-Null
	#EndRegion Additional state objects

	########################################################################################
	#Region Listeners
	Add-PodeEndpoint -Address (Get-PodeConfig).Url -Port $(Get-PodeConfig).Port -Protocol Http
	Add-PodeEndpoint -Address (Get-PodeConfig).Url -Port $(Get-PodeConfig).Port -Protocol Ws
	#EndRegion Listeners

	########################################################################################
	#Region Schedules
	Add-PodeSchedule -Name 'get-user-details' -Cron '@annually' -StartTime (Get-Date).AddDays(9999) -FilePath "./workerscripts/get-user-details.ps1"
	#EndRegion Schedules

	########################################################################################
	#Region Routes
	Use-PodeRoutes -Path "routes"

} -Threads 3