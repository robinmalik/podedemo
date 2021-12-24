$(document).ready(() =>
{
    //var pagename = location.href.split("/").slice(-1)
    var pagename = location.href.split("/").slice(-1)[ 0 ].split('?')[ 0 ]

    function getCookie(name)
    {
        const value = `; ${document.cookie}`
        const parts = value.split(`; ${name}=`)
        if(parts.length === 2) return parts.pop().split(';').shift()
    }

    // Bind submit on the form to send message to the server
    var formselector = "form[name='" + pagename + "']"
    $(formselector).submit(function(e)
    {
        console.log('Form submission triggered')
        let cookie = getCookie('pode.sid')
        e.preventDefault()
        var msg = {
            sessionid: cookie,
            message: 'submitting over websocket',
            date: Date.now(),
            path: "/" + pagename,
            formdata: $(formselector).serialize(),
            direct: true
        }
        ws.send(JSON.stringify(msg))
        $("#submit").addClass('disabled')
    })


    // Create the websocket (note this is hardcoded to a specific path at the moment):
    var ws = new WebSocket("ws://localhost:8091/" + pagename)

    // Event to receive inbound websocket messages:
    ws.onmessage = function(evt)
    {
        // Log to the console:
        console.log(JSON.parse(evt.data))

        // Parse the incoming JSON into an object:
        var message = JSON.parse(evt.data)

        // Handle the initial task list when running:
        if(message.data.name == 'initialtasklist' && message.data.state == 'running')
        {
            $('#tasklistbutton').text('Starting...')

            // Add table:
            $('#tasklistoutput').html(message.taskarraytohtml)

            $('#tasklistbody').collapse("show")

        }
        else if(message.data.name == 'initialtasklist' && message.data.state == 'completed')
        {
            // If the object has a state property of completed, then the task script has finished.
            if(message.data.status == 'success')
            {
                $('#tasklistbutton').text('Finished')
                //$('#tasklist').collapse("hide");
            }
            else if(message.data.status == 'fail')
            {
                $('#tasklistbutton').text('Finished with errors :(')
            }
            else
            {

            }
        }
        else if(message.data.taskname)
        {
            var taskname = message.data.taskname
            console.log('Task update for task: ' + taskname + '. State is: ' + message.data.state)
            if(message.data.state == 'running')
            {
                $("td:contains(" + taskname + ")").next().html("<span id='loader1' class='loader'></span>")
            }
            else if(message.data.state == 'completed')
            {
                $("td:contains(" + taskname + ")").next().html("<svg class='checkmark' xmlns='http://www.w3.org/2000/svg' viewBox='0 0 52 52'><circle class='checkmark__circle' cx='26' cy='26' r='25' fill='none' /><path class='checkmark__check' fill='none' d='M14.1 27.2l7.1 7.2 16.7-16.8' /></svg>")
            }
            else
            {

            }
        }
        else if(message.data.output)
        {
            $('#tasklistbody').collapse("hide")
            $('#outputbutton').html('<strong>Output:</strong>')
            if(message.data.htmlenabled == false)
            {
                $('#output').text(message.data.output)
            }
            else
            {
                $('#output').html(message.data.output)
            }
            $('#outputbody').collapse("show")
        }
        else
        {
            console.log('Parent else clause')
        }
    }
});