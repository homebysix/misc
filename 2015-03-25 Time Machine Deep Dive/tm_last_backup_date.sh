#!/bin/bash

###
#
#            Name:  tm_last_backup_date.sh
#     Description:  Displays the date of the last successful Time Machine
#                   backup in YYYY-MM-DD format.
#          Author:  Elliot Jordan <elliot@lindegroup.com>
#         Created:  2012-07-01
#   Last Modified:  2015-03-24
#         Version:  1.0
#
###

# Get the OS X version.
OS_major=$(/usr/bin/sw_vers -productVersion | awk -F. '{print $1}')
OS_minor=$(/usr/bin/sw_vers -productVersion | awk -F. '{print $2}')

if [[ "$OS_major" -eq "10" && "$OS_minor" -gt "6" ]]; then

    # Mac OS X 10.7+
    tmutil latestbackup | awk -F/ '{print $6}' | /usr/bin/colrm 11

elif [[ "$OS_major" -eq "10" ]] && [[ "$OS_minor" -eq "5" || "$OS_minor" -eq "6" ]]; then

    # Mac OS X 10.5 or 10.6
    defaults read /private/var/db/.TimeMachine.Results BACKUP_COMPLETED_DATE | /usr/bin/colrm 11

elif [[ "$OS_major" -eq "10" && "$OS_minor" -lt "5" ]]; then

    # Mac OS X 10.4-
    echo "[ERROR] This version of OS X does not support Time Machine."
    exit 1001

else

    echo "[ERROR] Unknown version of OS X."
    exit 1002

fi

exit 0