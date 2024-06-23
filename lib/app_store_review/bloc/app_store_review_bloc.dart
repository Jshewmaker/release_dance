// Copyright (c) 2024, Very Good Ventures
// https://verygood.ventures

import 'dart:async';

import 'package:app_support_repository/app_support_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'app_store_review_event.dart';
part 'app_store_review_state.dart';

class AppStoreReviewBloc
    extends Bloc<AppStoreReviewEvent, AppStoreReviewState> {
  AppStoreReviewBloc(AppSupportRepository appSupportRepository)
      : _appSupportRepository = appSupportRepository,
        super(AppStoreReviewState.initial) {
    on<AppStoreReviewRequested>(_onAppStoreReviewRequested);
  }

  final AppSupportRepository _appSupportRepository;

  Future<void> _onAppStoreReviewRequested(
    AppStoreReviewRequested event,
    Emitter<AppStoreReviewState> emit,
  ) async {
    emit(AppStoreReviewState.availabilityCheckInProgress);
    try {
      await _appSupportRepository.requestAppStoreReview();
      emit(AppStoreReviewState.success);
    } catch (error, stackTrace) {
      emit(AppStoreReviewState.unavailable);
      addError(error, stackTrace);
    }
  }
}
