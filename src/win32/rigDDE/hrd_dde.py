#This script reads HRD via DDE

import sys
import win32ui
import dde

#create a DDE client and start conversation
server = dde.CreateServer()

#server.Create("hrd_dde.py")
server.Create("foo")
conversation = dde.CreateConversation(server)

#Connect to HRD
try:
	conversation.ConnectTo(sys.argv[1], "HRD_CAT")
	s = 'HRD_HERTZ'
	sl = conversation.Request(s)

except:
	sl = '0'

#f=open('hrdqrg.txt', 'w')
#f.write(sl)
#f.close()
print sl
