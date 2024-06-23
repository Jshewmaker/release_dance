// Copyright (c) 2024, Very Good Ventures
// https://verygood.ventures

// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:release_dance/app_store_review/app_store_review.dart';

void main() {
  group('AppStoreReviewEvent', () {
    group('AppStoreReviewRequested', () {
      test('supports value comparisons', () {
        expect(AppStoreReviewRequested(), AppStoreReviewRequested());
      });
    });
  });
}
