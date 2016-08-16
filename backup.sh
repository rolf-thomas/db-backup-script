#!/bin/bash

# inspired by https://github.com/webstylr/simple-mysqlbackup/blob/master/mysqlbackup.sh
#
# Requirements
# ------------
# Everything is run as root user, so…
#
# /root/.my.cnf:
# --
# [mysqldump]
# user=mysql-backup-user
# password=mysql-backup-user-password
# --
# Important:
# Restrict access to mysql-config-file to root user (r+w)
# chmod 0600 /root/.my.cnf
#
# Make script executable
# sudo chmod +x backup.sh
#
# Tip:
# create a separate mysql backup user with only read-access to db
# > CREATE USER 'backup'@'localhost' IDENTIFIED BY '[password]';
# > GRANT SELECT, LOCK TABLES ON *.* TO 'backup'@'localhost';
# > FLUSH PRIVILEGES;
#
# Cronjob:
# run everyy day at 1am and write output to /var/log/backup.log
# 0 1 * * * /var/www/…/backup.sh >> /var/log/backup.log
#
# Check mysqldump-option --default-character-set for your installation

### Write log to temporary file  ###
# exec &> /tmp/backup.log

# Config
JOBNAME="[projectname]";
STORAGEDIR="/var/www/[…]/backup";
DATE=`date +"%Y-%m-%d"`;
TIME=`date +"%H-%M-%S"`;
DBNAME="[dbname]";

# Prepare backup command
BACKUPCOMMAND="mysqldump --default-character-set=utf8mb4 ${DBNAME} | gzip > ${STORAGEDIR}/backup-db-${DBNAME}-${DATE}--${TIME}.gz";

# Execute
echo "$DATE $TIME start db backup '$JOBNAME'";
echo "$DATE $TIME $BACKUPCOMMAND";
eval $BACKUPCOMMAND;
DATE=`date +"%Y-%m-%d"`;
TIME=`date +"%H-%M-%S"`;
echo "$DATE $TIME end db backup '$JOBNAME'";
