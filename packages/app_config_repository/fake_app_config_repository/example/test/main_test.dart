// Copyright (c) 2024, Very Good Ventures
// https://verygood.ventures

import 'package:fake_app_config_repository_example/main.dart' as example;
import 'package:test/test.dart';

void main() {
  test(
    'example returns normally',
    timeout: const Timeout(Duration(seconds: 5)),
    () async {
      expect(example.main, returnsNormally);
    },
  );
}
