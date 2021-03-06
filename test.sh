#!/bin/bash

set -e

launchTest() {
	local period=$1
	local quota=$2

	echo
	echo "==== Launching test with period=$period and quota=$quota"
	echo "==== Press ^C to stop test"
	sleep 1

	echo $period >/sys/fs/cgroup/cpu/weak/cpu.cfs_period_us
	echo $quota >/sys/fs/cgroup/cpu/weak/cpu.cfs_quota_us

	cgexec -g cpu:weak go run latency_warn.go || true # exit by ^C
}

err() {
	echo "$@" >&2
	exit 1
}

[[ $EUID -eq 0 ]] || err "must be root to run this script"

for u in cgcreate cgexec go; do
	found=$(type $u >/dev/null 2>&1 && echo Y || echo N)
	if [[ $found == N ]]; then
		err "$u not found, install it first"
	fi
done

if [[ ! -e /sys/fs/cgroup/cpu/weak ]]; then
	cgcreate -g cpu:/weak
	trap "cgdelete cpu:/weak" EXIT
fi

##
# in both cases you will get 25% of CPU usage for your app
# but with very different delays
launchTest 1000000 250000 # bad for latency, 0.75 sec sleep
launchTest 10000 2500 # good for latency
