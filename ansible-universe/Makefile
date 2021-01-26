BASH_RC = ~/.bashrc
PYTHON_VERSION = 3.8.7
VAGRANT_CMD = vagrant
ANSIBLE_CMD = poetry run ansible all -i inventory
ANSIBLE_PLAYBOOK_CMD = poetry run ansible-playbook -i inventory
ANSIBLE_GALAXY_CMD = poetry run ansible-galaxy install
TEMPLATE = maketest


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

up: use ansible-requirements vagrant-init vagrant-update vagrant-prune vagrant-up vagrant-setup configure
	@echo Finished

ping: ansible-ping
	@echo Checking Ansible connection

destroy: vagrant-destroy
	@echo Destroying Vagrant boxes
	$(ANSIBLE_PLAYBOOK_CMD) vagrant_destroy.yml

use: backup
	@cp -v template/$(TEMPLATE)/vagrant.yml inventory/vagrant.yml
	@[ -f template/$(TEMPLATE)/configure.yml ]  && cp -v template/$(TEMPLATE)/configure.yml configure.yml || true
	@[ -f template/$(TEMPLATE)/requirements.yml ]  && cp -v template/$(TEMPLATE)/requirements.yml requirements.yml || true


backup:
	@[ -f backup/vagrant.yml ] && rm -v backup/vagrant.yml || true
	@[ -f backup/configure.yml ] && rm -v backup/configure.yml || true
	@[ -f backup/requirements.yml ] && rm -v backup/requirements.yml || true
	@[ -f inventory/vagrant.yml ] && cp inventory/vagrant.yml backup/vagrant.yml || true
	@[ -f configure.yml ] && cp configure.yml backup/configure.yml || true
	@[ -f requirements.yml ] && cp requirements.yml backup/requirements.yml || true

clean: backup
	@[ -f inventory/vagrant.yml ] && rm inventory/vagrant.yml || true
	@[ -f configure.yml ] && rm configure.yml || true
	@[ -f requirements.yml ] && rm requirements.yml || true

status: vagrant-status
	@echo Status

configure:
	@[ -f configure.yml ] && $(ANSIBLE_PLAYBOOK_CMD) configure.yml || echo "No configure.yml"

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
	@[ -f requirements.yml ] && $(ANSIBLE_GALAXY_CMD) -r requirements.yml || echo "No requirements.yml"

ansible-ping:
	$(ANSIBLE_CMD) -m ping

ansible-facts:
	$(ANSIBLE_CMD) -m setup

vagrant-destroy:
	vagrant destroy -f  || true


versions:
	@python --version
	@pyenv --version
	@poetry --version
	@poetry run ansible --version

info:
	poetry env info
