// Copyright (c) 2024, Very Good Ventures
// https://verygood.ventures

import 'package:app_support_repository/app_support_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore_client/cloud_firestore_client.dart';
import 'package:connectivity_repository/connectivity_repository.dart';
import 'package:fake_app_config_repository/fake_app_config_repository.dart';
import 'package:firebase_authentication_client/firebase_authentication_client.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:notification_repository/notification_repository.dart';
import 'package:release_dance/app/app.dart';
import 'package:release_dance/main/bootstrap/bootstrap.dart';
import 'package:release_profile_repository/release_profile_repository.dart';
import 'package:user_repository/user_repository.dart';

void main() {
  bootstrap(
    (FirebaseFirestore firebaseFirestore) async {
      final appSupportRepository = AppSupportRepository();
      final authenticationClient = FirebaseAuthenticationClient();
      final cloudFirestoreClient =
          CloudFirestoreClient(firebaseFirestore: firebaseFirestore);
      final connectivityRepository = ConnectivityRepository();
      final firebaseMessaging = FirebaseMessaging.instance;

      final notificationRepository = NotificationRepository(
        firebaseMessaging: firebaseMessaging,
        foregroundRemoteNotifications: FirebaseMessaging.onMessage,
        backgroundRemoteNotificationsOpened:
            FirebaseMessaging.onMessageOpenedApp,
      );

      await notificationRepository.initialize();

      final userRepository =
          UserRepository(authenticationClient: authenticationClient);
      final user = await userRepository.user.first;

      final releaseUserRepository = ReleaseProfileRepository(
        cloudFirestoreClient: cloudFirestoreClient,
        user: user,
      );
      final appConfigRepository = FakeAppConfigRepository();

      return App(
        appConfigRepository: appConfigRepository,
        appSupportRepository: appSupportRepository,
        userRepository: userRepository,
        releaseProfileRepository: releaseUserRepository,
        connectivityRepository: connectivityRepository,
        cloudFirestoreClient: cloudFirestoreClient,
        notificationRepository: notificationRepository,
        user: user,
      );
    },
  );
}
