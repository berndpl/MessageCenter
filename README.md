MessageCenter
=============

A message queue for in-app status messages. Timed and sequential.

# Setup

Setup with background view for message box

	    MessageCenter.shared.setup(view)
        
# Usage

1. Add Messages to present

	    MessageCenter.shared.addMessage(Message(messageText: "No upcoming events"))
	
	
2. Show all queued messages

	    MessageCenter.shared.show()
	
# Feature

* Auto hide. Length of appearance depends on length of message – min. 3 seconds, 0.08 seconds per character
* Tap message to hide