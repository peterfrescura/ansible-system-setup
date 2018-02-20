Disclaimer: Use this at your own risk, I forked this and made changes that I
needed to get this working for my specific case: get up and running as quickly
as pssible after a fresh mint (18.2) install.

Usage
-----

There are two kinds of machines:

* masters: my own computers.  Each of them has a clone of this repository and
  can run ansible playbooks to configure itself and other hosts (*including
  other masters*).

* slaves: servers I have access to, my family's computers, my accounts on other
  people's computers.  I don't run ansible from them.


### Setting up a new master

To bootstrap a completely new machine, run (steps I use):

    sudo apt-get --yes install git
    # if the directory exists this mkdir command should be harmless?
    mkdir ~/.config
    cd ~/.config/
    git clone https://github.com/puzzledvacuum/ansible-system-setup
    ./ansible-system-setup/bootstrap.sh

[`bootstrap.sh`](bootstrap.sh) ensures that the machine can ssh into itself and
that it has Ansible installed.

After that, update the `inventory` file and you're ready to run Ansible
playbooks.


### Setting up a new slave

1. Add it to the `inventory` file (and master(s)' `/etc/hosts` if appropriate)
2. Install an SSH server, e.g. `sudo apt-get install openssh-server`
3. Copy your public key to authorized keys e.g. using `ssh-copy-id`


### Running ansible

Run Ansible playbooks like this (you can omit sudo prompt for some of them):

    # example to execute a single role
    ansible-playbook -i inventory ansible-system-setup/roles/install-software/tasks/install-timeshift.yml --ask-sudo-pass
    # example to execute multiple roles (playbook)
    ansible-playbook -i inventory ansible-system-setup/install-software.yml --ask-sudo-pass

Note that some roles require packages that are installed by `install-software`
role, so you should run it first.  In particular, most of the roles require git.
I could have added git installation task to the roles that need it, but doing
so would require me to type my sudo password every time I wanted to run them -
and I'm too lazy for that. I have added checks so that roles only add keys
etc. if packages arent installed, this must be done more elagantly.



Forking
-------

You are encouraged to fork this repo and use it as a basis for your own system
provisioning!  Some things that you will have to change:

- replace information about my hosts in `inventory` file with your own
- replace public keys installed by `user-config` role



License
-------

MIT license.
