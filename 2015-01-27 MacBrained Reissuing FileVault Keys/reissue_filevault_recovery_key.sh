#!/bin/bash

###
#
#            Name:  reissue_filevault_recovery_key.sh
#     Description:  This script is intended to run on Macs which no longer have
#                   a valid recovery key in the JSS. It prompts users to enter
#                   their Mac password, and uses this password to send a new
#                   FileVault key to the JSS. The "redirect FileVault keys to
#                   JSS" configuration profile must already be deployed in order
#                   for this script to work correctly.
#          Author:  Elliot Jordan <elliot@lindegroup.com>
#         Created:  2015-01-05
#   Last Modified:  2015-10-29
#         Version:  1.4
#
###


################################## VARIABLES ###################################

# Your company name.
COMPANY_NAME="PretendCo"

# Your company's logo, in PNG format. (For use in jamfHelper messages.)
# Use standard UNIX path format:  /path/to/file.png
LOGO_PNG="/Library/Application Support/PretendCo/logo@512px.png"

# Your company's logo, in ICNS format. (For use in AppleScript messages.)
# Use standard UNIX path format:  /path/to/file.icns
LOGO_ICNS="/private/tmp/PretendCo.icns"

# The title of the message that will be displayed to the user. Not too long, or it'll get clipped.
PROMPT_HEADING="FileVault key needs repair"

# The body of the message that will be displayed to the user.
PROMPT_MESSAGE="Your Mac's FileVault encryption key needs to be regenerated in order for $COMPANY_NAME IT to be able to recover your hard drive in case of emergency.

Click the Next button below, then enter your Mac's password when prompted."

# Path to jamfHelper.
jamfHelper="/Library/Application Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper"


################################################################################
######################### DO NOT EDIT BELOW THIS LINE ##########################
################################################################################


######################## VALIDATION AND ERROR CHECKING #########################


# Suppress errors for the duration of this script.
exec 2>/dev/null

# Make sure the custom logo has been received successfully
if [[ ! -f "$LOGO_ICNS" ]]; then
    echo "[ERROR] Custom icon not present: $LOGO_ICNS"
    exit 1001
fi
# Convert POSIX path of logo icon to Mac path for AppleScript
LOGO_ICNS="$(osascript -e 'tell application "System Events" to return POSIX file "'"$LOGO_ICNS"'" as text')"

# Most of the code below is based on the JAMF reissueKey.sh script:
# https://github.com/JAMFSupport/FileVault2_Scripts/blob/master/reissueKey.sh

# Check the OS version.
OS_major=$(/usr/bin/sw_vers -productVersion | awk -F . '{print $1}')
OS_minor=$(/usr/bin/sw_vers -productVersion | awk -F . '{print $2}')
if [[ "$OS_major" -ne 10 || "$OS_minor" -lt 9 ]]; then
    echo "[ERROR] OS version not 10.9+ or OS version unrecognized."
    /usr/bin/sw_vers -productVersion
    exit 1003
fi

# Check to see if the encryption process is complete
encryptCheck="$(/usr/bin/fdesetup status)"
if [[ "$(echo "${encryptCheck}" | grep -c "Encryption in progress")" -gt 0 ]]; then
    echo "[ERROR] The encryption process is still in progress."
    echo "${encryptCheck}"
    exit 1004
elif [[ "$(echo "${encryptCheck}" | grep -c "FileVault is Off")" -gt 0 ]]; then
    echo "[ERROR] Encryption is not active."
    echo "${encryptCheck}"
    exit 1005
elif [[ "$(echo "${encryptCheck}" | grep -c "FileVault is On")" -eq 0 ]]; then
    echo "[ERROR] Unable to determine encryption status."
    echo "${encryptCheck}"
    exit 1006
fi

# Get the logged in user's name
userName="$(/usr/bin/stat -f%Su /dev/console)"

# This first user check sees if the logged in account is already authorized with FileVault 2
userCheck="$(/usr/bin/fdesetup list)"
echo "$userCheck" | egrep -q "^${userName},"
if [[ $? -ne 0 ]]; then
    echo "[ERROR] $userName is not on the list of FileVault enabled users:"
    echo "$userCheck"
    exit 1002
fi

################################# MAIN PROCESS #################################

# Display a branded prompt explaining the password prompt.
echo "Alerting user ${userName} about incoming password prompt..."

"$jamfHelper" -windowType hud -windowPosition ur -lockHUD -icon "$LOGO_PNG" -heading "$PROMPT_HEADING" -description "$PROMPT_MESSAGE" -button1 "Next" -defaultButton 1 -startlaunchd

# Get the logged in user's password via a prompt
echo "Prompting ${userName} for their Mac password..."
userPass="$(/usr/bin/osascript -e 'tell application "System Events"' -e 'with timeout of 86400 seconds' -e 'display dialog "Please enter your Mac password:" default answer "" with title "'"${COMPANY_NAME//\"/\\\"}"' IT encryption key repair" with text buttons {"OK"} default button 1 with hidden answer with icon file "'"${LOGO_ICNS//\"/\\\"}"'"' -e 'return text returned of result' -e 'end timeout' -e 'end tell')"

# Thanks to James Barclay for this password validation loop.
TRY=1
until dscl /Search -authonly "$userName" "$userPass" &> /dev/null; do
    (( TRY++ ))
    echo "Prompting ${userName} for their Mac password (attempt $TRY)..."
    userPass="$(/usr/bin/osascript -e 'tell application "System Events"' -e 'with timeout of 86400 seconds' -e 'display dialog "Sorry, that password was incorrect. Please try again:" default answer "" with title "'"${COMPANY_NAME//\"/\\\"}"' IT encryption key repair" with text buttons {"OK"} default button 1 with hidden answer with icon file "'"${LOGO_ICNS//\"/\\\"}"'"' -e 'return text returned of result' -e 'end timeout' -e 'end tell')"
    if [[ $TRY -ge 5 ]]; then
        echo "[ERROR] Password prompt unsuccessful after 5 attempts."
        exit 1007
    fi
done
echo "Successfully prompted for Mac password."

echo "Unloading FDERecoveryAgent..."
launchctl unload /System/Library/LaunchDaemons/com.apple.security.FDERecoveryAgent.plist

echo "Issuing new recovery key..."
fdesetup changerecovery -norecoverykey -verbose -personal -inputplist << EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Username</key>
    <string>$userName</string>
    <key>Password</key>
    <string>$userPass</string>
</dict>
</plist>
EOF

if [[ $? -ne 0 ]]; then
    echo "[WARNING] fdesetup did not return exit code 0."
fi

echo "Loading FDERecoveryAgent..."
# `fdesetup changerecovery` should do this automatically, but just in case...
launchctl load /System/Library/LaunchDaemons/com.apple.security.FDERecoveryAgent.plist &>/dev/null

exit 0
