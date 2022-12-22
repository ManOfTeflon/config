#!/bin/bash

set -exo pipefail

TAG="address@hidden"

function _ksh_W
{
    case ${PWD} in
        ${HOME})
            print '~'
            ;;
        '/')
            print '/'
            ;;
        *)
            print "${PWD##*/}/"
            ;;
    esac
}

tput hs &&
{
    WLS=$(tput ts)    
    WLE=$(tput fs)    
}

[[ -n ${WLS} ]] &&
{
    function _stripe
    {
        print -n "${WLS}"$(_ksh_W)" <${TAG}>${WLE}" > /dev/tty
    }

    _stripe
}
