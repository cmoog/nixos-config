#!/usr/bin/env bash

bar_graph() {
    local percent
    local num_blocks
    local width=33
    local graph=""
    local used=$1
    local total=$2

    percent=$(printf "%.2f" "$(echo "$used / $total * 100" | bc -l)")
    num_blocks=$(echo "scale=2; ${percent}/100*${width}" | bc -l | numfmt --from=iec --format %.0f)
    for (( i = 0; i < num_blocks; i++ )); do
        graph+="█"
    done
    for (( i=0; i < width - num_blocks; i++ )); do
        graph+="░"
    done
    printf "%s" "${graph}"
}

repeat() {
    local text=""
    for (( i = 0; i < ${1}; i++ )); do
        text+="${2}"
    done
    printf "%s" "${text}"
}

source /etc/os-release
os_name="$PRETTY_NAME"
os_kernel=$({ uname; uname -r; } | tr '\n' ' ')
os_arch=$(uname -m)

net_current_user=$(whoami)
net_hostname=$(hostname -f)
net_machine_ip=$(ip -4 addr show | grep 'scope' | grep -Po '(?<=inet )[\d.]+' | grep -v '127.0.0.1')
net_dns_ip=$(grep 'nameserver' /etc/resolv.conf | head -n 1 | awk '{print $2}')

cpu_model="$(lscpu | grep 'Model name' | grep -v 'BIOS' | cut -f 2 -d ':' | awk '{print $1 " "  $2 " " $3}')"
cpu_cores="$(nproc --all)"
load_avg_5min=$(uptime | awk -F'load average: ' '{print $2}' | cut -d ',' -f2 | tr -d ' ')
cpu_5min_bar_graph=$(bar_graph "$load_avg_5min" "$cpu_cores")

mem_total=$(grep 'MemTotal' /proc/meminfo | awk '{print $2}')
mem_available=$(grep 'MemAvailable' /proc/meminfo | awk '{print $2}')
mem_used=$((mem_total - mem_available))
mem_percent=$(echo "$mem_used / $mem_total * 100" | bc -l)
mem_percent=$(printf "%.2f" "$mem_percent")
mem_total_gb=$(echo "$mem_total" | numfmt --from-unit=Ki --to-unit=Gi --format %.2f)
mem_used_gb=$(echo "$mem_used" | numfmt  --from-unit=Ki --to-unit=Gi --format %.2f)
mem_bar_graph=$(bar_graph "$mem_used" "$mem_total")

root=$(df / --print-type | tail -n 1)
root_dev=$(echo "$root" | awk '{print $1}')
root_type=$(echo "$root" | awk '{print $2}')
root_used=$(echo "$root" | awk '{print $4}')
root_used_gb=$(echo "$root_used" | numfmt --from-unit=K --to-unit=G --format %.2f)
root_available=$(echo "$root" | awk '{print $5}')
root_total=$((root_used + root_available))
root_total_gb=$(echo "$root_total" | numfmt --from-unit=K --to-unit=G --format %.2f)
root_percent=$(echo "$root_used / ($root_used + $root_available) * 100" | bc -l)
root_percent=$(printf "%.2f" "$root_percent")
root_bar_graph=$(bar_graph "$root_used" "$root_total")

sys_uptime=$(uptime | sed -E 's/^[^,]*up *//; s/mins/minutes/; s/hrs?/hours/;
  s/([[:digit:]]+):0?([[:digit:]]+)/\1 hours, \2 minutes/;
  s/^1 hours/1 hour/; s/ 1 hours/ 1 hour/;
  s/min,/minutes,/; s/ 0 minutes,/ less than a minute,/; s/ 1 minutes/ 1 minute/;
  s/  / /; s/, *[[:digit:]]* users?.*//')

top=$(   printf "├$(repeat 12 "─")┬%s┤\n" "$(repeat 35 "─")")
middle=$(printf "├$(repeat 12 "─")┼%s┤\n" "$(repeat 35 "─")")
bottom=$(printf "└$(repeat 12 "─")┴%s┘\n" "$(repeat 35 "─")")
row() {
    printf "│ %-10s │ %-33s │\n" "$1" "$2"
}

printf "┌%s┐\n" "$(repeat 48 "┬")"
printf "├%s┤\n" "$(repeat 48 "┴")"
printf "│                     NIXOS                      │\n"
printf "│                 MACHINE REPORT                 │\n"
echo "$top"
row OS "$os_name"
row KERNEL "$os_kernel"
row ARCH "$os_arch"
if [ -h /run/current-system ]; then
    nixos_system=$(realpath /run/current-system)
    nixos_nar=${nixos_system:11:32}
    row "NIXOS NAR" "$nixos_nar"
fi
echo "$middle"
row HOSTNAME "$net_hostname"
row "MACHINE IP" "$net_machine_ip"
row "DNS     IP" "$net_dns_ip"
row "USER" "$net_current_user"
echo "$middle"
row "PROCESSOR" "$cpu_model"
row "CORES" "$cpu_cores"
row "LOAD  5m" "$cpu_5min_bar_graph"
echo "$middle"
row "MEMORY" "${mem_used_gb}/${mem_total_gb} GiB [${mem_percent}%]"
row "USAGE" "${mem_bar_graph}"
echo "$middle"
row "ROOT" "$root_dev [$root_type]"
row "VOLUME" "$root_used_gb/$root_total_gb GB [$root_percent%]"
row "USAGE" "$root_bar_graph"
echo "$middle"
row "UPTIME" "$sys_uptime"
echo "$bottom"
