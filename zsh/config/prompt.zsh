STRICT_MODE=${STRICT_MODE:-"true"}
OTP_VERSION=$(kerl prompt | tr -d ' ()')
right_prompt() {
    echo "$STRICT_MODE%F{6}$REBAR_PROFILE %F{3}$AWS_PROFILE %F{4}$AWS_DEFAULT_REGION %F{1}OTP($OTP_VERSION)%{$reset_color%}"
}

RPROMPT+='$(right_prompt)'
