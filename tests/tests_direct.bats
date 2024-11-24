#!/usr/bin/env bats

load '../node_modules/bats-support/load'
load '../node_modules/bats-assert/load'

# Load the script containing the parse_quick_parameters function
setup() {
    source ./parse_quick_parameters.sh
}

@test "Parses single parameter with short flag" {
    run bash -c 'parse_quick_parameters "my_file=-f" -f file; echo $my_file'

    # Check the function executes successfully
    [ "$status" -eq 0 ]

    # Check the variable is set correctly
    assert_output "file"
}

@test "Parses multiple parameters with short and long flags" {
    run bash -c 'parse_quick_parameters "file=-f|--file,name=-n|--name" -f myfile --name myname; echo $file $name'

    # Check the function executes successfully
    [ "$status" -eq 0 ]

    # Check the variables are set correctly
    assert_output "myfile myname"
}

@test "Parses boolean parameter with bool flag" {
    run bash -c 'parse_quick_parameters "bool:run=-r|--run" --run; echo $run'

    # Check the function executes successfully
    [ "$status" -eq 0 ]

    # Check that the boolean variable is set to true
    assert_output "true"
}

@test "Sets default for boolean parameter when not passed" {
    run bash -c 'parse_quick_parameters "bool:run=-r|--run"; echo $run'

    # Check the function executes successfully
    [ "$status" -eq 0 ]

    # Check that the boolean variable is set to false
    assert_output "false"
}

@test "Displays help message with -h flag" {
    run bash -c 'parse_quick_parameters "file=-f,bool:run=-r|--run,name=-n|--name" -h'

    # Check the function executes successfully
    [ "$status" -eq 0 ]

    # Verify help message content
    assert_line "Parameters:"
    assert_line "  -f|--file <arg> - Sets the variable 'file'"
    assert_line "  -r|--run <arg> - Sets the variable 'bool:run'"
    assert_line "  -n|--name <arg> - Sets the variable 'name'"
}

@test "Handles missing required arguments gracefully" {
    run bash -c 'parse_quick_parameters "file=-f"'

    # Check that the function does not crash
    [ "$status" -eq 0 ]

    # Check that the variable is not set
    assert_output ""
}


