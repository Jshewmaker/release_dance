// Copyright (c) 2024, Very Good Ventures
// https://verygood.ventures

import 'package:in_app_review/in_app_review.dart';

/// {@template app_store_review_failure}
/// Generic failure thrown while requesting app store review.
/// {@endtemplate}
class AppStoreReviewFailure implements Exception {
  /// {@macro app_store_review_failure}
  const AppStoreReviewFailure(this.error);

  /// The error that was caught.
  final Object error;
}

/// {@template app_store_review_not_available}
/// Thrown if the device is not able to show a review dialog for the app.
/// {@endtemplate}
class AppStoreReviewNotAvailable extends AppStoreReviewFailure {
  /// {@macro app_store_review_not_available}
  AppStoreReviewNotAvailable(super.error);
}

/// {@template app_support_repository}
/// Repository which manages the app support domain.
/// {@endtemplate}
class AppSupportRepository {
  /// {@macro app_support_repository}
  AppSupportRepository({InAppReview? inAppReview})
      : _inAppReview = inAppReview ?? InAppReview.instance;

  final InAppReview _inAppReview;

  /// Checks whether the device can show a review dialog
  /// and shows the dialog to the user.
  Future<void> requestAppStoreReview() async {
    try {
      final canRequestReview = await _inAppReview.isAvailable();
      if (!canRequestReview) {
        throw AppStoreReviewNotAvailable(Exception("Can't request review"));
      }
      await _inAppReview.requestReview();
    } on AppStoreReviewNotAvailable {
      rethrow;
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(AppStoreReviewFailure(error), stackTrace);
    }
  }
}
