#!/bin/bash

usage() {
	echo "usage: docker-build.sh <image> <command> <arguments> [base]"
	echo ""
	echo "available commands:"
	echo "  add '<local_file/dir> <image_file/dir>'"
	echo "  run <shell_command>"
	echo "  cmd <shell_command>"
	exit 1
}

dockerfile() {
	echo "FROM $1"
	echo "$2"
}

if [ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ]; then
	usage
fi

IMAGE="$1"
COMMAND="$2"
ARGUMENTS="$3"
BASE="$1"

[ ! -z "$4" ] && BASE="$4"

case "$COMMAND" in
add)
	COMMAND="ADD $ARGUMENTS"
	;;

run)
	COMMAND="RUN $ARGUMENTS"
	;;

cmd)
	COMMAND="CMD $ARGUMENTS"
	;;

*)
	usage
	;;
esac

DOCKERFILE=$(tempfile -d . --p Dock)
	
dockerfile "$BASE" "$COMMAND" | tee "$DOCKERFILE"
docker build -t "$IMAGE" -f "$DOCKERFILE" .
rm "$DOCKERFILE"

echo ""
docker history "$IMAGE"
