#!/bin/bash
## Spin up a Git server as a Docker container.
## By Stephen D. Rogers <inbox.c7r@steve-rogers.com>, 2017-06.
##
## Usage:
##
##     git-server.spin-up [--interactive|-i] [--restart policy] [--tty|-t] [listening_port]
##
## The git-server listening port (on the container host) defaults to 2203.
##

umask 0002

set -e -o pipefail

no_worries() {
        echo 1>&2 "No worries; continuing."
}

qq() {
	printf "%q" "$@"
}

xx() {
	echo 1>&2 "+" "$@"
	"$@"
}

##

run_options=
while [ $# -gt 0 ] ; do
case "$1" in 
--interactive|-i)
	run_options+="${run_options:+ }${1}"
	shift 1 ; continue
	;;
--restart)
	run_options+="${run_options:+ }${1} $(qq "${2}")"
	shift 2 ; continue
	;;
--tty|-t)
	run_options+="${run_options:+ }${1}"
	shift 1 ; continue
	;;
--)
	shift 1 ; break
	;;
-*)
	echo 1>&2 "unrecognized option: ${1}"
	exit 2
	;;
*)
	break;
	;;
esac
done

container_name=git-server
container_image=sdr01810/${container_name}:latest

p1h="${1:-2203}" # git-server listening port on the host
p1c="22"         # git-server listening port in the container

for d1h in /var/local/workspaces/git-server/ssh.ref ; do # git-server /etc/ssh reference directory on the host
for d1c in /git-server/ssh.ref ;                      do # git-server /etc/ssh reference directory in the container
for d2h in /var/local/workspaces/git-server/keys ;    do # git-server keys directory on the host
for d2c in /git-server/keys ;                         do # git-server keys directory in the container
for d3h in /var/local/workspaces/git-server/repos ;   do # git-server repos directory on the host
for d3c in /git-server/repos ;                        do # git-server repos directory in the container

	for dxh in "$d1h" "$d2h" "$d3h" ; do
	# The container determines owner uid/gid for "$dxh" and below;
	# seal off access to that subtree to just the superuser (root).
	for dxh_parent in "$(dirname "$(dirname "$dxh")")" ; do
		xx sudo mkdir -p "$dxh_parent"
		xx sudo chown root:root "$dxh_parent"
		xx sudo chmod 0770 "$dxh_parent"
		xx sudo chmod g+s "$dxh_parent"
	done;done

	xx :
	xx docker pull "$container_image"

	xx :
        xx docker stop "$container_name" || no_worries
	xx docker rm --force "$container_name" || no_worries

	xx :
	xx eval "docker run --name $(qq "$container_name") -d \
		-v $(qq "$d1h":"$d1c") -v $(qq "$d2h":"$d2c") \
		-v $(qq "$d3h":"$d3c") -p $(qq "$p1h":"$p1c") ${run_options} $(qq "$container_image")"

done;done
done;done
done;done

