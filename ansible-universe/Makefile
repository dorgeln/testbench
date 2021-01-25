
.PHONY: pyenv poetry versions

BASH_RC = ~/.bashrc
PYTHON_VERSION = 3.8.7
VAGRANT_CMD = vagrant
ANSIBLE_CMD = poetry run ansible all -i inventory
ANSIBLE_PLAYBOOK_CMD = poetry run ansible-playbook -i inventory
ANSIBLE_GALAXY_CMD = poetry run ansible-galaxy install

help:
	@echo HELP

pyenv:
	pyenv versions | grep -q $(PYTHON_VERSION) || pyenv install $($PYTHON_VERSION)
	pyenv local $($PYTHON_VERSION)
	grep -q "PYENV_ROOT=" $(BASH_RC) || echo 'export PYENV_ROOT="$$HOME/.pyenv"' >> $(BASH_RC)
	grep -q 'PATH="$$PYENV_ROOT' ~/.bashrc || echo 'export PATH="$$PYENV_ROOT/bin:$$PATH"' >> $(BASH_RC)
	grep -q 'pyenv init' $(BASH_RC) || echo -e 'eval "$$(pyenv init -)"' >> $(BASH_RC)

poetry:
	pip install poetry

up: ansible-requirements vagrant-init vagrant-update vagrant-prune vagrant-up vagrant-setup
	@echo Configuring Vagrant Boxes

ping: ansible-ping
	@echo Checking Ansible connection

destroy:vagrant-destroy
	@echo Destroying Vagrant boxes

inventory-backup:
	cp inventory/vagrant.yml backup/vagrant.yml | true

use-distrotest: inventory-backup
	cp template/inventory/vagrant.yml.distrotest inventory/vagrant.yml

use-haweb: inventory-backup
		cp template/inventory/vagrant.yml.haweb inventory/vagrant.yml

distrotest: destroy use-distrotest up
	@echo Running Distrotest

haweb: destroy use-haweb up
		@echo Running haweb

vagrant-up:
	$(VAGRANT_CMD) up --no-parallel

vagrant-init:
	$(ANSIBLE_PLAYBOOK_CMD) vagrant_init.yml

vagrant-setup:
	$(ANSIBLE_PLAYBOOK_CMD) vagrant_setup.yml

vagrant-update:
	$(VAGRANT_CMD) box update

vagrant-halt:
	$(VAGRANT_CMD) halt

vagrant-status:
	$(VAGRANT_CMD) status

vagrant-provision:
	$(VAGRANT_CMD) provision

vagrant-prune:
	$(VAGRANT_CMD) box prune

ansible-requirements:
	$(ANSIBLE_GALAXY_CMD) -r requirements.yml

ansible-ping:
	$(ANSIBLE_CMD) -m ping

ansible-facts:
	$(ANSIBLE_CMD) -m setup

vagrant-destroy:
	vagrant destroy -f
	$(ANSIBLE_PLAYBOOK_CMD) vagrant_destroy.yml

versions:
	@python --version
	@pyenv --version
	@poetry --version
	@poetry run ansible --version

info:
	poetry env info
