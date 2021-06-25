#!/bin/bash

function split_horizontally() {
    tmux split-window -t $1 -h
}

function split_vertically() {
    tmux split-window -t $1
}

function window_layout() {
    split_horizontally $1
    split_vertically $1
    tmux select-pane -t "$1.left"
    split_vertically $1
}

function maybe_start_work_tmux_session() {
    tmux ls &> /dev/null | grep "$1-work"
    if [ "$?" -eq "1" ]
    then
        work_window_name="$1-work"
        tmux new -s $work_window_name -d
    fi
}

function maybe_start_instances_tmux_session() {
    tmux ls &> /dev/null | grep "$1-instances"
    if [ "$?" -eq "1" ]
    then
        instances_window_name="$1-instances"
        tmux new -s $instances_window_name -d
        window_layout $instances_window_name
    fi
}

function start_workload() {
    maybe_start_work_tmux_session $AWS_PROFILE
    maybe_start_instances_tmux_session $AWS_PROFILE
}

function kill_workload() {
    tmux kill-session -t $1
}

function get_sessions() {
    sessions=$(tmux ls &> /dev/null | grep $AWS_PROFILE)

    session_names=$(echo $sessions | sed -e "s/:.*//g")
    echo "($(echo $session_names | sed -e "s/\n/ /g"))"
}
