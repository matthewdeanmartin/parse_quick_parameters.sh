#!/usr/bin/env bash
# shellcheck disable=SC2154

source parse_quick_parameters.sh

function do_something_quick {
	parse_quick_parameters "my_file=-f|--file,bool:run=-r|--run,name=-n|--name" "$@" || return 0

	echo "my file is: $my_file"
	echo "my name is: $name"
	echo "run is: $run"
}

do_something_quick --name name --run --file file
do_something_quick "file" "name" --run
