// Copyright (c) 2024, Very Good Ventures
// https://verygood.ventures

part of 'app_store_review_bloc.dart';

abstract class AppStoreReviewEvent extends Equatable {
  const AppStoreReviewEvent();
}

class AppStoreReviewRequested extends AppStoreReviewEvent {
  const AppStoreReviewRequested();

  @override
  List<Object> get props => [];
}
