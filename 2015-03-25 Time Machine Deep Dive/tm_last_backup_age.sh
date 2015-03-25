#!/bin/bash

###
#
#            Name:  tm_last_backup_age.sh
#     Description:  Displays the age (in days) of the last Time Machine backup.
#          Author:  Elliot Jordan <elliot@lindegroup.com>
#         Created:  2012-07-01
#   Last Modified:  2015-03-24
#         Version:  1.0
#
###

# Get the OS X version.
OS_major=$(/usr/bin/sw_vers -productVersion | awk -F. '{print $1}')
OS_minor=$(/usr/bin/sw_vers -productVersion | awk -F. '{print $2}')

# One day is 86,400 seconds.
DAY=86400

# Today, in UNIX seconds.
EPOCH="$(date -u "+%s")"

if [[ "$OS_major" -eq "10" && "$OS_minor" -gt "6" ]]; then

    # Mac OS X 10.7+
    LATEST_SNAPSHOT=$(tmutil latestbackup | awk -F/ '{print $6}')

elif [[ "$OS_major" -eq "10" ]] && [[ "$OS_minor" -eq "5" || "$OS_minor" -eq "6" ]]; then

    # Mac OS X 10.5 or 10.6
    LATEST_SNAPSHOT=$(defaults read /private/var/db/.TimeMachine.Results BACKUP_COMPLETED_DATE 2>/dev/null)

elif [[ "$OS_major" -eq "10" && "$OS_minor" -lt "5" ]]; then

    # Mac OS X 10.4-
    echo "[ERROR] This version of OS X does not support Time Machine."
    exit 1001

else

    echo "[ERROR] Unknown version of OS X."
    exit 1002

fi

if [[ $? -eq 0 && -n $LATEST_SNAPSHOT ]]; then
    # Convert password change date to UNIX seconds for comparison.
    LATEST_SNAPSHOT_SEC=$(date -jf "%Y-%m-%d-%H%M%S" "$LATEST_SNAPSHOT" "+%s")

    # Calculate password age in days.
    SNAPSHOT_AGE="$(( ( EPOCH - LATEST_SNAPSHOT_SEC ) / DAY ))"

    echo "$SNAPSHOT_AGE"
else
    echo "[ERROR] Unable to get latest Time Machine snapshot date."
fi

exit 0