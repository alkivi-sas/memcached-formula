FORMULA_NAME = "memcached"
PWD = $(shell pwd)

# ---------------------------------------------------------------
define render_dockerfile
	python $(PWD)/tools/filltmpl.py $(FORMULA_NAME) $(1)
endef

define docker_build
	docker build --force-rm -t $(FORMULA_NAME):salt-testing-$(1) -f Dockerfile.$(1) .
endef

define docker_run_local
	docker run --rm -v $(PWD):/opt/$(FORMULA_NAME)-formula --env=STAGE=TEST -h salt-testing-$(1) --name salt-testing-$(1) -it $(FORMULA_NAME):salt-testing-$(1) /bin/bash
endef

define run_tests
	./tools/run-tests.sh $(FORMULA_NAME) $(1)
endef

# --- convenience functions -------------------------------------
define build_thing
	$(call render_dockerfile,$(1)) && $(call docker_build,$(1))
endef

define run_local_tests
	$(call build_thing,$(1)) && $(call run_tests,$(1))
endef

define run_local
	$(call build_thing,$(1)) && $(call docker_run_local,$(1))
endef

# ---------------------------------------------------------------
setup:
	pip install Jinja2

clean:
	find . -name '*.pyc' -exec rm '{}' ';'
	find . -name '__pycache__' -type d -prune -exec rm -rf '{}' '+'
	find . -name '.pytest_cache' -type d -prune -exec rm -rf '{}' '+'
	rm -rf tests/Dockerfile*

# --- centos_master_2017.7.2 ------------------------------------
test-centos_master_2017.7.2: clean
	$(call run_local_tests,centos_master_2017.7.2)

local-centos_master_2017.7.2: clean
	$(call run_local,centos_master_2017.7.2)

# --- debian_master_2017.7.2 ------------------------------------
test-debian_master_2017.7.2: clean
	$(call run_local_tests,debian_master_2017.7.2)

local-debian_master_2017.7.2: clean
	$(call run_local,debian_master_2017.7.2)

# --- opensuse_master_2017.7.2 ------------------------------------
test-opensuse_master_2017.7.2: clean
	$(call run_local_tests,opensuse_master_2017.7.2)

local-opensuse_master_2017.7.2: clean
	$(call run_local,opensuse_master_2017.7.2)

# --- ubuntu_master_2016.11.3 ------------------------------------
test-ubuntu_master_2016.11.3: clean
	$(call run_local_tests,ubuntu_master_2016.11.3)

local-ubuntu_master_2016.11.3: clean
	$(call run_local,ubuntu_master_2016.11.3)

# --- ubuntu_master_2017.7.2 ------------------------------------
test-ubuntu_master_2017.7.2: clean
	$(call run_local_tests,ubuntu_master_2017.7.2)

local-ubuntu_master_2017.7.2: clean
	$(call run_local,ubuntu_master_2017.7.2)
