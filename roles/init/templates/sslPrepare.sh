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
sslCfgDir={{deploy_base}}/ssl
cfgList=(ca-csr.json ca-config.json kubernetes-csr.json admin-csr.json kube-proxy-csr.json)
cmd={{bin_dir}}/cfssl
cfssljson={{bin_dir}}/cfssljson

test -f ${cmd} || warn "Binary file not found: ${cmd}"
test -d ${sslCfgDir} || warn "Directory not exists: ${sslCfgDir}"
for cfg in ${cfgList[@]};do
    test -f ${sslCfgDir}/${cfg} || warn "Config file not found: ${sslCfgDir}/${cfg}"
done
cd ${sslCfgDir}
${cmd} gencert -initca ca-csr.json | ${cfssljson} -bare ca
${cmd} gencert -ca=ca.pem -ca-key=ca-key.pem -config=ca-config.json -profile=kubernetes kubernetes-csr.json | ${cfssljson} -bare kubernetes
${cmd} gencert -ca=ca.pem -ca-key=ca-key.pem -config=ca-config.json -profile=kubernetes admin-csr.json | ${cfssljson} -bare admin
${cmd} gencert -ca=ca.pem -ca-key=ca-key.pem -config=ca-config.json -profile=kubernetes  kube-proxy-csr.json | ${cfssljson} -bare kube-proxy
