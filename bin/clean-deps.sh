#!/bin/bash
set -e -o pipefail

if [[ ! -d roles/ ]]; then
	# No roles dir
	exit 0
fi

for roledir in $(find roles -maxdepth 1 -mindepth 1 -type d); do
	repo=$(echo $roledir | cut -d/ -f2)
	vers=$(cat roles/$repo/meta/.galaxy_install_info | grep version | cut -d' ' -f2)
	echo "Checking $repo / $vers"

	results="$(grep "$repo" -A2 requirements.yml)"
	ec=$?

	# Not under git's control
	if (( ec == 0 )); then
		expected_version=$(echo "$results" | grep version | sed 's/.*version: //g')

		if [[ "$vers" != "$expected_version" ]]; then
			echo "Removing $repodir: $vers != $expected_version";
			ansible-galaxy role remove -p roles $repo
		fi
	fi
done
