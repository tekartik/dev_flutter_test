#!/usr/bin/env bash

# Fast fail the script on failures.
# and print line as they are read
set -ev

dart 'tool/test_flutter.dart';
