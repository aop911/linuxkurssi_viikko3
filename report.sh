#!/usr/bin/env bash

OUTPUT="/var/www/html/viikko3/index.html"

get_disk_status() {
    local usage=$1

    if [ "$usage" -ge 80 ]; then
        echo "WARNING"
    else
        echo "OK"
    fi
}

DATE_TIME=$(date)
TIMEZONE=$(date +%Z)

UPTIME=$(uptime -p)

DISK_USAGE=$(df / | awk 'NR==2 {gsub("%","",$5); print $5}')
STATUS=$(get_disk_status "$DISK_USAGE")

TOTAL_RAM=$(free -h | awk '/Mem:/ {print $2}')
AVAILABLE_RAM=$(free -h | awk '/Mem:/ {print $7}')
cat > "$OUTPUT" <<EOF
<!DOCTYPE html>
<html>
<head>
<body style="background-color:powderblue;">
<meta charset="UTF-8">
<title>System Report</title>
<style>
body {
    font-family: Arial, sans-serif;
    margin: 40px;
}
.ok {
    color: green;
    font-weight: bold;
}
.warning {
    color: red;
    font-weight: bold;
}
</style>
</head>
<body>

<h1>Server Status Report</h1>

<p><strong>Generated:</strong> $DATE_TIME</p>
<p><strong>Time Zone:</strong> $TIMEZONE</p>

<p><strong>Uptime:</strong> $UPTIME</p>

<p><strong>Disk Usage (/):</strong> $DISK_USAGE%</p>

<p><strong>Status:</strong>
<span class="$( [ "$STATUS" = "OK" ] && echo ok || echo warning )">
$STATUS
</span>
</p>

<p><strong>Total RAM:</strong> $TOTAL_RAM</p>
<p><strong>Available RAM:</strong> $AVAILABLE_RAM</p>
<p><strong>commands used:</strong></p>
<p>date- shows current date and time<p>
<p>Timezone- shows timezone. set-timezone was used to change it, for it was UTC for some reason<p>
<p>uptime- shows how long server has been running<p>
<p>(df / | awk 'NR==2 {gsub("%","",$5); print $5}'- shows how much of memory is being used<p>
<p>free -h | awk '/Mem:/ {print $2}'- shows the total ram space<p>
<p>free -h | awk '/Mem:/ {print $7}'- shows ram space thats free to use<p>
<p><strong>something learned...</strong></p>
<p>Setting up a new week isnt as hard as it seemed at first.<p><p> cron is quite easy to use just by reading what was written on it.<p>
<p>
<p>
<p>
<footers>

<p><a href="https://github.com/aop911/linuxkurssi_viikko3">
		Scripts in github
</a>
</p>
</footers>
</body>
</html>
EOF
