# Receive HTTP requests for a 'task page' with form submission:
Add-PodeRoute -Method Get -Path '/get-user-details' -ScriptBlock {
	"$($WebEvent.Route.Path) invoked with method: $($WebEvent.Route.Method) and session ID $($WebEvent.Session.Id)" | Out-Default
	Write-PodeViewResponse -Path 'get-user-details'
}

# Receive websocket requests from the aforementioned 'task page' - this should be form submission data
# and we should trigger the script that does the work in here:
Add-PodeSignalRoute -Path '/get-user-details' -ScriptBlock {
	"$($SignalEvent.Path) invoked with method: $($SignalEvent.Route.Method), client ID $($SignalEvent.ClientID) session ID $($SignalEvent.Request.Body.sessionid)" | Out-Default

	#$SignalEvent.Request.Body | Out-File "SignalEvent.Request.Body.json" -Force

	Lock-PodeObject -ScriptBlock {
		# attempt to get the hashtable from the state
		$ClientIDs = (Get-PodeState -Name 'ClientIDs')
		if($ClientIDs -notcontains $SignalEvent.ClientID)
		{
			$ClientIDs.IDs += $SignalEvent.ClientID
		}
		Save-PodeState -Path './state.json'
	}

	Invoke-PodeSchedule -Name 'get-user-details'

	#Region comments
	# $SignalEvent is built in. Pode puts any data received into a subproperty called .Data
	#$SignalEvent | Out-Default
	# For an example of the kind of data received see 'exampledata/SignalEvent.json'

	<#
		Data we care about:
		$SignalEvent.Data will contain all properties submitted by JavaScript - i.e. form data and other stuff if the user can manipulate this.
		$SignalEvent.ClientID
		$SignalEvent.Request.Url: "ws://localhost:8091/get-user-details"
		$SignalEvent.Request.Host: "localhost:8091"
	#>
	#EndRegion comments

	# Send a websocket message back to the originating client to say we've started though at the moment the frontend
	# isn't doing anything with this data:
	Send-PodeSignal -Value @{
		message = "Invoke has triggered"
		state   = "requested"
	} -ClientId $SignalEvent.ClientID
}

# Receive HTTP POST requests (i.e. from an associated PowerShell task script doing work):
Add-PodeRoute -Method Post -Path '/get-user-details' -ScriptBlock {

	# $WebEvent is built in. Pode puts any data received into a subproperty called .Data
	$WebEvent.Data | Out-Default

	# We could just pass $WebEvent.Data to Send-PodeSignal but consider that we may want to add additional
	# data to the object so we may want to construct our own custom object with some nesting.

	# 1) Just send back whatever has been posted:
	# Send-PodeSignal -Value $WebEvent.Data

	# 2) Construct a custom object:

	# If the data being posted has a taskarray property then assume this is the intial request containing a list of tasks
	if($WebEvent.Data.taskarray)
	{
		# Convert the list of tasks into a HTML table
		# We could do this on the client side of course but it was faster to code here:
		$taskarraytohtml = $WebEvent.Data.taskarray | Select-Object taskname, state | ConvertTo-Html -Fragment
		$taskarraytohtml = $taskarraytohtml -replace "<table>", "<table class='table table-striped table-sm' id='tasklisttable'>"
		$taskarraytohtml = $taskarraytohtml -replace "<colgroup><col\/><col\/><\/colgroup>", "<thead class='thead-dark'>"
		$taskarraytohtml = $taskarraytohtml -replace "<\/th><\/tr>", "</th></tr></thead><tbody>"
		$taskarraytohtml = $taskarraytohtml -replace "<\/table>", "</tbody></table>"
		$taskarraytohtml = $taskarraytohtml -replace "<td>", "<td class='align-middle'>"

		# If we don't join this up into a single line, when inserting with jQuery it'll insert <table> and then automatically
		# add a </table> afterwards.
		$taskarraytohtml = $taskarraytohtml -join ""

		# Send data over the websocket:
		Send-PodeSignal -Value @{
			datetime        = $Date
			data            = $WebEvent.Data
			taskarraytohtml = $taskarraytohtml
		}
	}
	else
	{
		# Send data over the websocket:
		Send-PodeSignal -Value @{
			datetime = $Date
			data     = $WebEvent.Data
		}
	}
}