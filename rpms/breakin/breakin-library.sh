#!/bin/sh

eval `stty size 2>/dev/null | (read L C; echo LINES=${L:-24} COLUMNS=${C:-80})`

PRODUCT_NAME="Bootimage"
PRODUCT_VERSION="0.05"


ANSI_GREEN="\033[1;32m"
ANSI_RED="\033[1;31m"
ANSI_BLUE="\033[1;34m"
ANSI_PURPLE="\033[1;35m"
ANSI_LEFT="\033[${COLUMNS}G\033[10D"
ANSI_DONE="\033[0m"

PRINT_OK=`echo -n ${ANSI_LEFT}${ANSI_GREEN} [ OK ] ${ANSI_DONE}`
PRINT_FAIL=`echo -n ${ANSI_LEFT}${ANSI_RED} [ FAIL ] ${ANSI_DONE}`

if [ -e /tmp/servers.conf ]
then
	. /tmp/servers.conf
fi

if [ -e /tmp/hardware.conf ]
then
	. /tmp/hardware.conf
fi

if [ -e /tmp/breakin.conf ]
then
	. /tmp/breakin.conf
fi

if [ -e /tmp/network.dhcp ]
then
	. /tmp/network.dhcp
fi


msg() {
	ARG1=$1
	ARG2=$2

	if [ "$ARG1" = "-n" ]
	then
		echo -en ${ARG2} 
	else 
		echo -e ${ARG1} 
	fi
}

fail_msg() {
	MSG=$1

	# echo wget a error message to the server
	msg "  ${PRINT_FAIL}"
}

ok_msg() {
	MSG=$1

	# echo wget a error message to the server
	msg "  ${PRINT_OK}"
}

ok_or_fail() {
	RETURN=$1

	if [ "$RETURN" = "0" ]
	then
		ok_msg
	else
		fail_msg
	fi
}

header() {
	MSG=$1

        msg -n "${ANSI_GREEN}"
        msg "================================="
        msg -n "${ANSI_BLUE}"
        msg " ${MSG}"
        msg -n "${ANSI_GREEN}"
        msg "================================="
        msg -n ${ANSI_DONE}

}

fatal_error() {
	MSG=$1

        msg ""
        msg -n "${ANSI_RED}"
        msg "========================================================"
        msg "           Fatal Error - halting ${PRODUCT_NAME} ${PRODUCT_VERSION}"
        msg "========================================================"
        msg -n "${ANSI_BLUE}"
        msg " ${MSG}"
        msg -n "${ANSI_RED}"
        msg "========================================================"
        msg -n ${ANSI_DONE}
        msg ""
        exit 1
}

modprobe_module() {

	MODULE_NAME=${1}

	msg -n "Trying to load ${ANSI_BLUE}${MODULE_NAME}${ANSI_DONE}"
	/sbin/modprobe "${MODULE_NAME}"  >> /tmp/stdout.log 2>> /tmp/stderr.log
	if [ "$?" = "1" ];
	then
		fail_msg
		return 1
	else
		ok_msg
		return 0
	fi
}

load_module() {

	MODULE_PATH=${1}
	MODULE_NAME=`basename ${MODULE_PATH}`
	MODULE_NAME=${MODULE_NAME%.ko}

	msg -n "Trying to load ${MODULE_NAME}"
	/sbin/modprobe "${MODULE_NAME}"  >> /tmp/stdout.log 2>> /tmp/stderr.log
	if [ "$?" = "1" ];
	then
		fail_msg
		return 1
	else
		ok_msg
		return 0
	fi
}

post_file_to_server() {

	MSG=${1}
	URIPATH=${2}
	FILENAME=${3}

	if [ "${BREAKIN_ID}" -lt 0 ]
	then
		return 1
	fi

	msg -n "$MSG -> ${HTTP_SERVER}:${HTTP_PORT}"

	URL="http://${HTTP_SERVER}:${HTTP_PORT}/${URIPATH}/${NET_MACADDR}/${BREAKIN_ID}"

	wget --server-response -O /tmp/post.out --post-file=${FILENAME} --timeout=10 \
		--tries=3 ${URL} >> /tmp/stdout.log 2>> /tmp/stderr.log

	if [ "$?" = 0 ]
	then
		ok_msg	
		return 0
	else
		fail_msg
		return 1
	fi
}

breakin_start() {

	msg -n "Notifing server that we've started the breakin process"
	URL="http://${HTTP_SERVER}:${HTTP_PORT}/cgi-bin/breakin/start/${NET_MACADDR}"

	wget --server-response -O /tmp/post.out --timeout=10 \
		--output-document=/tmp/breakin.conf \
		--tries=3 ${URL} 2>> /tmp/stderr.log

	. /tmp/breakin.conf

	if [ "$?" = 0 ]
	then
		ok_msg	
		return 0
	else
		fail_msg
		return 1
	fi
}

breakin_stop() {

	msg -n "Notifing server that we're stoping the breakin process"
	URL="http://${HTTP_SERVER}:${HTTP_PORT}/cgi-bin/breakin/stop/${NET_MACADDR}/${BREAKIN_ID}"

	wget --server-response -O /tmp/post.out --timeout=10 \
		--tries=3 ${URL} >> /tmp/stdout.log 2>> /tmp/stderr.log

	if [ "$?" = 0 ]
	then
		ok_msg	
		return 0
	else
		fail_msg
		return 1
	fi
}

breakin_update() {

	if [ "${BREAKIN_ID}" -lt 0 ]
	then
		return 0
	fi

	LOADAVG=0
	TEMPS=""

	if [ -e /proc/loadavg ]
	then
		LOADAVG=`cat /proc/loadavg | awk '{print $1}'`
	fi

	if [ "${SENSOR_ENABLE}" != "" ]
	then
		TEMPS=""
		if [ -e "/etc/sensors.conf" ]
		then
			for temp_i in `sensors | grep "^CPU[0-9] Temp" | cut -d":" -f2 | awk '{print $1 $2}' 2> /dev/null`
			do
				TEMPS="${TEMPS} ${temp_i}"	
			done
		fi
	fi

	echo "LOADAVG=${LOADAVG}" > /tmp/update.dat
	echo "TEMPERATURE=${TEMPS}" >> /tmp/update.dat

	URL="http://${HTTP_SERVER}:${HTTP_PORT}/cgi-bin/breakin/update/${NET_MACADDR}/${BREAKIN_ID}"
	wget --server-response -O /tmp/post.out --post-file=/tmp/update.dat --timeout=10 \
		--tries=3 ${URL} >> /tmp/stdout.log 2>> /tmp/stderr.log

	if [ "$?" = 0 ]
	then
		return 0
	else
		return 1
	fi
}





log_burnin_error() {
	MSG=$1

	# create a file to notify the LED process there is an error
	touch /tmp/error_led
	echo "${MSG}" >> /var/log/breakin.log
}
