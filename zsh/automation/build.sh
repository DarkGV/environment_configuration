#!/bin/zsh

source ~/.zsh/automation/pretty_print

build_server() {
    if [ -d _build ] && rm -rf _build
    if [ -z $JENKINS_TOKEN ] && echo "Please set JENKINS_TOKEN" && return -1

    arg="Building $AWS_PROFILE in $REBAR_PROFILE"

    print $arg

    make # build everything we need

    make aws/cfn/
}

alias deploy=build_server

switch() {
    export REBAR_PROFILE=$1
}
