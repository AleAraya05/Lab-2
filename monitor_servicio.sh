#!/bin/bash


# Registro periodico

log="/var/log/monitor_sistema.log"

if [ ! -f "$log" ]; then
	printf "%-20s %-8s %-20s %-8s %-8s\n" "TIMESTAMP" "PID" "CMD" "CPU" "MEM" >> $log
fi

while true
do
	timestamp=$(date "+%Y-%m-%d %H:%M:%S")
	ps -eo pid,comm,%cpu,%mem --sort=%cpu | tail -n 5 | while read pid comm cpu mem
	do
		printf "%-20s %-8s %-20s %-8s %-8s\n" "$timestamp" "$pid" "$comm" "$cpu" "$mem" >> $log
	done
	sleep 5
done

