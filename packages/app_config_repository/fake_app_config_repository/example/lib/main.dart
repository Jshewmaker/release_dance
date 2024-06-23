// Copyright (c) 2024, Very Good Ventures
// https://verygood.ventures

// ignore_for_file: avoid_print
import 'package:fake_app_config_repository/fake_app_config_repository.dart';

Future<void> main() async {
  final repository = FakeAppConfigRepository();

  // Listen to isForceUpgradeRequired changes.
  final isForceUpgradeRequiredSubscription =
      repository.isForceUpgradeRequired().listen((forceUpgrade) {
    print('isForceUpgradeRequired: $forceUpgrade');
  });

  // Listen to isDownForMaintenance changes.
  final isDownForMaintenanceStreamSubscription =
      repository.isDownForMaintenance().listen((isDownForMaintenance) {
    print('isDownForMaintenance: $isDownForMaintenance');
  });

  // Change isForceUpgradeRequired and isDownForMaintenance.
  await Future<void>.delayed(const Duration(seconds: 1));
  repository.changeIsForceUpgradeRequired(
    forceUpgrade: const ForceUpgrade(
      isUpgradeRequired: true,
      upgradeUrl: 'url',
    ),
  );

  await Future<void>.delayed(const Duration(seconds: 1));
  repository.changeIsDownForMaintenance(isDownForMaintenance: true);

  await Future<void>.delayed(const Duration(seconds: 1));
  repository.changeIsForceUpgradeRequired(
    forceUpgrade: const ForceUpgrade(isUpgradeRequired: false),
  );

  await Future<void>.delayed(const Duration(seconds: 1));
  repository.changeIsDownForMaintenance(isDownForMaintenance: false);

  // Cancel subscriptions and close the repository.
  await isForceUpgradeRequiredSubscription.cancel();
  await isDownForMaintenanceStreamSubscription.cancel();
  repository.close();
}
