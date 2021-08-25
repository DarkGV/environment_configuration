#!/bin/bash

HIGH_TRAFFIC_MIN_OFFSET=${HIGH_TRAFFIC_MIN_OFFSET:-10}
HIGH_TRAFFIC_MAX_OFFSET=${HIGH_TRAFFIC_MAX_OFFSET:-22}

function get_instances() {
    hosts=$(cat ~/.ssh/config.d/chess-ops@miniclip.com.eu-central-1.aws | grep "$AWS_PROFILE-mobile")
    instances_names=$(echo $hosts | sed -e "s/Host //g")
    echo "($(echo $instances_names | sed -e "s/\n/ /g"))"
}

function is_high_traffic_time() {
    current_time=$(date +"%H")
    if [ $current_time -ge $HIGH_TRAFFIC_MIN_OFFSET ] && [ $current_time -le $HIGH_TRAFFIC_MAX_OFFSET ] && [ $OVERRIDE_ACESS_SAFE != "true" ]; then
        echo "true"
    else
        echo "false"
    fi
}

function connect() {
    if [ "$1" =~ "prod" ] && [ "$(is_high_traffic_time)" == "true" ]; then
        echo "Cannot connect to production"
    else
        ssh $1
    fi
}
