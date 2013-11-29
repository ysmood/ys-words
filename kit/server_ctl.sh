coffee='node_modules/.bin/coffee'
forever='node_modules/.bin/forever'

app='app.coffee'

case $1 in
	'start' )
		uptime_conf='--minUptime 5000 --spinSleepTime 5000'
		log_conf='-a -o std.log -e err.log'
		$forever start $uptime_conf $log_conf -c $coffee $app
		;;

	'stop' )
		$forever stop $app
		;;
esac