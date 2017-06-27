#!/bin/bash
docker login -u {{docker.user}} -p {{docker.password}} {{docker.registry}}
docker images|grep -Eq "pause-amd64\s+3.0" || docker pull {{base_pod}}
{% if ansible_eth0.ipv4.address in groups['k8s_master'] %}
serviceSecretName=regsecret
cmd="{{bin_dir}}/kubectl -s http://{{ansible_eth0.ipv4.address}}:{{k8s_insecure_port}}"
for csr in `${cmd} get csr|grep "kubelet-bootstrap"|grep -v NAME| awk '{print $1}'`;do
    ${cmd} certificate approve ${csr}
done

${cmd} get secret |grep "\<regsecret\>" || ${cmd} create secret docker-registry ${serviceSecretName} --docker-server={{docker.registry}} --docker-username={{docker.user}} --docker-password={{docker.password}} --docker-email={{docker.email}}
${cmd} get secret --namespace kube-system |grep "\<regsecret\>" || ${cmd} create secret docker-registry ${serviceSecretName} --docker-server={{docker.registry}} --docker-username={{docker.user}} --docker-password={{docker.password}} --docker-email={{docker.email}} --namespace=kube-system
{% endif %}
