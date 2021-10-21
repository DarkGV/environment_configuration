STRICT_MODE=${STRICT_MODE:-"true"}
OTP_VERSION=$(kerl prompt | tr -d ' ()')
is_strict() {
    if $STRICT_MODE;
    then
        echo "Strict Mode"
    else
        echo "Non Strict Mode"
    fi
}
right_prompt() {
    echo " %F{6}$REBAR_PROFILE %F{3}$AWS_PROFILE %F{4}$AWS_DEFAULT_REGION %F{1}OTP($OTP_VERSION) %F{8}$(is_strict)%{$reset_color%}"
}
RPROMPT+='$(right_prompt)'
