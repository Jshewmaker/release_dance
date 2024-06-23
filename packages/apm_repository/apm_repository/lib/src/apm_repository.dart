// Copyright (c) 2024, Very Good Ventures
// https://verygood.ventures

/// {@template apm_repository}
/// Repository which manages the application performance monitoring.
/// {@endtemplate}
abstract class ApmRepository {
  /// {@macro apm_repository}
  const ApmRepository();

  /// Captures an [error] and reports it to the application performance
  /// monitoring service.
  void capture(Object error, StackTrace stackTrace);
}
