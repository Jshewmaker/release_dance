import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';

/// {@template notification_repository}
/// Package to handle push notifications from Firebase Messaging
/// {@endtemplate}
class NotificationRepository {
  /// {@macro notification_repository}
  NotificationRepository({
    required FirebaseMessaging firebaseMessaging,
    required Stream<RemoteMessage> foregroundRemoteNotifications,
    required Stream<RemoteMessage> backgroundRemoteNotificationsOpened,
  })  : _firebaseMessaging = firebaseMessaging,
        _foregroundRemoteNotifications = foregroundRemoteNotifications,
        _backgroundRemoteNotificationsOpened =
            backgroundRemoteNotificationsOpened,
        _openedNotificationsController =
            BehaviorSubject<Map<String, dynamic>>();

  final FirebaseMessaging _firebaseMessaging;
  final Stream<RemoteMessage> _foregroundRemoteNotifications;
  final BehaviorSubject<Map<String, dynamic>> _openedNotificationsController;
  final Stream<RemoteMessage> _backgroundRemoteNotificationsOpened;

  /// Stream of local/remote notifications that were opened either when the app
  /// was in the foreground or when the app was in the background.
  Stream<Map<String, dynamic>> get openedNotifications =>
      _openedNotificationsController.stream;

  Stream<RemoteMessage> get onForegroundNotification {
    return _foregroundRemoteNotifications.map((message) {
      final notification = message.notification;
      return RemoteMessage(
        notification: notification,
        data: message.data,
      );
    });
  }

  Future<void> initialize() async {
    final response = await _firebaseMessaging.requestPermission();
    final status = response.authorizationStatus;

    if (status == AuthorizationStatus.authorized) {
      print('User granted permission');
      await getToken();
    } else if (status == AuthorizationStatus.notDetermined) {
      print('User status is not determined');
    } else {
      print('User declined or has not accepted permission: $status');
    }

    await _initializeBackgroundNotifications();
  }

  Future<void> _initializeBackgroundNotifications() async {
    /// Subscribe to a stream of remote notifications opened from a background
    /// state (not terminated) and pass them to the openedRemoteNotifications
    /// stream.
    _backgroundRemoteNotificationsOpened
        .map((notification) => notification.data)
        .listen(_openedNotificationsController.add);

    /// If the app was open with a remote push notification
    /// and it contains a payload
    /// then we need to emit the payload to the openedNotifications stream.
    _firebaseMessaging
        .getInitialMessage()
        .asStream()
        .map((notification) => notification?.data)
        .whereType<Map<String, dynamic>>()
        .listen(_openedNotificationsController.add);
  }

  Future<void> getToken() async {
    final token = await _firebaseMessaging.getToken();
    if (kDebugMode) {
      print('Registration Token=$token');
    }
  }
}
