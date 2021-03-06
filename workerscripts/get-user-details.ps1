return {
	param(
		$ClientId,
		$FormData
	)

	# NOTE: Param block should have validation rules where possible, though if for convenience in the route
	# definitions we just pass all form data, then we may have to validate within this script rather than in
	# the param block. Another option could be some Pode middleware that parsed form data before even reaching
	# the route.

	$ApplicationRoot = (Get-PodeState -Name ApplicationRoot).ApplicationRoot

	$VerbosePreference = 'continue'

	# There are a number of ways to send data but different approaches should be catered to in server.ps1
	# Details at: https://badgerati.github.io/Pode/Tutorials/Middleware/Types/BodyParsing/

	# 1) Invoke-RestMethod "http://localhost:8091/get-user-details" -UseBasicParsing -Method Post -Body "message=hi"
	# 2) Invoke-RestMethod "http://localhost:8091/get-user-details" -UseBasicParsing -Method Post -Body "{'message':'hi'}" -ContentType "application/json"

	# We'll use JSON so we can send nested data as we'll need this.

	<#
		state is used to describe a task in a process (e.g. pending/dispatched/running).
			# valid values we'll use: running/completed

		status is used to describe an outcome of an operation (e.g. success/fail).
			# valid values we'll use: success/fail/warning
	#>


	# Define a data structure to represent what we're doing. We will periodically post this (and other JSON) to the server
	# which will then broadcast this over the websocket:
	$Data = [PSCustomObject]@{
		clientid  = $ClientId
		name      = 'initialtasklist'
		state     = 'running'
		status    =	''
		taskarray = @(
			[PSCustomObject]@{'taskname' = "Get user '$($FormData.username)' from Active Directory"; 'state' = ''; 'notes' = 'maybe some other information here?' }
			[PSCustomObject]@{'taskname' = 'Connect to Exchange Online'; 'state' = '' }
			[PSCustomObject]@{'taskname' = 'Get User Mailbox'; 'state' = '' }
		)
	}

	# Send the list of tasks:
	Invoke-RestMethod "http://$((Get-PodeConfig).Url):$((Get-PodeConfig).Port)/get-user-details" -Method Post -Body $($Data | ConvertTo-Json -Compress) -UseBasicParsing -ContentType "application/json"


	# Simulate some tasks:
	foreach($Task in $Data.taskarray)
	{
		# Append the clientid to the task so we can be sure to send information to the right client:
		$task | Add-Member -MemberType NoteProperty -Name 'clientid' -Value $ClientId -Force

		# Set the task state to running (note: $Data is updated too when we do this):
		$task | Add-Member -MemberType NoteProperty -Name 'state' -Value 'running' -Force

		# Pass $Task back to inform the client this particular task is running (i.e. we are not sending the entire $Data object - we could but this approach eases things in the frontend JS a little):
		Invoke-RestMethod "http://$((Get-PodeConfig).Url):$((Get-PodeConfig).Port)/get-user-details" -Method Post -Body $($Task | ConvertTo-Json -Compress) -UseBasicParsing -ContentType "application/json"

		# Simulate running the task
		Start-Sleep -Seconds 2

		# Set state to completed and tell the front end we have completed this task:
		$task.state = 'completed'
		Invoke-RestMethod "http://$((Get-PodeConfig).Url):$((Get-PodeConfig).Port)/get-user-details" -Method Post -Body $($Task | ConvertTo-Json -Compress) -UseBasicParsing -ContentType "application/json"
	}


	# Logic should be here to determine overall state (I guess if we reach here we've always 'completed') and status to tell the front end we're done with the tasks:
	$Data.state = 'completed'
	$Data.status = 'success'
	Invoke-RestMethod "http://$((Get-PodeConfig).Url):$((Get-PodeConfig).Port)/get-user-details" -Method Post -Body  $($Data | ConvertTo-Json -Compress) -UseBasicParsing -ContentType "application/json"

	# Write some data for the "output" box?
	$Output = [PSCustomObject]@{
		'clientid'    = $ClientId
		'output'      = 'We finished getting the user details you asked for.'
		'htmlenabled' = $true
	}
	Start-Sleep -Milliseconds 300
	Invoke-RestMethod "http://$((Get-PodeConfig).Url):$((Get-PodeConfig).Port)/get-user-details" -Method Post -Body $($Output | ConvertTo-Json -Compress) -UseBasicParsing -ContentType "application/json"
}