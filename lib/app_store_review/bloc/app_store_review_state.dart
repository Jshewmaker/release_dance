// Copyright (c) 2024, Very Good Ventures
// https://verygood.ventures

part of 'app_store_review_bloc.dart';

enum AppStoreReviewState {
  initial,
  availabilityCheckInProgress,
  success,
  unavailable,
}

extension AppStoreReviewStateX on AppStoreReviewState {
  bool get isUnavailable => this == AppStoreReviewState.unavailable;
}
