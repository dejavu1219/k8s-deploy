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

dir={{k8s_cfg_dir}}
tokenFile={{k8s_cfg_dir}}/token.csv
cmd={{bin_dir}}/kubectl

test -f ${tokenFile} || warn "Token file not found: ${tokenFile}"
test -f ${cmd} || warn "Binary file not found: ${cmd}"
cd ${dir}

# 创建 kubelet bootstrapping kubeconfig 文件
# 设置集群参数
${cmd} config set-cluster kubernetes \
--certificate-authority={{k8s_ssl_dir}}/ca.pem \
--embed-certs=true \
--server={{kube_apiserver}} \
--kubeconfig=bootstrap.kubeconfig
# 设置客户端认证参数
${cmd} config set-credentials kubelet-bootstrap \
--token={{bootstrap_token}} \
--kubeconfig=bootstrap.kubeconfig
# 设置上下文参数
${cmd} config set-context default \
--cluster=kubernetes \
--user=kubelet-bootstrap \
--kubeconfig=bootstrap.kubeconfig
# 设置默认上下文
${cmd} config use-context default --kubeconfig=bootstrap.kubeconfig


# 创建kube-proxy kubeconfig文件
# 设置集群参数
${cmd} config set-cluster kubernetes \
--certificate-authority={{k8s_ssl_dir}}/ca.pem \
--embed-certs=true \
--server=${KUBE_APISERVER} \
--kubeconfig=kube-proxy.kubeconfig
# 设置客户端认证参数
${cmd} config set-credentials kube-proxy \
--client-certificate={{k8s_ssl_dir}}/kube-proxy.pem \
--client-key={{k8s_ssl_dir}}/kube-proxy-key.pem \
--embed-certs=true \
--kubeconfig=kube-proxy.kubeconfig
# 设置上下文参数
${cmd} config set-context default \
--cluster=kubernetes \
--user=kube-proxy \
--kubeconfig=kube-proxy.kubeconfig
# 设置默认上下文
${cmd} config use-context default --kubeconfig=kube-proxy.kubeconfig
