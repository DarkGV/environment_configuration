#!/bin/bash

function help() {
    echo -e "infile - Find anything inside a file"
    echo -e "Usage: infile [file] [term]"
}

function infile() {
    if [[ -z "$1" || -z "$2" ]];
    then
        help
        return;
    fi
    cat $1 | grep --color=always -R $2 | less -r
}
