#This script reads CI-V Commander via DDE

import sys
import win32ui
import dde

#create a DDE client and start conversation
server = dde.CreateServer()

server.Create("foo")
conversation = dde.CreateConversation(server)

#Connect to CI-V Commander
try:

	conversation.ConnectTo("CI-V Commander", "CIV_CommanderUI")
	s = "FreqDisplay"
	sl = conversation.Request(s)

except:
	sl = '0'

#f=open('commanderqrg.txt', 'w')
#f.write(sl)
#f.close()
print sl
