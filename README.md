# Configuration for Ansible

An experimental configuration for [Ansible](http://www.ansible.com).

## Usage

To set up Ansible on an OS X workstation:

    ./do.sh setup-admin
    cp ./ansible.cfg.example ./ansible.cfg

To create a new Linode using Ansible and the Linode API:

    ./do.sh create-linode

Ansible provides two commands:

* *ansible-playbook* - to execute all of an Ansible playbook on the specified systems
* *ansible* - to execute an individual shell command or Ansible module on the specified systems 

In each case, use *-i* to specify the inventory file or directory that lists the specified systems.

Use *-a* to execute a shell command:

    ansible all -i inventory -a /usr/bin/uptime

Use *-m* to execute an Ansible module:

    ansible all -i inventory -m ping

To run a playbook:

    ansible-playbook -K -i inventory my_playbook.yml    

Add *--syntax-check* to test the Ansible playbook without running it:

    ansible-playbook --syntax-check -K -i inventory my_playbook.yml    

Add *--check* to simulate the effect without making changes to the target systems:

    ansible-playbook --check -K -i inventory my_playbook.yml    

## Directory structure

For convenience, the Ansible playbooks are in the root of this project.

* ansible.cfg - Configuration file for Ansible
* examples/ - Various templates and examples
* filter_plugins/ - Custom filter plugins
* host_vars/ - Variables for individual host systems
* inventory/ - Lists of host systems
* group_vars/ - Variables for groups of systems  
* library/ - Custom Ansible modules
* roles/ - Custom roles used by the Ansible playbooks
* scripts/ - Utility scripts

## Contact ##

Email:

<stuart@stuartellis.eu>

## License ##

Copyright 2015, Stuart Ellis

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

<http://www.apache.org/licenses/LICENSE-2.0>
 
Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

