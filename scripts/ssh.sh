#!/bin/sh

case $1 in
  cis) 
    ssh ubuntu@cis.stuartellis.org -p 53124
  ;;
  *)
    echo "Specify a server"
  ;;
esac
