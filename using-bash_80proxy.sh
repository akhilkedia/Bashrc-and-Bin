#!/bin/bash
## Taken from https://gist.github.com/frgomes/544014b53e5384e00847da20b3e1da5b
## see: http://github.com/frgomes/debian-bin/blob/master/bash_80proxy.sh
SCRIPT=/home/akhil/bin/bash_80proxy.sh

## INTF is the network interface, either a wired one, wireless or any other type
INTF=enp4s0

## DEFAULT_PROXY contains the HTTP_PROXY to be defined when INTF is connected
DEFAULT_PROXY=http://10.112.1.184:8080/

if [ "$1" == $INTF ] ;then
  source $SCRIPT
  case "$2" in
    up)
        proxy_on $DEFAULT_PROXY
      fi
      ;;
    down)
      proxy_off             
      ;;
  esac
fi

