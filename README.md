**TBA-cloud-provider**: logos of OpenNebula and the Cloud Provider

# Deploying OpenNebula as a Hosted Cloud on OVHcloud infrasturcture

This repository contains the needed code and documentation to perform an OpenNebula deployment and configuration on OVHcloud infrasturcture bare-metal resources. It extends the [one-deploy-validation](https://github.com/OpenNebula/one-deploy-validation) repository, which is added as a git submodule.

- [Requirements](#requirements)
- [Infrastructure Provisioning](#infrastructure-provisioning)
- [Required Parameters](#required-parameters)
- [Deployment and Validation](#deployment-and-validation)

## Requirements

1. Install `hatch`

   ```shell
   pip install hatch
   ```

1. Initialize the dependent `one-deploy-validation` and `one-deploy` submodule

   ```shell
   git submodule update --init
   ```

1. Install OpenNebula one-deploy dependencies using the submodule's tooling:

   ```shell
   make submodule-requirements
   ```

1. Install one-deploy dependencies, specific to OVHcloud deployment:

   ```shell
   make requirements-ovhcloud
   ```

## Infrastructure Provisioning

A detailed guide to provision the required reference infrastructure is published in **[{ADD LINK TO THE GUIDE HERE}]()**.
Follow the provisioning steps and extract the requiremed parameters needed to proceed with the OpenNebula deployment.

## Required Parameters

Update the [inventory](./inventory/) values to match the provisioned infrastructure.

| Description                              | Variable Names                                                | Files/Location                                         |
|------------------------------------------|---------------------------------------------------------------|--------------------------------------------------------|
| GUI password of `oneadmin`               | `one_pass`                                                    | [`inventory/ovhcloud.yml`](./inventory/ovhcloud.yml)   |
| Frontend/KVM Host IP                     | `ansible_host`                                                | [`inventory/ovhcloud.yml`](./inventory/ovhcloud.yml)   |
| Frontend/KVM Host public nics name       | `public_nics.name`                                            | [`inventory/ovhcloud.yml`](./inventory/ovhcloud.yml)   |
| Frontend/KVM Host public nics macaddress | `public_nics.macaddress`                                      | [`inventory/ovhcloud.yml`](./inventory/ovhcloud.yml)   |
| Frontend/KVM Host private nics name      | `private_nics.name`                                           | [`inventory/ovhcloud.yml`](./inventory/ovhcloud.yml)   |
| Frontend/KVM Host private nics macaddress| `private_nics.macaddress`                                     | [`inventory/ovhcloud.yml`](./inventory/ovhcloud.yml)   |
| VMs Public IP Range                      | `vn.vm_public.template.AR.IP`, `vn.vm_public.template.AR.SIZE`| [`inventory/ovhcloud.yml`](./inventory/ovhcloud.yml)   |
| VMs Public DNS                           | `vn.vm_public.template.DNS`                                   | [`inventory/ovhcloud.yml`](./inventory/ovhcloud.yml)   |
| VMs Public GATEWAY                       | `vn.vm_public.template.GATEWAY`                               | [`inventory/ovhcloud.yml`](./inventory/ovhcloud.yml)   |
| VMs Public NETWORK MASK                  | `vn.vm_public.template.NETWORK_MASK`                          | [`inventory/ovhcloud.yml`](./inventory/ovhcloud.yml)   |
| VMs Private VLAN_ID                      | `vn.vm_vlan*.template.VLAN_ID`                                | [`inventory/ovhcloud.yml`](./inventory/ovhcloud.yml)   |
| VMs Private IP Range                     | `vn.vm_vlan*.template.AR.IP`, `vn.vm_vlan*.template.AR.SIZE`  | [`inventory/ovhcloud.yml`](./inventory/ovhcloud.yml)   |
| VMs Private NETWORK MASK                 | `vn.vm_vlan*.template.NETWORK_MASK`                           | [`inventory/ovhcloud.yml`](./inventory/ovhcloud.yml)   |

## Deployment and Validation

Use the provided Makefile commands to automate deployment and testing:

1. Review the [inventory](./inventory/), [playbooks](./playbooks/) and [roles](./roles/) directories, following Ansible design guidelines.

1. Prepare OVHcloud bare metal servers:

   ```shell
   make pre-tasks-ovhcloud
   ```
   This step patches ubuntu kernel for security and performance optimization. It also perform networking setup, completing interface bounding
   leveraging on [OVHcloud Link Aggregation] (https://www.ovhcloud.com/en/bare-metal/ovhcloud-link-aggregation/) technology. If connectivity is lost, use local acces via IPMI to restore the original netplan file dumped during the early step of this ansible run or re install ubuntu on the bare metal.
   Ansible scripts should finish without any error, and report on the number of changes performed for each hosts. If any error is reported, after the necessary troubleshooting and fixes, the deployment script can be re-executed without further cleanup steps.

1. Deploy OpenNebula:

   ```shell
   make deployment
   ```
   Similarly, this should finish without any errors. After this step the cloud environment is fully functional.

1. Test the deployment:

   ```shell
   make validation
   ```
   Update the [inventory/group_vars/all.yaml](./inventory/group_vars/all.yaml) file to match the installation parameters based on "Required Parameters" section values.
   If the test fails in any of the steps, after the necessary troubleshooting and fixes, the validation command can be safely re-executed. The final HTML report is only created when all tests have passed.
   The output of the tests are compiled into a HTML report that can be found in path, printed by the automation script.

For more information about the submodule's tooling, refer to the [one-deploy-validation's README.md](https://github.com/OpenNebula/one-deploy-validation/blob/master/README.md) and for detailed documentation on the deployment automation refer to the [one-deploy repo](https://github.com/OpenNebula/one-deploy).


