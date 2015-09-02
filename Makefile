default: help
.PHONY: create-droplet create-ec2 create-linode osx-controller osx-workstation password provision repo run

help:
				@echo "make create-droplet - create a standard Digital Ocean droplet"
				@echo "make create-ec2 - create a standard Amazon EC2 server"
				@echo "make create-linode - create a standard Linode server"
				@echo "make osx-controller - install Ansible on the current Mac OS X system"
				@echo "make osx-workstation - use Ansible to set up the current Mac OS X system"
				@echo "make password - create a SHA512 hash from a given password"
				@echo "make provision - set up a system as a Ruby on Rails server"
				@echo "make repo - create the directory structure for an Ansible repository"
				@echo "make run - execute the specified playbook on an inventory of nodes"

create-droplet:
				ansible-playbook -i inventory/localhost create_droplet.yml

create-ec2:
				ansible-playbook -i inventory/localhost create_ec2.yml

create-linode:
				ansible-playbook -i inventory/localhost create_linode.yml

osx-controller:
				brew update && brew install ansible
				sudo easy_install pip
				pip install --user linode-python
				pip install --user dopy
				pip install --user pycurl
				pip install --user passlib
				ansible-galaxy install rvm_io.rvm1-ruby

osx-workstation:
				ansible-playbook -i inventory/localhost setup_osx_workstations.yml

password:
				python -c "from passlib.hash import sha512_crypt; import getpass; print sha512_crypt.encrypt(getpass.getpass())"

provision:
				read -p "Inventory: " INVENTORY ; ansible-playbook -i inventory/$$INVENTORY setup_rails4_servers.yml --extra-vars "ansible_ssh_port=22"

repo:
				mkdir -p filter_plugins group_vars host_vars inventory library playbooks roles
				mkdir -p roles/common/tasks roles/common/handlers roles/common/templates roles/common/files roles/common/vars roles/common/defaults roles/common/meta

run:
				read -p "Playbook (inc. file ext.): " PLAYBOOK ; read -p "Target inventory: " INVENTORY ; ansible-playbook -i inventory/$$INVENTORY $$PLAYBOOK
