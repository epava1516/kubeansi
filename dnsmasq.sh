#!/bin/bash
#
HOSTS_FILE=/etc/hosts
NODES_FILE=/etc/nodes
LOG_FILE=/var/log/dnsmasq.log
TFTP_DIR=/var/lib/tftpboot/pxelinux.cfg
COMANDO=$1
#
function replace_line() {
	local FILE=$1; shift
	local PATTERN=$1; shift
	local NEW_LINE=$*
	local NEW=$(echo "${NEW_LINE}" | sed 's/\//\\\//g')
	touch "${FILE}"
	sed -i '/'"${PATTERN}"'/{s/.*/'"${NEW}"'/;h};${x;/./{x;q100};x}' ${FILE}
	if [[ $? -ne 100 ]] && [[ ${NEW_LINE} != '' ]]; then
		echo "${NEW_LINE}" >> ${FILE}
	fi
	log replace_line $FILE --- $PATTERN --- $NEW_LINE
}
function remove_line() {
	local FILE=$1; shift
	local PATTERN=$*
	sed -i "/${PATTERN}/d" $FILE
}
function log() {
	local FH=`date +"%Y-%m-%d %H:%M:%S"`
	echo $FH $* >>$LOG_FILE
}
#
FH=`date +"%Y-%m-%d %H:%M:%S"`
case "$COMANDO" in
	add|old)
		MAC=$2
		IP=$3
		MAC2=${MAC//:/-}
		NAME=`grep $MAC2 $HOSTS_FILE | cut -d' ' -f2`
		[ -z "$NAME" ] && NAME=$MAC2
		LINE_H="$IP $NAME $MAC2"
		TYPE=`grep $MAC2 $NODES_FILE | cut -d' ' -f5`
		[ "$TYPE" != "UEFI" -a "$TYPE" != "BIOS" ] && TYPE='UNDEFINED'
		log $COMANDO $LINE_H
		if ! egrep -q "$IP[[:space:]]$NAME[[:space:]]$MAC2" $HOSTS_FILE ; then
			replace_line $HOSTS_FILE $MAC2 $LINE_H
		fi
		LINE_N="$NAME $MAC2 $IP $TYPE"
		if ! egrep -q "${MAC2}" $NODES_FILE ; then
			replace_line $NODES_FILE $MAC2 "$LINE_N discovered $TYPE $FH"
			log status discovered $MAC2 $IP $NAME $TYPE
		fi
		;;
	del)
		MAC=$2
		IP=$3
		MAC2=${MAC//:/-}
		NAME=`grep $MAC2 $HOSTS_FILE | cut -d' ' -f2`
		[ -z "$NAME" ] && NAME=$MAC2
		LINE_H="$IP $NAME $MAC2"
		log $COMANDO $LINE_H
		;;
	tftp)
		IP=$3
		FILE=$4
		MAC2=`egrep "^$IP[[:space:]]" $HOSTS_FILE | egrep -o "([0-9A-Fa-f]{2}[-]){5}([0-9A-Fa-f]{2})" | head -1`
		MAC=${MAC2//-/:}
		NAME=`grep $MAC2 $HOSTS_FILE | cut -d' ' -f2`
		TYPE=`grep $MAC2 $NODES_FILE | cut -d' ' -f5`
		[ "$TYPE" != "UEFI" -a "$TYPE" != "BIOS" ] && TYPE='UNDEFINED'
		TYPE_OLD=$TYPE
		log $COMANDO $IP $NAME $MAC2 $FILE
		[[ "$FILE" =~ "tftpboot/pxelinux.0" ]] && TYPE='BIOS'
		[[ "$FILE" =~ "tftpboot/BOOTX64.EFI" ]] && TYPE='UEFI'
		[ "$TYPE" != "$TYPE_OLD" ] && replace_line $NODES_FILE $MAC2 "$NAME $MAC2 $IP bootstrap $TYPE $FH"
		if [[ "$FILE" =~ "bootstrap/init" ]]; then
			replace_line $NODES_FILE $MAC2 "$NAME $MAC2 $IP bootstrap $TYPE $FH"
			log status bootstrap $MAC2 $IP $NAME $TYPE
		fi
		if [[ "$FILE" =~ "centos7/init" ]] ; then
			replace_line $NODES_FILE $MAC2 "$NAME $MAC2 $IP installing $TYPE $FH"
			echo "${MAC},ignore" > /etc/dnsmasq.kubeansi/${MAC2}
			cp ${TFTP_DIR}/installed ${TFTP_DIR}/01-${MAC2}	
			log status installing $MAC2 $IP $NAME $TYPE
		fi
		;;
	*)
		log UNDEFINED $*
		;;
esac
exit 0