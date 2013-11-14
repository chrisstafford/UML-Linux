#!/bin/sh
# set -x
# Bash script to monitor or watch the disk space
# -------------------------------------------------------------------------
# User to send mail to
USER="root"
# set alert levels
WARNING=70
CRITICAL=90
#
#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
#
function disk_space() {
while read output;
do
echo $output
  spaceused=$(echo $output | awk '{ print $1}' | cut -d'%' -f1)

  partition=$(echo $output | awk '{print $2}')

  if [ $spaceused -ge $WARNING -a $spaceused -lt $CRITICAL ] ; then
             echo "Running out of space \"$partition ($spaceused%)\" on server $(hostname), $(date)" |  mail -s "Warning: Filesystem $partition is at $spaceused%" $USER
  fi
  if [ $spaceused -ge $CRITICAL ] ; then
             echo "Running out of space \"$partition ($spaceused%)\" on server $(hostname), $(date)" |  mail -s "Critical Warning: Filesystem $partition is at $spaceused%" $USER
  fi
done
}

df -hP |  grep -vE "^[^/]|tmpfs|cdrom|media|proc"| awk '{print $5 " " $6}' | disk_space
