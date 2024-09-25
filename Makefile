all: help

nginx: roles ## Deploy just NGINX configuration
	ansible-playbook galaxy.yml -l bioinf-galactus.erasmusmc.nl --diff --extra-vars "__galaxy_dir_perms='0755' os_env_umask='022'" -t nginx

galaxy: roles ## Do Galaxy deployment
	ansible-playbook galaxy.yml -l bioinf-galactus.erasmusmc.nl --diff --extra-vars "__galaxy_dir_perms='0755' os_env_umask='022'" 

roles: requirements.yml ## Update requirements
	# bash bin/clean-deps.sh
	ansible-galaxy install -p roles -r requirements.yml
	ansible-galaxy collection install -p roles -r requirements.yml

help:
	@egrep '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
.PHONY: help
