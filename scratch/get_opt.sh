#!/usr/bin/env bash

# set -x

OPT_a=false
OPT_s=false

function check_opts() {

    local opts="$1" prefix="$2" opt; shift 2
    # local opt

    while getopts $opts opt
    do
        eval ${prefix}_${opt}=true
        eval ${prefix}_${opt}_ARG="${OPTARG}"
        # case "${opt}" in
        # a) OPT_A=true ;;
        # s) OPT_S=true ;;
        # esac
    done
    # shift $((OPTIND-1))
    return $((OPTIND-1))
}


echo "$#"

check_opts "as:" "OPT" "$@" || shift $?
# shift $?

echo "$#"

echo $OPT_a $OPT_a_ARG
echo $OPT_s $OPT_s_ARG



# for arg
# do printf 'Something with "%s"\n' "$arg"
# done

#
# for ((i = 1; i <= $#; i++ )); do
#  printf '%s\n' "Arg $i: ${!i}"
# done

#
# args=( "$@"  )  # use double quotes
# shift 1
# if foo; then
#  node foo.js "$@"
# elif bar; then
#  node bar.js "$@"
# else
#   node default.js "${args[@]}"
# fi
#
