#!/usr/bin/env bats

@test "mysql binary is found in PATH" {
  run which mysql
  [ "$status" -eq 0 ]
}