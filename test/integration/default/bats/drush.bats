#!/usr/bin/env bats

@test "drush binary is found in PATH" {
  run which drush
  [ "$status" -eq 0 ]
}

@test "drush can find @hostmaster" {
  skip
  run sudo -E -u aegir bash -l -c 'drush @hostmaster status'
  [ "$status" -eq 0 ]
}