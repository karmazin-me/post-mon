# post-mon
Postfix monitoring script

- Postfix MTA monitoring
- Does not monitor qmgr, pickup, maildrop. Only master by postfix status
- The postfix-script is actually called behind the scenes by the postfix binary and cannot be called directly.
- But luckily the script also includes the code to test if postfix is running:
```ssh
  status $daemon_directory/master -t 2>/dev/null && {
         $INFO the Postfix mail system is not running
         exit 1
 	       }
  	 $INFO the Postfix mail system is running: PID: `sed 1q pid/master.pid`
  	 exit 0
    	 ;;
```

The variable $daemon_directory gets set by the calling postfix binary.
On my system it resolves to **/var/packages/MailServer/target/libexec/**
