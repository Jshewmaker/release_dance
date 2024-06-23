// Copyright (c) 2024, Very Good Ventures
// https://verygood.ventures

import 'package:apm_repository/src/apm_repository.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeApmRepository extends ApmRepository {
  @override
  void capture(Object error, StackTrace stackTrace) {}
}

void main() {
  group('$ApmRepository', () {
    test('can be instantiated', () {
      expect(_FakeApmRepository.new, returnsNormally);
    });
  });
}
