#!/bin/bash

sudo apt update

sudo apt install ca-certificates software-properties-common apt-transport-https curl -y

sudo su

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -

exit

sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"

sudo apt update
sudo apt install docker-ce=18.06.0~ce~3-0~ubuntu -y

sudo tee /etc/docker/daemon.json >/dev/null <<EOF
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2"
}
EOF

sudo mkdir -p /etc/systemd/system/docker.service.d
sudo systemctl daemon-reload
sudo systemctl restart docker

sudo su

curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -

cat <<EOF >/etc/apt/sources.list.d/kubernetes.list
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF

exit

sudo apt update

sudo sudo apt install kubernetes-cni=0.7.5-00 -y --allow-downgrades

sudo apt install -qy kubeadm=1.14.2-00 kubelet=1.14.2-00 kubectl=1.14.2-00

sudo apt-mark hold kubelet kubeadm kubectl

sudo sysctl net.bridge.bridge-nf-call-iptables=1


