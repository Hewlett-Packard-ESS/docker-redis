#!/bin/bash
set +e
function sysconfig {
    {
		$1
	} 2> /dev/null
	if [ $? -eq 1 ]; then
		warn "Failed to run $1, are you running with --privileged?"
	fi
}

sysconfig "sysctl vm.overcommit_memory=1"
sysconfig "sysctl net.core.somaxconn=65535"
