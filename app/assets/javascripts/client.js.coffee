

addMessage = (msg) ->
	msg = JSON.parse(msg) if typeof(msg) == 'string'
	msg.time 	= new Date(msg.timestamp); 
	$("#chat").append($("#msg-template").render(msg));
	$(".chat-view").scrollTo("li:last-child")
	


$(document).ready(()->
	$(".chat-view").scrollTo("li:last-child")
	window.socket = new io.connect('http://alleycat.talkie.se:3001?username=buffpojken&key=admin')
	window.socket.on 'connect', ()->
	window.socket.on 'message', (msg)->
		addMessage(msg)
	window.socket.on 'invalid', (msg) ->		
		new Notification(msg, 'error');
	window.socket.on 'disconnect', ()->
		console.log "ping"
	window.socket.on 'close', ()->
		console.log 'close'	


	$("#msg").bind('keyup',(e)->
		if e.which == 13
			window.socket.send $(this).val()
			addMessage({
				name: window.info.name, 
				timestamp: new Date().getTime(), 
				message: $(this).val()
			});
			$(this).val("");
	)
)



