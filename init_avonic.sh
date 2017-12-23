#!/bin/sh -e

DAEMON="/home/pi/appli/system_initialization/start_system.sh"
DAEMONUSER="pi"
DAEMONNAME="start_system.sh"

PATH="/sbin:/bin:/usr/sbin:/usr/bin"

test -x $DAEMON || exit 0

. /lib/lsb/init-functions

d_start () {
        log_daemon_msg "Starting system $DAEMONNAME Daemon"
	start-stop-daemon --background --name $DAEMONNAME --start --quiet --chuid $DAEMONUSER --exec $DAEMON
        log_end_msg $?
}

d_stop () {
        log_daemon_msg "Stopping system $DAEMONNAME Daemon"
        start-stop-daemon --name $DAEMONNAME --stop --retry 5 --quiet --name $DAEMONNAME
	log_end_msg $?
}

case "$1" in

        start|stop)
                d_${1}
                ;;

        restart|reload|force-reload)
                        d_stop
                        d_start
                ;;

        force-stop)
               d_stop
                killall -q $DAEMONNAME || true
                sleep 2
                killall -q -9 $DAEMONNAME || true
                ;;

        status)
                status_of_proc "$DAEMONNAME" "$DAEMON" "system-wide $DAEMONNAME" && exit 0 || exit $?
                ;;
        *)
                echo "Usage: /etc/init.d/$DAEMONNAME {start|stop|force-stop|restart|reload|force-reload|status}"
                exit 1
                ;;
esac
exit 0
