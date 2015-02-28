# Configuration for Ansible

An experimental configuration for [Ansible](http://www.ansible.com).

## Usage

To set up Ansible on an OS X workstation:

    ./do.sh setup-admin

To create a new Linode using Ansible and the Linode API:

    ./do.sh create-linode

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
