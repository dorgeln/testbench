
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

up: ansible-requirements vagrant-init vagrant-update vagrant-prune vagrant-up vagrant-setup configure
	@echo Configuring Vagrant Boxes

ping: ansible-ping
	@echo Checking Ansible connection

destroy: vagrant-destroy
	@echo Destroying Vagrant boxes
		$(ANSIBLE_PLAYBOOK_CMD) vagrant_destroy.yml

backup:
	rm backup/vagrant.yml | true
	rm backup/configure.yml | true
	rm backup/requirements.yml | true
	cp inventory/vagrant.yml backup/vagrant.yml | true
	cp configure.yml backup/configure.yml | true
	cp requirements.yml backup/requirements.yml | true

clean: backup
	rm inventory/vagrant.yml | true
	rm configure.yml | true
	rm requirements.yml | true

use-libvirttest: backup
		cp template/libvirttest/vagrant.yml inventory/vagrant.yml

use-vboxtest: backup
	cp template/vboxtest/vagrant.yml inventory/vagrant.yml

vboxtest: destroy use-vboxtest up
	@echo Running vboxtest

libvirttest: destroy clean use-libvirttest up
	@echo Running libvirttest

use-haweb: backup
	cp template/haweb/vagrant.yml inventory/vagrant.yml
	cp template/haweb/configure.yml configure.yml
	cp template/haweb/requirements.yml requirements.yml

haweb: destroy clean use-haweb up configure
	@echo Running haweb

use-elk: backup
		cp template/elk/vagrant.yml inventory/vagrant.yml
		cp template/elk/configure.yml configure.yml
		cp template/elk/requirements.yml requirements.yml

elk: destroy clean use-elk up configure
		@echo Running elk

use-distrotest: backup
	cp template/distrotest/vagrant.yml inventory/vagrant.yml


distrotest: destroy clean use-distrotest up
	@echo Running Distrotest



status: vagrant-status
	@echo Status

configure:
		$(ANSIBLE_PLAYBOOK_CMD) configure.yml

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
	$(ANSIBLE_GALAXY_CMD) -r requirements.yml | true

ansible-ping:
	$(ANSIBLE_CMD) -m ping

ansible-facts:
	$(ANSIBLE_CMD) -m setup

vagrant-destroy:
	vagrant destroy -f  | true


versions:
	@python --version
	@pyenv --version
	@poetry --version
	@poetry run ansible --version

info:
	poetry env info
