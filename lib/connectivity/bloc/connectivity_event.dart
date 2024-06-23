// Copyright (c) 2024, Very Good Ventures
// https://verygood.ventures

part of 'connectivity_bloc.dart';

abstract class ConnectivityEvent {
  const ConnectivityEvent();
}

class _ConnectivityChanged extends ConnectivityEvent {
  const _ConnectivityChanged({required this.connectivityState});

  final ConnectivityState connectivityState;
}

class ConnectivityRequested extends ConnectivityEvent {
  const ConnectivityRequested();
}
