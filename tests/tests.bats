#!/usr/bin/env bats

load '../node_modules/bats-support/load'
load '../node_modules/bats-assert/load'

# Load the script containing do_something_quick and parse_quick_parameters
setup() {
    source ./example.sh
}

@test "Parse parameters: --name name --run --file file" {
    run do_something_quick --name name --run --file file

    # Check that the output matches the expected results
    [ "$status" -eq 0 ]
    assert_line "my file is: file"
    assert_line "my name is: name"
    assert_line "run is: true"
}

@test "Parse parameters with positional arguments: file name --run" {
    run do_something_quick file name --run

    # Check that the output matches the expected results
    [ "$status" -eq 0 ]
    assert_line "my file is: file"
    assert_line "my name is: name"
    assert_line "run is: true"
}

@test "Help flag (-h|--help)" {
    run do_something_quick --help

    # Check that the output contains help text
    [ "$status" -eq 0 ]
    assert_line "Parameters:"
    assert_line "  -f|--file <arg> - Sets the variable 'my_file'"
    assert_line "  -r|--run <arg> - Sets the variable 'bool:run'"
    assert_line "  -n|--name <arg> - Sets the variable 'name'"
}

@test "Boolean flag sets true without argument" {
    run do_something_quick --run

    # Check that 'run' is set to true
    [ "$status" -eq 0 ]
    assert_line "run is: true"
}

# Teardown if needed (optional)
teardown() {
    # Clean up or reset any modifications
    true
}
