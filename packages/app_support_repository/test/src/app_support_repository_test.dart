// Copyright (c) 2024, Very Good Ventures
// https://verygood.ventures

// ignore_for_file: prefer_const_constructors
import 'package:app_support_repository/app_support_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:mocktail/mocktail.dart';

class _MockInAppReview extends Mock implements InAppReview {}

void main() {
  late InAppReview inAppReview;
  late AppSupportRepository appSupportRepository;

  setUp(() {
    inAppReview = _MockInAppReview();
    appSupportRepository = AppSupportRepository(inAppReview: inAppReview);
  });

  group('AppSupportRepository', () {
    test('can be instantiated', () {
      expect(AppSupportRepository(), isNotNull);
    });

    group('requestAppStoreReview', () {
      test('completes normally when in app review is available', () {
        when(() => inAppReview.isAvailable()).thenAnswer((_) async => true);
        when(() => inAppReview.requestReview()).thenAnswer((_) async {});

        expect(appSupportRepository.requestAppStoreReview(), completes);
      });

      test(
        'throws AppStoreReviewNotAvailable when in app review is not available',
        () {
          when(() => inAppReview.isAvailable()).thenAnswer((_) async => false);

          expect(
            appSupportRepository.requestAppStoreReview(),
            throwsA(isA<AppStoreReviewNotAvailable>()),
          );

          verify(() => inAppReview.isAvailable()).called(1);
          verifyNever(() => inAppReview.requestReview());
        },
      );

      test(
        'throws AppStoreReviewFailure when in app review request fails',
        () {
          when(() => inAppReview.isAvailable()).thenAnswer((_) async => true);
          when(() => inAppReview.requestReview()).thenThrow(Exception());

          expect(
            appSupportRepository.requestAppStoreReview(),
            throwsA(isA<AppStoreReviewFailure>()),
          );
        },
      );
    });
  });
}
