#!/bin/sh

judgment(){
    vtype=$1
    mvalue=$2
    used=$(echo $3 | tr -d '%')
    if  [ $used  -lt  $mvalue ] 
    then
        printf "%s %s\n" "$vtype" "$3 OK"
    else
        printf "%s %s\n" "$vtype" "$3 alert"

    fi
    }
   
disk(){
    used=$(df | grep -w '/' | awk '{print $5}')
    judgment Disk—Root   85 $used
}

memory(){
    total=$(free | grep Mem | awk  '{print $2}')
    used=$(free | grep Mem | awk '{print $3}')
    usedp=$(($used * 100 / $total))%
    judgment Memory 90  $usedp
}

load(){
    total_core=$(grep -c 'model name' /proc/cpuinfo)
    total_load=$(uptime | awk -F ',' '{print $4}' |awk -F ':' '{print $2}')
    per_load=$(awk -v total_load="$total_load" -v  total_core="$total_core" 'BEGIN {print int(total_load * 100 / total_core)}')
    judgment Loadaverange 70 $per_load
}

disk
memory
load
