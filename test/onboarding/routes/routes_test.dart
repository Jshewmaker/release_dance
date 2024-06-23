// Copyright (c) 2024, Very Good Ventures
// https://verygood.ventures

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:release_dance/onboarding/onboarding.dart';

void main() {
  group('onGenerateOnboardingPages', () {
    test('returns [OnboardingWelcome] when initial', () {
      expect(
        onGenerateOnboardingPages(OnboardingState.initial, []),
        [
          isA<MaterialPage<void>>().having(
            (p) => p.child,
            'child',
            isA<OnboardingWelcome>(),
          ),
        ],
      );
    });

    test(
        'returns [OnboardingWelcome, OnboardingFeatures] '
        'when welcomeComplete', () {
      expect(
        onGenerateOnboardingPages(OnboardingState.welcomeComplete, []),
        [
          isA<MaterialPage<void>>().having(
            (p) => p.child,
            'child',
            isA<OnboardingWelcome>(),
          ),
          isA<MaterialPage<void>>().having(
            (p) => p.child,
            'child',
            isA<OnboardingFeatures>(),
          ),
        ],
      );
    });

    test(
        'returns [OnboardingWelcome, OnboardingFeatures, OnboardingSummary] '
        'when featuresComplete', () {
      expect(
        onGenerateOnboardingPages(OnboardingState.featuresComplete, []),
        [
          isA<MaterialPage<void>>().having(
            (p) => p.child,
            'child',
            isA<OnboardingWelcome>(),
          ),
          isA<MaterialPage<void>>().having(
            (p) => p.child,
            'child',
            isA<OnboardingFeatures>(),
          ),
          isA<MaterialPage<void>>().having(
            (p) => p.child,
            'child',
            isA<OnboardingSummary>(),
          ),
        ],
      );
    });
  });
}
