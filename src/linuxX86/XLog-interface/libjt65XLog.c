#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <errno.h>
#include <sys/types.h>
#include <sys/ipc.h>
#include <sys/msg.h>

extern int errno;

/* structure needed for the message queue */
typedef struct
{
	long mtype;				/* mtype should always be 88 */
	char mtext[1024];	/* mtext holds the message */
}
msgtype;

msgtype msgbuf;
int msgid;

int addEntry (char *entry)
{
    /*
       Pass a fomatted string to this with each field as field:data demarked by \1

	create the message queue, you need to use 1238 for the key to talk to xlog 
    */
    msgid = msgget ((key_t) 1238, 0666 | IPC_CREAT);
    if (msgid == -1)
    {
	return(-10);
    }
    else
    {
	/* Set mtype to 88 */
	msgbuf.mtype = 88;
	strcpy (msgbuf.mtext, entry);
	if (msgsnd (msgid, (void *) &msgbuf, 1024, 0) == -1)
	{
	    return(-15);
	}
	else
	{
	    return(0);
	}
    }
}
