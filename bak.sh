#!/bin/sh
export PATH=/sbin:/bin:/usr/sbin:/usr/bin
IP=$(ifconfig eth1|awk -F "[ :]+" 'NR==2{print $4}')
BakPath=/backup
mkdir $BakPath/$IP -p
if [ $(date +%w) -eq 2 ];then
 date="$(date +%F -d "-1day")_week1"
else
 date="$(date +%F -d "-1day")"
fi

cd / &&\
tar zcfh $BakPath/$IP/sys_config_${date}.tar.gz var/spool/cron etc/rc.local server/scripts &&\
find $BakPath -type f -name "*.tar.gz"|xargs md5sum >$BakPath/$IP/flag_${date}
###bak data to backupserver by oldboy at 20160927
rsync -az $BakPath/ rsync_backup@172.16.1.41::backup --password-file=/etc/rsync.password
###del data 7 days ago.
find $BakPath -type f  -mtime +7|xargs rm -f
