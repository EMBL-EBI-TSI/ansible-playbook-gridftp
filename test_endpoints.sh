#!/usr/bin/env bash

# This script will transfer a file between endpoints in both directions
# Author: Luis Gracia <luis.gracia@ebi.ac.uk>

# List the enpoints, one per line, ie. my.gridftp.server/my/path

declare -a endpoints=(
)

if [ ${#endpoints[@]} -lt 1 ]; then
  echo "No endpoints defined"
  exit 1
fi

timestamp=$(date +'%Y%m%d%H%M%S')
file=test_gridftp_endpoints.txt

# Find max server string size
declare -i MAXSIZE=0
for endpoint in ${endpoints[@]}; do
  server=${endpoint/\/*}
  size=${#server}
  [ $size -gt $MAXSIZE ] && MAXSIZE=$size
done

# Print header
printf "%${MAXSIZE}s"
for endpoint in ${endpoints[@]}; do
  printf "  %${MAXSIZE}s" ${endpoint/\/*}
done
echo

# Print results
for endpoint1 in ${endpoints[@]}; do
  printf "%${MAXSIZE}s" ${endpoint1/\/*}
  echo $timestamp ${endpoint1/\/*} > $file
  globus-url-copy -q $file gsiftp://$endpoint2/ 2>test_transfer.stderr
  for endpoint2 in ${endpoints[@]}; do
    globus-url-copy -q gsiftp://$endpoint1/$file gsiftp://$endpoint2/ 2>test_transfer.stderr
    [ $? -gt 0 ] && status="no" || status="yes"
    printf "  %${MAXSIZE}s" $status
  done
  echo
done
