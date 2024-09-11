part of 'notification_bloc.dart';

enum AppState {
  background,
  foreground;

  bool get isBackground => this == AppState.background;
  bool get isForeground => this == AppState.foreground;
}

class NotificationState extends Equatable {
  const NotificationState({
    this.notification,
    this.appState,
  });

  const NotificationState.initial() : this();

  final RemoteMessage? notification;
  final AppState? appState;

  @override
  List<Object?> get props => [notification, appState];

  NotificationState copyWith({
    RemoteMessage? notification,
    AppState? appState,
  }) {
    return NotificationState(
      notification: notification ?? this.notification,
      appState: appState ?? this.appState,
    );
  }
}
