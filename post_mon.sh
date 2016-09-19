#!/bin/bash
#
# Postfix MTA monitoring
# Does not monitor qmgr, pickup, maildrop. Only master by postfix status
# The postfix-script is actually called behind the scenes by the postfix binary
# and cannot be called directly.
# But luckily the script also includes the code to test if postfix is running:

#	"status)
#   	$daemon_directory/master -t 2>/dev/null && {
#       	 $INFO the Postfix mail system is not running
#       	 exit 1
#   	 }
#   	 $INFO the Postfix mail system is running: PID: `sed 1q pid/master.pid`
#   	 exit 0
#  	  ;;
#			"
#
# The variable $daemon_directory gets set by the calling postfix binary.
# On my system it resolves to /var/packages/MailServer/target/libexec/.
#
################################################################################

# Set path variables to logger, Postfix and Postfix main config

	LOGGER="/usr/bin/logger"
	POSTFIX="/usr/sbin/postfix"
	POSTCOF="/etc/postfix/main.cf"


# See 'message' log with tag "POSTFIX-MON" and priority level "mail.err"
#
# Check if Postfix binary is on its place

	if [ ! -f $POSTFIX ]; then
		$LOGGER -t POSTFIX-MON -p mail.err "Unable to allocate Postfix -- PROBLEM!"
		exit 1
	fi

# Check if Postfix config on it place

	if [ ! -f $POSTCONF ]; then
		$LOGGER -t POSTFIX-MON -p mail.err "Unable to allocate Postfix conf -- PROBLEM!"
		exit 1
	fi

#  Check Postfix configuration

	if [ ! -f $POSTCONF ]; then
		postfix check 2>&1 | $LOGGER -t POSTFIX-MON -p mail.err

		exit 1
	fi

# Check if Postfix MTA is up. If it's up - shoot message in the message log

if $POSTFIX status /dev/null 2>&1; then
    $LOGGER -t POSTFIX-MON "Postfix MTA is up and running -- OK!"




 # If MTA is down - restart Postfix and run the script recursively

			else sudo postfix stop; sudo postfix start; ./$0;

	# Shoot message about MTA trouble and exit script

			$LOGGER -t POSTFIX-MON "Postfix is DOWN. Restarting ..."


		exit 0
fi

exit 0
