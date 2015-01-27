#!/bin/bash
#
#       /etc/init.d/sinatra-app
#
# chkconfig: 2345 13 87
#
#  sudo ln -s /var/www/sinatra-app/web-app.init.sh /etc/init.d/sinatra-app
#

# Source function library.
. /etc/init.d/functions

NAME=sinatra-app
HOMEDIR=/var/www/sinatra-app
PROG='bundle exec rackup config.ru --port 8081'
PIDFILE=/var/run/$NAME/$NAME.pid
LOCKFILE=/var/lock/subsys/$NAME

# Create Directorys for logging and PID
mkdir -p /var/run/$NAME
mkdir -p /var/log/$NAME

start() {
    echo -n "Starting : "

    cd $HOMEDIR
    daemon $PROG > /var/log/$NAME/debug.log 2>&1
    PID=$!
    echo $PID > $PIDFILE
    RETVAL=$?

    touch $LOCKFILE
    return $RETVAL
}

stop() {
    if [ ! -f "$PIDFILE" ]; then
        return 0
    fi
    echo -n "Shutting down : "
    PID=`cat $PIDFILE`
    kill -TERM $PID
    RETVAL=$?
    echo
    if [ $RETVAL -eq 0 ] ; then
        rm -f $LOCKFILE $PIDFILE
    fi
    return $RETVAL
}

case "$1" in
    start)
        start
        ;;
    stop)
        stop
        ;;
    status)
        status -p $PIDFILE $PROG
        RETVAL=$?
        ;;
    restart)
        stop
        start
        ;;
    *)
        echo "Usage:  {start|stop|status|restart}"
        exit 1
        ;;
esac
exit $?