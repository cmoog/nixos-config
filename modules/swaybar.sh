
date_time=$(printf '%(%Y-%m-%d %I:%M %p %Z)T')
network=$(ip route get 1.1.1.1 | grep -Po '(?<=dev\s)\w+' | cut -f1 -d ' ')
load=($(cat /proc/loadavg))
cpu_usage="${load[0]}, ${load[1]}, ${load[2]}"
memory_usage=$(free | grep Mem | awk '{printf "%.2f", (1 - $7/$2) * 100}')
disk_usage=$(df --output=pcent / | tr -dc '0-9')
battery_level=$(cat /sys/class/power_supply/BAT0/capacity)
charging=$([ $(cat /sys/class/power_supply/BAT0/status) == "Charging" ] && echo -n ^^)

echo "$network | disk: "$disk_usage"% | mem: "$memory_usage"% | cpu: $cpu_usage | bat: $charging$battery_level% | $date_time"

