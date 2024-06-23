// Copyright (c) 2024, Very Good Ventures
// https://verygood.ventures

// ignore_for_file: prefer_const_constructors

import 'package:app_support_repository/app_support_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:release_dance/app_store_review/app_store_review.dart';

class _MockAppSupportRepository extends Mock implements AppSupportRepository {}

void main() {
  late AppSupportRepository appSupportRepository;

  setUp(() => appSupportRepository = _MockAppSupportRepository());

  group('AppStoreReviewBloc', () {
    test('initial state is AppStoreReviewState.initial', () {
      expect(
        AppStoreReviewBloc(appSupportRepository).state,
        equals(AppStoreReviewState.initial),
      );
    });

    group('AppStoreReviewRequested', () {
      blocTest<AppStoreReviewBloc, AppStoreReviewState>(
        'emits [availabilityCheckInProgress, unavailable] '
        'when reviews are not available',
        setUp: () {
          when(() => appSupportRepository.requestAppStoreReview()).thenThrow(
            AppStoreReviewNotAvailable(Exception()),
          );
        },
        build: () => AppStoreReviewBloc(appSupportRepository),
        act: (bloc) => bloc.add(AppStoreReviewRequested()),
        expect: () => [
          AppStoreReviewState.availabilityCheckInProgress,
          AppStoreReviewState.unavailable,
        ],
        errors: () => [isA<AppStoreReviewNotAvailable>()],
      );

      blocTest<AppStoreReviewBloc, AppStoreReviewState>(
        'emits [availabilityCheckInProgress, success] '
        'when reviews are available',
        setUp: () {
          when(
            () => appSupportRepository.requestAppStoreReview(),
          ).thenAnswer((_) async {});
        },
        build: () => AppStoreReviewBloc(appSupportRepository),
        act: (bloc) => bloc.add(AppStoreReviewRequested()),
        expect: () => [
          AppStoreReviewState.availabilityCheckInProgress,
          AppStoreReviewState.success,
        ],
      );
    });
  });
}
