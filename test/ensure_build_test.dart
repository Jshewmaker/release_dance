// Copyright (c) 2024, Very Good Ventures
// https://verygood.ventures

import 'package:build_verify/build_verify.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'ensure_build',
    tags: 'ensure-build',
    () async {
      await expectBuildClean(
        customCommand: [
          'dart',
          'run',
          'build_runner',
          'build',
          '--delete-conflicting-outputs',
        ],
      );
    },
  );
}
