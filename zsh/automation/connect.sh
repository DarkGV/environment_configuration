#!/bin/bash

function get_instances() {
    hosts=$(cat ~/.ssh/config.d/chess-ops@miniclip.com.eu-central-1.aws | grep "$AWS_PROFILE-mobile")
    instances_names=$(echo $hosts | sed -e "s/Host //g")
    echo "($(echo $instances_names | sed -e "s/\n/ /g"))"
}

function connect() {
    ssh $1
}
