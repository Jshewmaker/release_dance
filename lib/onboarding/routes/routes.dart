// Copyright (c) 2024, Very Good Ventures
// https://verygood.ventures

import 'package:flutter/widgets.dart';
import 'package:release_dance/onboarding/onboarding.dart';

List<Page<dynamic>> onGenerateOnboardingPages(
  OnboardingState state,
  List<Page<dynamic>> pages,
) {
  switch (state) {
    case OnboardingState.featuresComplete:
      return [
        OnboardingWelcome.page(),
        OnboardingFeatures.page(),
        OnboardingSummary.page(),
      ];
    case OnboardingState.welcomeComplete:
      return [
        OnboardingWelcome.page(),
        OnboardingFeatures.page(),
      ];
    case OnboardingState.initial:
      return [OnboardingWelcome.page()];
  }
}
