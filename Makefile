
.PHONY: pyenv

BASH_RC = ~/.bashrc
PYTHON_VERSION = 3.8.7
ANSIBLE_VERSION = 2.9.17

pyenv:
	pyenv versions | grep -q $(PYTHON_VERSION) || pyenv install $($PYTHON_VERSION)
	pyenv local $($PYTHON_VERSION)
	grep -q "PYENV_ROOT=" $(BASH_RC) || echo 'export PYENV_ROOT="$$HOME/.pyenv"' >> $(BASH_RC)
	grep -q 'PATH="$$PYENV_ROOT' ~/.bashrc || echo 'export PATH="$$PYENV_ROOT/bin:$$PATH"' >> $(BASH_RC)
	grep -q 'pyenv init' $(BASH_RC) || echo -e 'eval "$$(pyenv init -)"' >> $(BASH_RC)

poetry:
	pip install poetry
versions:
	@python --version
	@pyenv --version
	@poetry --version
