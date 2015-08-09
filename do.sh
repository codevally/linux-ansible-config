#!/bin/sh

case $1 in
  setup-ansible)
    brew update && brew install ansible
    sudo easy_install pip
    pip install --user linode-python
    pip install --user dopy
    pip install --user pycurl
    pip install --user passlib
  ;;
  setup-repo)
    mkdir -p filter_plugins group_vars host_vars inventory library playbooks roles
    mkdir -p roles/common/tasks roles/common/handlers roles/common/templates roles/common/files roles/common/vars roles/common/defaults roles/common/meta
  ;;
  hash-password)
    python -c "from passlib.hash import sha512_crypt; import getpass; print sha512_crypt.encrypt(getpass.getpass())"
  ;;
  create-droplet)
    ansible-playbook -i inventory/localhost create_droplet.yml --extra-vars "droplet_name=$2"
  ;;
  create-ec2)
    ansible-playbook -i inventory/localhost create_ec2.yml --extra-vars "security_group_name=$2 subnet_id=$3 keypair=$4"
  ;;
  create-linode)
    ansible-playbook -i inventory/localhost create_linode.yml --extra-vars "linode_name=$2"
  ;;
  provision)
    ansible-playbook -i inventory/$2 setup_rails4_servers.yml --extra-vars "hostname=$3 mysql_root_pass=$4"
  ;;
  run)
    ansible-playbook -i inventory/$2 $3
  ;;
  setup-workstation)
    ansible-playbook -i inventory/localhost setup_osx_workstations.yml
  ;;
esac
