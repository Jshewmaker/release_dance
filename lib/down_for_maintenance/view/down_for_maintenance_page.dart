// Copyright (c) 2024, Very Good Ventures
// https://verygood.ventures

import 'package:flutter/material.dart';
import 'package:release_dance/down_for_maintenance/down_for_maintenance.dart';

class DownForMaintenancePage extends StatelessWidget {
  const DownForMaintenancePage({super.key});

  factory DownForMaintenancePage.pageBuilder(_, __) {
    return const DownForMaintenancePage(
      key: Key('downForMaintenance_page'),
    );
  }

  static const routeName = '/down-for-maintenance';

  @override
  Widget build(BuildContext context) {
    return const DownForMaintenanceView();
  }
}
