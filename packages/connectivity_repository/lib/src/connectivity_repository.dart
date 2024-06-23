// Copyright (c) 2024, Very Good Ventures
// https://verygood.ventures

import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

/// The application's connectivity status (online or offline).
enum ConnectivityStatus {
  /// Indicates the application has a network connection.
  online,

  /// Indicates the application has no network connection.
  offline
}

/// {@template connectivity_repository}
/// Flutter package which manages the connectivity domain.
/// {@endtemplate}
class ConnectivityRepository {
  /// {@macro connectivity_repository}
  ConnectivityRepository({Connectivity? connectivity})
      : _connectivity = connectivity ?? Connectivity();

  final Connectivity _connectivity;

  /// Fires whenever the connectivity status changes.
  Stream<ConnectivityStatus> get onConnectivityChanged {
    return _connectivity.onConnectivityChanged
        .map(_getStatusFromResult)
        .asBroadcastStream();
  }

  /// Can be used to query the current connectivity status.
  Future<ConnectivityStatus> connectivityStatus() async {
    final connectivityResult = await _connectivity.checkConnectivity();
    return _getStatusFromResult(connectivityResult);
  }

  ConnectivityStatus _getStatusFromResult(List<ConnectivityResult> results) {
    final isOnline = results.any((result) => result.isOnline());
    return isOnline ? ConnectivityStatus.online : ConnectivityStatus.offline;
  }
}

extension on ConnectivityResult {
  /// Determines if the connectivity result is online.
  bool isOnline() {
    switch (this) {
      case ConnectivityResult.wifi:
      case ConnectivityResult.mobile:
      case ConnectivityResult.ethernet:
      case ConnectivityResult.vpn:
        return true;
      case ConnectivityResult.bluetooth:
      case ConnectivityResult.none:
      case ConnectivityResult.other:
        return false;
    }
  }
}
