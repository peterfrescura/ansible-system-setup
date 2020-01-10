#!/usr/bin/env bash
set -x

if [ -e /etc/redhat-release ] ; then
  REDHAT_BASED=true
fi

TERRAFORM_VERSION="0.11.14"
PACKER_VERSION="1.2.4"
# # create new ssh key
# [[ ! -f /home/ubuntu/.ssh/mykey ]] \
# && mkdir -p /home/ubuntu/.ssh \
# && ssh-keygen -f /home/ubuntu/.ssh/mykey -N '' \
# && chown -R ubuntu:ubuntu /home/ubuntu/.ssh

# # install packages
# if [ ${REDHAT_BASED} ] ; then
#   yum -y update
#   yum install -y ansible unzip wget
# else
#   apt-get update && apt-get install -y software-properties-common
#   apt-add-repository ppa:ansible/ansible -y
#   apt-get update
#   apt-get install -y ansible unzip
# fi
# # add docker privileges
# usermod -G docker ubuntu
# # usermod -G docker vagrant
# # install pip
# pip install -U pip && pip3 install -U pip
# if [[ $? == 127 ]]; then
#     wget -q https://bootstrap.pypa.io/get-pip.py
#     python get-pip.py
#     python3 get-pip.py
# fi
# # install awscli
# pip3 install -U awscli
# # install ebcli
# pip3 install -U awsebcli

# # install pip docker for ansible
# pip install -U docker

# install kops
curl -sSLO https://github.com/kubernetes/kops/releases/download/$(curl -s https://api.github.com/repos/kubernetes/kops/releases/latest | grep tag_name | cut -d '"' -f 4)/kops-linux-amd64
chmod +x kops-linux-amd64
mv kops-linux-amd64 /usr/local/bin/kops

# install kubectl
curl -sSLO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
chmod +x kubectl
mv ./kubectl /usr/local/bin/kubectl

# install helm
curl https://raw.githubusercontent.com/helm/helm/master/scripts/get | bash

# install kompose
curl -L https://github.com/kubernetes/kompose/releases/download/v1.17.0/kompose-linux-amd64 -o kompose
chmod +x kompose
sudo mv ./kompose /usr/local/bin/kompose

#terraform
T_VERSION=$(/usr/local/bin/terraform -v | head -1 | cut -d ' ' -f 2 | tail -c +2)
T_RETVAL=${PIPESTATUS[0]}

[[ $T_VERSION != $TERRAFORM_VERSION ]] || [[ $T_RETVAL != 0 ]] \
&& wget -q https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
&& unzip -o terraform_${TERRAFORM_VERSION}_linux_amd64.zip -d /usr/local/bin \
&& rm terraform_${TERRAFORM_VERSION}_linux_amd64.zip

# packer
P_VERSION=$(/usr/local/bin/packer -v)
P_RETVAL=$?

[[ $P_VERSION != $PACKER_VERSION ]] || [[ $P_RETVAL != 1 ]] \
&& wget -q https://releases.hashicorp.com/packer/${PACKER_VERSION}/packer_${PACKER_VERSION}_linux_amd64.zip \
&& unzip -o packer_${PACKER_VERSION}_linux_amd64.zip -d /usr/local/bin \
&& rm packer_${PACKER_VERSION}_linux_amd64.zip

# clean up
if [ ! ${REDHAT_BASED} ] ; then
  apt-get clean
fi