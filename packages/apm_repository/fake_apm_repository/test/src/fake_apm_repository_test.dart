// Copyright (c) 2024, Very Good Ventures
// https://verygood.ventures

// ignore_for_file: prefer_const_constructors
import 'package:fake_apm_repository/src/fake_apm_repository.dart';
import 'package:test/test.dart';

void main() {
  group('$FakeApmRepository', () {
    test('can be instantiated', () {
      expect(FakeApmRepository(), isNotNull);
    });

    test('track', () {
      final repository = FakeApmRepository();

      const error = 'error';
      final stackTrace = StackTrace.current;

      final printLogs = <Object?>[];
      repository.capture(error, stackTrace, printOverride: printLogs.add);

      final expectedMessage =
          '''[FakeApmRepository.capture] Called with error "$error" and stack trace "$stackTrace".''';

      expect(
        printLogs,
        containsOnce(expectedMessage),
        reason: 'Capture should print a single call report of the event.',
      );
    });
  });
}
