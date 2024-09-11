import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:notification_repository/notification_repository.dart';

part 'notification_event.dart';
part 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  NotificationBloc({required NotificationRepository notificationRepository})
      : _notificationRepository = notificationRepository,
        super(const NotificationState.initial()) {
    on<_NotificationOpened>(_onNotificationOpened);
    on<_NotificationInForegroundReceived>(_onNotificationInForegroundReceived);
    _notificationRepository.onBackgroundNotification.listen((notification) {
      add(_NotificationOpened(notification: notification));
    });
    _notificationRepository.onForegroundNotification.listen(
      (notification) {
        add(_NotificationOpened(notification: notification));
      },
    );
    _notificationRepository.onBackgroundNotification.listen(
      (notification) {
        add(_NotificationInForegroundReceived(notification: notification));
      },
    );
  }

  final NotificationRepository _notificationRepository;

  void _onNotificationOpened(
    _NotificationOpened event,
    Emitter<NotificationState> emit,
  ) {
    emit(
      state.copyWith(
        notification: event.notification,
        appState: AppState.background,
      ),
    );
  }

  void _onNotificationInForegroundReceived(
    _NotificationInForegroundReceived event,
    Emitter<NotificationState> emit,
  ) {
    emit(
      state.copyWith(
        notification: event.notification,
        appState: AppState.foreground,
      ),
    );
  }
}
