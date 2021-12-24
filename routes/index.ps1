# Receive HTTP requests for index page:
Add-PodeRoute -Method Get -Path '/' -ScriptBlock {
	Write-PodeViewResponse -Path 'index'
}