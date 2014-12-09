#!/bin/bash
VOLUME_HOME="/var/lib/mysql"
CONF_FILE="/etc/my.cnf"
LOG="/var/log/mysql/error.log"
MYSQL_USER='admin'

# Set permission of config file
chmod 644 ${CONF_FILE}

StartMySQL ()
{
    /usr/bin/mysqld_safe > /dev/null 2>&1 &

    # Time out in 1 minute
    LOOP_LIMIT=13
    for (( i=0 ; ; i++ )); do
        if [ ${i} -eq ${LOOP_LIMIT} ]; then
            echo "Time out. Error log is shown as below:"
            tail -n 100 ${LOG}
            exit 1
        fi
        echo "=> Waiting for confirmation of MySQL service startup, trying ${i}/${LOOP_LIMIT} ..."
        sleep 5
        mysql -uroot -e "status" > /dev/null 2>&1 && break
    done
}

CreateMySQLUser()
{
	StartMySQL
	if [ "$MYSQL_PASS" = "**Random**" ]; then
	    unset MYSQL_PASS
	fi

	PASS=${MYSQL_PASS:-$(pwgen -s 12 1)}
	_word=$( [ ${MYSQL_PASS} ] && echo "preset" || echo "random" )
	echo "=> Creating MySQL user ${MYSQL_USER} with ${_word} password"

	mysql -uroot -e "CREATE USER '${MYSQL_USER}'@'%' IDENTIFIED BY '$PASS'"
	mysql -uroot -e "GRANT ALL PRIVILEGES ON *.* TO '${MYSQL_USER}'@'%' WITH GRANT OPTION"


	echo "=> Done!"

	echo "========================================================================"
	echo "You can now connect to this MySQL Server using:"
	echo ""
	echo "    mysql -u$MYSQL_USER -p$PASS -h<host> -P<port>"
	echo ""
	echo "Please remember to change the above password as soon as possible!"
	echo "MySQL user 'root' has no password but only allows local connections"
	echo "========================================================================"

	mysqladmin -uroot shutdown
}

if [[ ! -d $VOLUME_HOME/mysql ]]; then
    echo "=> An empty or uninitialized MySQL volume is detected in $VOLUME_HOME"
    echo "=> Installing MySQL ..."
    mysql_install_db > /dev/null 2>&1
    echo "=> Done!"  
    echo "=> Creating admin user ..."
    CreateMySQLUser

    if [ -n "${STARTUP_SQL}" ]; then
        echo "=> Initializing DB with ${STARTUP_SQL}"
        ImportSql
    fi
else
    echo "=> Using an existing volume of MySQL"
fi

exec supervisord -c /etc/supervisord.conf
