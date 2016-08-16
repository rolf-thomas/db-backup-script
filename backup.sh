#!/bin/bash

# inspired by https://github.com/webstylr/simple-mysqlbackup/blob/master/mysqlbackup.sh
#
# Requirements
# ------------
# /root/.my.cnf:
# --
# [mysqldump]
# user=mysql-backup-user
# password=mysql-backup-user-password
# --
# Important: chmod 0600 /root/.my.cnf
#
# Check Option --default-character-set
#
# Tip: create a seperate mysql backup user
# CREATE USER 'backup'@'localhost' IDENTIFIED BY '[password]';
# GRANT SELECT, LOCK TABLES ON *.* TO 'backup'@'localhost';
# FLUSH PRIVILEGES;
#
# Cronjob:
# run everyy day at 1am and write output to /var/log/backup.log
# 0 1 * * * /var/www/…/backup.sh >> /var/log/backup.log

### Write log to temporary file  ###
# exec &> /tmp/backup.log

JOBNAME="[projectname] ";
STORAGEDIR="/var/www/[…]/backup";
DATE=`date +"%Y-%m-%d"`;
TIME=`date +"%H-%M"`;
DBNAME="[dbname]";
BACKUPCOMMAND="mysqldump --default-character-set=utf8mb4 ${DBNAME} | gzip > ${STORAGEDIR}/backup-db-${DBNAME}-${DATE}--${TIME}.gz";

echo "\n";
echo "$DATE $TIME - start db backup '$JOBNAME'";
echo $BACKUPCOMMAND;
eval $BACKUPCOMMAND;
echo "$DATE $TIME - end db backup '$JOBNAME'";
