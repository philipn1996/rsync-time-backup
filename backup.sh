#!/bin/bash

##<CONFIG>
#URLs
STATUS_URL="https://myserver.de/test.php"

#SSH-Identities (~/.ssh/config)
ROUTER="router"
NAS_USER="not-root"
NAS_LOCAL="nas"
NAS_LOCAL_PORT="22"
NAS_LOCAL_IP="192.168.1.211"
NAS_LOCAL_WEBSERVER="192.168.1.211:80"
NAS_RESPONSE="DiskStation"
NAS_REMOTE="remotenas"
NAS_REMOTE_PORT="2223"

#Backup-Settings
SOURCE="/home/myuser"
TARGET="/var/services/homes/admin/backup/"
EXCLUDE="/home/myuser/ex.conf"

##</CONFIG>

tmp=$(curl -s $STATUS_URL | grep "NAS online");
online=$?;
if [ $online -ne 0 ]; then
	echo "NAS offline. WOL...";
	$(ssh $ROUTER "./wake_nas");

	echo "..Boot..";
	sleep 40;
fi
until [ $online -eq 0 ]; do	
	sleep 20;
	echo "Checking Online-Status";
	online=$(curl -s $STATUS_URL | grep "NAS online";
	online=$?;
done
echo "NAS online!";

tmp=$(curl -s --connect-timeout 5 $NAS_LOCAL_WEBSERVER | grep $NAS_RESPONSE)
local=$?;
if [ $local -eq 0 ];then 
	echo "Establishing local connection...";
	./rsync_tmbackup.sh -p $NAS_LOCAL_PORT $SOURCE $NAS_USER@$NAS_LOCAL:$TARGET $EXCLUDE;

else
	echo "NAS not reachable via local address; connecting via relay-Server...";
	./rsync_tmbackup.sh -p $NAS_REMOTE_PORT $SOURCE $NAS_USER@$NAS_REMOTE:$TARGET $EXCLUDE;
	
fi
