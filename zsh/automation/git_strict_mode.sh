STRICT_MODE=${STRICT_MODE:-"true"}
GIT_PATH=${GIT_PATH:-"git"}
MAKEFILES=${MAKEFILE:-["Makefile"]}
MAKE_COMMAND=${MAKE_COMMAND:-"make"}

function contains_makefile {
    return_value="-1"
    for known_makefile in $MAKEFILES
    do
        ls | grep $known_makefile > /dev/null
        if [ "$?" == "0" ];
        then
            return_value="0"
            break
        fi
    done
    echo $return_value
}

# override
function git {
    # We want to be strict when executing a git command    
    if $STRICT_MODE;
    then
        case $1 in
            "pull")
                $GIT_PATH pull --rebase;;
            "push")
                # Before pushing we should make and check that everything is right
                if [ $(contains_makefile) == "0" ];
                then
                    make $MAKE_OPTIONS && $GIT_PATH $@
                else;
                    $GIT_PATH $@
                fi
            ;;
            *)
                $GIT_PATH $@
            ;;
        esac
   else;
        $GIT_PATH $@ # Just let everything pass
   fi
}

