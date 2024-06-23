// Copyright (c) 2024, Very Good Ventures
// https://verygood.ventures

import 'package:apm_repository/apm_repository.dart';
import 'package:meta/meta.dart';

/// {@template fake_apm_repository}
/// A fake implementation of [ApmRepository].
/// {@endtemplate}
class FakeApmRepository extends ApmRepository {
  /// {@macro fake_apm_repository}
  const FakeApmRepository();

  @override
  void capture(
    Object error,
    StackTrace stackTrace, {
    @visibleForTesting void Function(Object?) printOverride = print,
  }) {
    printOverride(
      '''[$FakeApmRepository.capture] Called with error "$error" and stack trace "$stackTrace".''',
    );
  }
}
