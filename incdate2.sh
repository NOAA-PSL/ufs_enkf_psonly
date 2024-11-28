#!/bin/bash
if [ $# != 2 ]; then
  echo "usage: incdate2 YYYYMMDDHHMM mins"
  echo "where YYYYMMDDHHMM is a 12 character date string (format %Y%m%d%H%M, e.g. 200205031230)"
  echo "and mins is minutes to increment YYYMMDDHHMM"
  exit 1
fi
date -u -d "${1:0:4}-${1:4:2}-${1:6:2} ${1:8:2}:${1:10:2}:00 UTC $2 minute" +%Y%m%d%H%M
