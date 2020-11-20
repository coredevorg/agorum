#!/usr/bin/env bash

# set -x

_IFS="$IFS"
_IFS_="|"
args="$@"

# call: display_args "$@"
function display_args() {
    echo "count: $#"
    while [ $# -gt 0 ]; do echo "[$1]"; shift; done
}

# call: need_help "ifs" "ifs_args"
# return: ifs_args without help options 
function need_help() {

	local ifs="$1"
    local args="$2"
    local _ifs="$IFS"
    local err=1
    local new=
    IFS="$ifs" && set -- $args && IFS="$_ifs"
    while [ $# -gt 0 ]
	do
		case "$1" in
		help|--help|-h|-\?|\?) err=0 ;;
        *) [ "$new" ] && new="${new}${ifs}$1" || new="$1" ;;
		esac
		shift
	done
    echo "$new"
	return $err
}

function ifs_args() {
    local ifs="$1" ; shift
    local new=
    while [ $# -gt 0 ]
    do
        # echo "[$1]"
        [ "$new" ] && new="${new}${ifs}$1" || new="$1"
        shift
    done
    echo "$new"    
}

new=$(ifs_args $_IFS_ "$@")
echo "ifs_args: $new"
display_args "$@"

if help=$(need_help $_IFS_ "$new")
then
    echo "HELP"
else
    echo "NO"
fi
echo $?
echo "help: $help"
IFS="$_IFS_" && set -- $help && IFS="$_IFS"
echo $#
while [ $# -gt 0 ]
do
    echo "[$1]"
    shift
done
echo "$#"
