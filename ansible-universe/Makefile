
.PHONY: pyenv poetry versions

BASH_RC = ~/.bashrc
PYTHON_VERSION = 3.8.7
VAGRANT_CMD = vagrant
ANSIBLE_CMD = poetry run ansible all -i inventory
ANSIBLE_PLAYBOOK_CMD = poetry run ansible-playbook -i inventory

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

up: vagrant_init vagrant_up vagrant_setup
	@echo Configuring Vagrant Boxes

vagrant_up:
	$(VAGRANT_CMD) up --no-parallel

vagrant_init:
	$(ANSIBLE_PLAYBOOK_CMD) vagrant_init.yml

vagrant_setup:
	$(ANSIBLE_PLAYBOOK_CMD) vagrant_setup.yml

update:
	$(VAGRANT_CMD) box update

down:
	$(VAGRANT_CMD) down

status:
	$(VAGRANT_CMD) status

provision:
	$(VAGRANT_CMD) provision

ping:
	$(ANSIBLE_CMD) -m ping

facts:
	$(ANSIBLE_CMD) -m setup

destroy:
	vagrant destroy -f
	$(ANSIBLE_PLAYBOOK_CMD) vagrant_destroy.yml

versions:
	@python --version
	@pyenv --version
	@poetry --version
	@poetry run ansible --version

info:
	poetry env info
