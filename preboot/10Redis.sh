#!/bin/bash
set +e
function sysconfig {
	$1 >/dev/null 2>&1
	if [ ! $? -eq 0 ]; then
		warn "Failed to run $1, are you running with --privileged?"
	fi
}

sysconfig "sysctl vm.overcommit_memory=1"
sysconfig "sysctl net.core.somaxconn=65535"
