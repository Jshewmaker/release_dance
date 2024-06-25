// Copyright (c) 2024, Very Good Ventures
// https://verygood.ventures

import 'package:app_support_repository/app_support_repository.dart';
import 'package:connectivity_repository/connectivity_repository.dart';
import 'package:fake_app_config_repository/fake_app_config_repository.dart';
import 'package:firebase_authentication_client/firebase_authentication_client.dart';
import 'package:release_dance/app/app.dart';
import 'package:release_dance/main/bootstrap/bootstrap.dart';
import 'package:user_repository/user_repository.dart';

void main() {
  bootstrap(
    () async {
      final appSupportRepository = AppSupportRepository();
      final connectivityRepository = ConnectivityRepository();
      final authenticationClient = FirebaseAuthenticationClient();
      final userRepository =
          UserRepository(authenticationClient: authenticationClient);
      final appConfigRepository = FakeAppConfigRepository();
      final user = await userRepository.user.first;

      return App(
        appConfigRepository: appConfigRepository,
        appSupportRepository: appSupportRepository,
        userRepository: userRepository,
        connectivityRepository: connectivityRepository,
        user: user,
      );
    },
  );
}
