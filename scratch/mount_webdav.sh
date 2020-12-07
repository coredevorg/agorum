	mount | grep -q "$mount" || {
		[ -f "${LINKROOT}/${link}" ] && rm "${LINKROOT}/${link}"
		#mount -t smbfs cifs://${username}:${password}@${host}/${dms} "$mount"
		mount_webdav -i http://${host}/webdav/${dms} "$mount"
		( open $mount && mkalias $mount $LINKROOT "$link" ) &
		# ( let counter=0
		#   while [ $counter -lt 60 ]
		#   do
		#   	sleep 1 ; ((counter++))
		# 	[ -d "$mount" ] && {
		# 		mkalias $mount $LINKROOT "$link"
		# 		break	
		# 	}
		#   done
		# ) &
		# [ -f "${LINKROOT}/${link}" ] || { sleep 3 ; mkalias $mount $LINKROOT "$link"; }
	}
