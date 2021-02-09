galaxy: roles
	ansible-playbook galaxy.yml --diff --extra-vars "__galaxy_dir_perms='0755' os_env_umask='022'"

roles: requirements.yml
	bash bin/clean-deps.sh
	ansible-galaxy install -p roles -r requirements.yml
