#!/bin/bash
monitor()
{
	disk_usage=$(df -h | awk 'NR>1 {print $1, $5}')
	usage_cpu=$(top -bn1 |grep "Cpu(s)" |awk -F ',' '{print $4}' | awk '{print $1}')
	CPU=$(echo "100 - $usage_cpu" | bc)
	date=$(date '+%Y-%m-%d %H:%M:%S')

	echo "$date: CPU Usage: $CPU%" >> system_metrics.log
	echo "Disk Usage: $disk_usage" >> system_metrics.log
	#echo $disk_usage >> system_metrics.log
	
	cpu_threshold=80.0
	disk_thresh=80
	disk=$(df -h | awk 'NR==2 {print $5}' | tr -d '%')


	if (( $(echo "$CPU >= $cpu_threshold" | bc -l) )); then
        	echo "High CPU Usage Alert: $CPU%" >> system_metrics.log
	fi

	if [ $disk -gt $disk_thresh ]; then
                echo "High Disk Usage Alert: $disk%. Check /dev/root FS and act upon it."
        fi
	echo "-----------------------------------------------"

}
monitor
