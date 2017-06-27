### Dependencies

- This repository is to help deploy kubernetes 1.6.0 on Ubuntu 14.04. Ansible version should be at least 2.2.0.0. To force the Chinese GFW limit, all docker images from `gcr.io` and packages from sites which are blocked by Chinese GFW had all been downloaded and uploaded to private registry. In order to share some common config files (Such as ssl certs and keys, k8s configs etc), it is assumed that you have a SAMBA share server.

### How to

- Update group var config file to fit your local environment

	- Group var config file: `group_vars/all.yml`
	- Some vars should be updated:
	
| Variable  | Stands for |
| ------| ------ | 
| storage.pub_src | The shared path on your share server |
| storage.pub_user | Username to access your shared path |
| storage.pub_pass | Password to access your shared path |
| storage.pub_pass | Password to access your shared path |
| download_server | Your local package server **China only** |
| cluster_ip_range | The cluster ip range of kubernetes (Should NOT be exists in your local net) |
| cluster_first_ip | The first cluster ip address of kubernetes (Should NOT be exists in your local net) |
| dns_server_ip | The ip address  of kubernetes DNS server (Should NOT be exists in your local net) |
| flanneld_net | The nets assigned to flanneld (Should NOT be exists in your local net) |
| docker.registry | The private docker registry **China only** |
| docker.user | Username for accessing private docker registry **China only** |
| docker.password | Password for accessing private docker registry **China only** |
| docker.email | Email for accessing private docker registry **China only** |
| base_pod | The base infra pod for kubelet (default is `gcr.io/google_containers/pause-amd64:3.0`) **China only** |

- Update hosts file and ansible config file according to your env

	- Update ip address in hosts file: `hosts`.
	- Update ansible.cfg to fit your own env.
	- Replace `config/id_rsa` by your own ssh private key.
	
- Start to deploy

	```
	ansible-playbook playbook.yml
	```
