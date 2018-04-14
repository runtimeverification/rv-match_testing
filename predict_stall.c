/* confdefs.h */
//#define PACKAGE_NAME "NSD"
//#define PACKAGE_TARNAME "nsd"
//#define PACKAGE_VERSION "4.1.21"
//#define PACKAGE_STRING "NSD 4.1.21"
//#define PACKAGE_BUGREPORT "nsd-bugs@nlnetlabs.nl"
//#define PACKAGE_URL ""
//#define STDC_HEADERS 1
//#define HAVE_SYS_TYPES_H 1
//#define HAVE_SYS_STAT_H 1
//#define HAVE_STDLIB_H 1
//#define HAVE_STRING_H 1
//#define HAVE_MEMORY_H 1
//#define HAVE_STRINGS_H 1
//#define HAVE_INTTYPES_H 1
//#define HAVE_STDINT_H 1
//#define HAVE_UNISTD_H 1
//#define __EXTENSIONS__ 1
//#define _ALL_SOURCE 1
//#define _GNU_SOURCE 1
//#define _POSIX_PTHREAD_SEMANTICS 1
//#define _TANDEM_SOURCE 1
//#define CONFIGDIR "/etc/nsd"
//#define CONFIGFILE "/etc/nsd/nsd.conf"
//#define PIDFILE "/var/run/nsd.pid"
//#define DBFILE "/var/db/nsd/nsd.db"
//#define ZONESDIR "/etc/nsd"
//#define XFRDFILE "/var/db/nsd/xfrd.state"
//#define ZONELISTFILE "/var/db/nsd/zone.list"
//#define XFRDIR "/tmp"
//#define NSD_START_PATH "/usr/local/sbin/nsd"
//#define USER "nsd"
//#define YYTEXT_POINTER 1
//#define HAVE_ATTR_FORMAT 1
//#define HAVE_ATTR_UNUSED 1
//#define HAVE_EVENT_H 1
//#define HAVE_EVENT_BASE_FREE 1
//#define HAVE_EVENT_BASE_ONCE 1
//#define HAVE_EVENT_BASE_NEW 1
//#define HAVE_EVENT_BASE_GET_METHOD 1
//#define STDC_HEADERS 1
//#define HAVE_SYS_WAIT_H 1
//#define HAVE_TIME_H 1
//#define HAVE_ARPA_INET_H 1
//#define HAVE_SIGNAL_H 1
//#define HAVE_STRING_H 1
//#define HAVE_STRINGS_H 1
//#define HAVE_FCNTL_H 1
//#define HAVE_LIMITS_H 1
//#define HAVE_NETINET_IN_H 1
//#define HAVE_NETINET_TCP_H 1
//#define HAVE_STDDEF_H 1
//#define HAVE_SYS_PARAM_H 1
//#define HAVE_SYS_SOCKET_H 1
//#define HAVE_SYSLOG_H 1
//#define HAVE_UNISTD_H 1
//#define HAVE_SYS_SELECT_H 1
//#define HAVE_STDARG_H 1
//#define HAVE_STDINT_H 1
//#define HAVE_NETDB_H 1
//#define HAVE_SYS_BITYPES_H 1
//#define HAVE_GLOB_H 1
//#define HAVE_GRP_H 1
//#define HAVE_ENDIAN_H 1
//#define STRPTIME_NEEDS_DEFINES 1
//#define STRPTIME_WORKS 1
///* end confdefs.h.  */
//
//
#include <stdio.h>
#include <string.h>
//#include <stdlib.h>
#include <fcntl.h>
#include <errno.h>
//#ifdef HAVE_SYS_TYPES_H
#include <sys/types.h>
//#endif
//#ifdef HAVE_SYS_SOCKET_H
#include <sys/socket.h>
//#endif
//#ifdef HAVE_NETINET_IN_H
#include <netinet/in.h>
//#endif
//#ifdef HAVE_ARPA_INET_H
#include <arpa/inet.h>
//#endif
//#ifdef HAVE_UNISTD_H
#include <unistd.h>
//#endif
//#ifdef HAVE_TIME_H
#include <time.h>
//#endif

int main(void)
{
	int port;
	int sfd, cfd;
	int num = 10;
	int i, p;
	struct sockaddr_in a;
	/* test if select and nonblocking reads work well together */
	/* open port.
	   fork child to send 10 messages.
	   select to read.
	   then try to nonblocking read the 10 messages
	   then, nonblocking read must give EAGAIN
	*/

	port = 12345 + (time(0)%32);
	sfd = socket(PF_INET, SOCK_DGRAM, 0);
	if(sfd == -1) {
		perror("socket");
		return 1;
	}
	memset(&a, 0, sizeof(a));
	a.sin_family = AF_INET;
	a.sin_port = htons(port);
	a.sin_addr.s_addr = inet_addr("127.0.0.1");
	if(bind(sfd, (struct sockaddr*)&a, sizeof(a)) < 0) {
		perror("bind");
		return 1;
	}
	if(fcntl(sfd, F_SETFL, O_NONBLOCK) == -1) {
		perror("fcntl");
		return 1;
	}

	cfd = socket(PF_INET, SOCK_DGRAM, 0);
	if(cfd == -1) {
		perror("client socket");
		return 1;
	}
	a.sin_port = 0;
	if(bind(cfd, (struct sockaddr*)&a, sizeof(a)) < 0) {
		perror("client bind");
		return 1;
	}
	a.sin_port = htons(port);

	/* no handler, causes exit in 10 seconds */
	alarm(10);

	/* send and receive on the socket */
	if((p=fork()) == 0) {
		for(i=0; i<num; i++) {
			if(sendto(cfd, &i, sizeof(i), 0,
				(struct sockaddr*)&a, sizeof(a)) < 0) {
				perror("sendto");
				return 1;
			}
		}
	} else {
		/* parent */
		fd_set rset;
		int x;
		if(p == -1) {
			perror("fork");
			return 1;
		}
		FD_ZERO(&rset);
		FD_SET(sfd, &rset);
		if(select(sfd+1, &rset, NULL, NULL, NULL) < 1) {
			perror("select");
			return 1;
		}
		i = 0;
		while(i < num) {
			if(recv(sfd, &x, sizeof(x), 0) != sizeof(x)) {
				if(errno == EAGAIN)
					continue;
				perror("recv");
				return 1;
			}
			i++;
		}
		/* now we want to get EAGAIN: nonblocking goodness */
		errno = 0;
		recv(sfd, &x, sizeof(x), 0);
		if(errno != EAGAIN) {
			perror("trying to recv again");
			return 1;
		}
		/* EAGAIN encountered */
	}

	close(sfd);
	close(cfd);
	return 0;
}

