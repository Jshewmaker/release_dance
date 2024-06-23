// Copyright (c) 2024, Very Good Ventures
// https://verygood.ventures

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:connectivity_repository/connectivity_repository.dart';

part 'connectivity_event.dart';

enum ConnectivityState { online, offline, unknown }

class ConnectivityBloc extends Bloc<ConnectivityEvent, ConnectivityState> {
  ConnectivityBloc({
    required ConnectivityRepository connectivityRepository,
  })  : _connectivityRepository = connectivityRepository,
        super(ConnectivityState.unknown) {
    on<_ConnectivityChanged>((event, emit) => emit(event.connectivityState));
    on<ConnectivityRequested>(_onConnectivityRequested);
    _connectivityChangedSubscription = _connectivityRepository
        .onConnectivityChanged
        .listen(_connectivityChanged);
  }

  final ConnectivityRepository _connectivityRepository;
  late StreamSubscription<ConnectivityStatus> _connectivityChangedSubscription;

  void _connectivityChanged(ConnectivityStatus connectivityStatus) {
    add(
      _ConnectivityChanged(
        connectivityState: connectivityStatus.toConnectivityState(),
      ),
    );
  }

  Future<void> _onConnectivityRequested(
    ConnectivityRequested event,
    Emitter<ConnectivityState> emit,
  ) async {
    try {
      final status = await _connectivityRepository.connectivityStatus();
      emit(status.toConnectivityState());
    } catch (error, stackTrace) {
      emit(ConnectivityState.unknown);
      addError(error, stackTrace);
    }
  }

  @override
  Future<void> close() {
    _connectivityChangedSubscription.cancel();
    return super.close();
  }
}

extension on ConnectivityStatus {
  ConnectivityState toConnectivityState() {
    switch (this) {
      case ConnectivityStatus.offline:
        return ConnectivityState.offline;
      case ConnectivityStatus.online:
        return ConnectivityState.online;
    }
  }
}
