#!/bin/bash

UPDATE_FREQ=1
SVDIR=$HOME/.runit/service

print_service() {
    case $(<$1/supervise/stat) in
        "run") echo -ne "[\e[32mRUN\e[0m]" ;;
        *) echo -ne "[\e[31m???\e[0m]" ;;
    esac

    echo " $(basename $1)"
}

print_all() {
    for sv in $SVDIR/*; do
        print_service $sv
    done
}

draw() {
    echo "$(print_all)" | column
    exit 0
}

showhelp() {
    echo "Usage: ./svmon [-hs]"
    echo "Arguments:"
    echo "    -h - Show help"
    echo "    -s - Print status of all services and quit"
    exit 1
}

# Argument parsing
OPTSTRING=":hs"
while getopts ${OPTSTRING} arg; do
    case "${arg}" in
        h) showhelp ;;
        s) draw ;;
        ?)
            echo "Invalid option: -${OPTARG}"
            showhelp
            ;;
    esac
done

# Main loop
exec watch -c -t -n $UPDATE_FREQ -x bash -c "./$0 -s 2> /dev/null"
