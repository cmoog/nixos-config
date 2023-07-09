
date_and_week=$(date "+%Y-%m-%d")
current_time=$(date "+%H:%M %Z")
network=$(ip route get 1.1.1.1 | grep -Po '(?<=dev\s)\w+' | cut -f1 -d ' ')
load=($(cat /proc/loadavg))
cpu_usage="${load[0]}, ${load[1]}, ${load[2]}"
memory_usage=$(free | grep Mem | awk '{printf "%.2f", $3/$2 * 100}')
disk_usage=$(df --output=pcent / | tr -dc '0-9')

echo "$network_active $network | disk: "$disk_usage"% | mem: "$memory_usage"% | cpu: $cpu_usage | $date_and_week $current_time "

