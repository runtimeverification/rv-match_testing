// vsyslog.c
// 
#include <features.h>
#include <stdarg.h>
#include <stdlib.h>
#include <syslog.h>

static int
mysyslog(int priority, const char *fmt, ...)
{
//int rc;
va_list ap;

    va_start(ap, fmt);
    //rc = vsyslog(priority, fmt, ap);
    vsyslog(priority, fmt, ap);
    va_end(ap);
    //return rc;
    return 0;
}

int
main(int argc, char **argv)
{
mysyslog(LOG_USER|LOG_PID|LOG_DEBUG, "%s was here!", argv[0]);

    return EXIT_SUCCESS;
}
