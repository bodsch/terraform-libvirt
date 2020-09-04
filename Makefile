THISDIR := $(notdir $(CURDIR))
PROJECT := $(THISDIR)
IP := 192.168.124.11

plan:
	terraform plan -var-file=$(PROJECT).tfvars

apply:
	terraform apply -auto-approve -var-file=$(PROJECT).tfvars

init:
	terraform init

show:
	terraform show

## recreate terraform resources
rebuild: destroy apply

destroy:
	terraform destroy -auto-approve

## ssh into VM, unique after each rebuild so refresh known_hosts
# ssh:
# 	ssh-keygen -f ~/.ssh/known_hosts -R $(IP)
# 	ssh-keyscan "$(IP)" >> ~/.ssh/known_hosts
# 	ssh sysadmin@$(IP) -i id_rsa

## create public/private keypair for ssh
# create-keypair:
#	@echo "THISDIR=$(THISDIR)"
#	ssh-keygen -t rsa -b 4096 -f id_rsa -C $(PROJECT) -N "" -q

metadata:
	terraform refresh && terraform output

## validate syntax of cloud_init
validate-cloud-config:
	cloud-init devel schema --config-file cloud_init.cfg
