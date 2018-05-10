#!/bin/bash
set -e

DIR="/usr/local/nutanix/bin"

if [ "$1" = 'acli' ]; then
    sshpass -p $NTNX_PASSWORD ssh -4 -f $NTNX_USERNAME@$NTNX_IP -L 2030:$NTNX_IP:2030 -N -oStrictHostKeyChecking=no
    exec ${DIR}/acli
elif [ "$1" = 'nuclei' ]; then
    exec ${DIR}/nuclei -server $NTNX_IP -username $NTNX_USERNAME -password $NTNX_PASSWORD
elif [ "$1" = 'ncli' ]; then
    exec ${DIR}/ncli -s $NTNX_IP -u $NTNX_USERNAME -p $NTNX_PASSWORD
fi

exec "$@"