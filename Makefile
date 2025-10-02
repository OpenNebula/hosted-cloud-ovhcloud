SELF  := $(patsubst %/,%,$(dir $(abspath $(firstword $(MAKEFILE_LIST)))))

ENV_RUN      = hatch env run -e $(1) --
ENV_OVHCLOUD_DEFAULT := $(shell hatch env find ovhcloud-default)

ifdef ENV_OVHCLOUD_DEFAULT
$(ENV_OVHCLOUD_DEFAULT):
	hatch env create ovhcloud-default
endif

.PHONY: submodule-requirements requirements-ovhcloud pre-tasks-ovhcloud deployment validation 

# Retrieve ansible collection for openNebula, using the parent Makefile.
submodule-requirements:
	$(MAKE) -C submodule-one-deploy requirements

# Retrieve ansible collection for OVHcloud pre tasks excecution
requirements-ovhcloud: $(SELF)/requirements.yml $(ENV_OVHCLOUD_DEFAULT)
	$(call ENV_RUN,ovhcloud-default) ansible-galaxy collection install --requirements-file $<

# Prepare OVHcloud bare matal servers before deploying OpenNebula
pre-tasks-ovhcloud: $(ENV_OVHCLOUD_DEFAULT)
	cd $(SELF)/ && \
    $(call ENV_RUN,ovhcloud-default) ansible-playbook $(SELF)/playbooks/ovhcloud.yml --diff

# Deploy openNebula, using the parent Makefile.
deployment:
	$(MAKE) -C submodule-one-deploy I=$(SELF)/inventory/ovhcloud.yml main

# Run openNebula validation tasks, using the parent Makefile.
validation:
	$(MAKE) -C submodule-one-deploy-validation I=$(SELF)/inventory/ovhcloud.yml $@
