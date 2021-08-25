#!/bin/zsh

PATCH_DIR=${PATCH_DIR:-"$HOME/.patches"}
PATCH_INTERVAL=${PATCH_INTERBAL:-86400} # One

function verify_progression() {
    echo -n $1
    read YN
    if [ "$YN" =~ "N|n" ]; then
        echo "Falling Back"
        touch .stop
    fi
}

function check_patch_dir() {
    if [ ! -d $PATCH_DIR/$1 ]; then
        mkdir $PATCH_DIR/$1
    fi
}

function remove_patch() {
    if [ "$1" == "" ]; then
        rm $PATCH_DIR/*
    fi
    
    rm -f $PATCH_DIR/$1.patch
}

function make_patch() {
    if [ ! -d .git ]; then
        echo "Not in git repository"
        return
    fi

    check_patch_dir $1

    if [ -d $PATCH_DIR/$1 ]; then
        verify_progression "Patch already exists. Override?[Y/n] "
        if [ -f .stop ]; then
            rm .stop
            return
        fi
    fi

    patch_name=$(date +"%Y%m%d%H%M%S")

    git diff > $PATCH_DIR/$1/$patch_name.patch    
}

function get_running_snapshots() {
    FILE_CONTENT=$(cat $PATCH_DIR/.snapshot_processes | sed "s/:/->/g")
    echo $FILE_CONTENT
}

function snap() {
    CurrentDirectory=$(pwd)

    if [ ! -d $CurrentDirectory/.git ]; then
        echo "Not in git repository"
        return
    fi    

    check_patch_dir $1

    while [ true ]
    do
        patch_name=$(date +"%Y%m%d%H%M%S")
        git diff > $PATCH_DIR/$1/$patch_name.patch    
        sleep $PATCH_INTERVAL # wait 5 seconds until next snapshot
    done
}

function stop_snap() {
    SNAPSHOTS=$(cat $PATCH_DIR/.snapshot_processes | grep $1)
    SNAPSHOTS_PID=$(echo $SNAPSHOTS | sed "s/.*://g")
    kill -9 $(echo $SNAPSHOTS_PID | sed "s/\n/ /g")
}

function git-patch() {
    case $1 in
        "rm")
            remove_patch $2;;
        "ls")
            ls $PATCH_DIR;;
        "snap_start")
           if [ "$2" == "" ]; then
                echo "Please set the snapshot name"
           fi
           snap $2 &
           echo "$2:$!" >> $PATCH_DIR/.snapshot_processes;;
        "snap_running")
           get_running_snapshots ;;
        "snap_stop")
            stop_snap $2;;
        "snap_take")
            make_patch $2;;
        *)
            echo "git-patch [rm | ls | snap_start | snap_running | snap_stop | snap_take]"
    esac

}
