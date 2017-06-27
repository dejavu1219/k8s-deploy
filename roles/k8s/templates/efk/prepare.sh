#!/bin/bash
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
END='\033[0m'
info(){
    info=$1
    echo -e "${GREEN}[INFO] $info${END}"
}
tip(){
    info=$1
    echo -e "${YELLOW}[TIP] $info${END}"
}
warn(){
    info=$1
    echo -e "${RED}[WARN] $info ${END}"
    exit 1
}

cmd="{{bin_dir}}/kubectl -s http://{{ansible_eth0.ipv4.address}}:{{k8s_insecure_port}}"
for i in `${cmd} get node|grep -v NAME|awk '{print $1}'`;do
    if ! ${cmd} get node $i -Lbeta.kubernetes.io/fluentd-ds-ready|awk '{print $NF}'|grep -q true;then
        ${cmd} label nodes $i beta.kubernetes.io/fluentd-ds-ready=true
    fi
done
