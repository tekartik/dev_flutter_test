#!/usr/bin/env bash

# Fast fail the script on failures.
# and print line as they are read
set -ev

flutter packages get
dart 'tool/test_flutter.dart';
