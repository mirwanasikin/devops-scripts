#!/bin/bash

# Simpel system Monitoring CLI tool
# author: Tenka Asikin
# Usage: ./monitor.sh -a

set -euo pipefail
exit_code=0
usage() {
	cat <<EOF
Usage: $0 [-c] [-m] [-d] [-e] [-a]

Opsi:
-c : Information about CPU
-m : Information about Memory
-d : Information about Disk
-e : Information about Error one hour ago
-a : All Information
EOF
	exit 1
}

cpu_info () {
	cpu=$(top -bn1 | awk '/Cpu/ {print 100 - $8}')
	echo "CPU Usage ${cpu}%"
}

mem_info () {
	total=$(free -m | awk '/Mem:/ {print $2}')
	avail=$(free -m | awk '/Mem:/ {print $7}')
	used=$(( (total - avail) * 100 / total ))
	echo "Memory used ${used}%"
}

disk_info () {
	disk=$(df / | awk 'NR==2 {print $5}')
	echo "Disk usage $disk"
}

error_info () {
	error=$(journalctl -p err --since "1 hour ago" | wc -l)
	echo "Number of errors $error"
	
	(( error > 0 )) && exit_code=1
}

[[ $# -eq 0 ]] && usage

while getopts ":cmdea" opt; do
	case "$opt" in
		c) cpu_info ;;
		m) mem_info ;;
		d) disk_info ;;
		e) error_info ;;
		a) 
			cpu_info
			mem_info
			disk_info
			error_info
			;;
		\?) usage ;;
	esac
done	
exit "$exit_code"
