### Built using Pode:

  * Documentation: https://badgerati.github.io/Pode/
  * Github: https://github.com/Badgerati/Pode/

### Summary of Demo:

> * Provides a webserver that listens on both HTTP and Websockets.<br>
> * Client application (e.g. browser) can make an initial connection over HTTP. Included JavaScript opens a websocket to the server.<br>
> * Form data is posted over the websocket.<br>
> * This triggers a backend script that makes (internal) HTTP POST requests to the server, which then relays JSON data over the websocket to the client. Custom javascript decides on how this is rendered in theb browser.

### Prereqs:

  * Install Pode (recommended as admin for global scope): `Install-Module -Name Pode -Scope AllUsers`

### To run:

  * Start the server: `.\server.ps1`
  * In a browser go to: `http://localhost:8091/get-user-details`
  * Watch the webpage update.

### Toggle an individual task:
You can toggle individual tasks with a POST request. This will be useful for debugging/looking at css styling between running and completed states, and help understand how the front end is updated! For example:
```
Invoke-RestMethod "http://localhost:8091/get-user-details" -Method Post -Body '{"taskname":"Get user from Active Directory","state":"running"}' -UseBasicParsing -ContentType "application/json"
```