# Configuration for Ansible

An experimental configuration for [Ansible](http://www.ansible.com).

## Usage

To set up Ansible on an OS X workstation:

    ./do.sh setup-admin
    cp ./ansible.cfg.example ./ansible.cfg

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

