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
  playbook)
    ansible-playbook -K -i inventory $2
  ;;
  hash-password)
    python -c "from passlib.hash import sha512_crypt; import getpass; print sha512_crypt.encrypt(getpass.getpass())"
  ;;
  create-droplet)
    ansible-playbook -i inventory/localhost create_droplet.yml --extra-vars "droplet_name=$2"
  ;;
  create-linode)
    ansible-playbook -i inventory/localhost create_linode.yml --extra-vars "linode_name=$2"
  ;;
  provision)
    ansible-playbook -i inventory/$2 setup_ubuntu_servers.yml
  ;;
  run)
    ansible-playbook -K -i inventory/$2 setup_ubuntu_servers.yml
  ;;
  setup-workstation)
    ansible-playbook -i inventory/localhost setup_osx_workstations.yml
  ;;
esac
