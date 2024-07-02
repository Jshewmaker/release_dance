import 'package:flutter/material.dart';

class MyReleasePage extends StatelessWidget {
  const MyReleasePage({super.key});

  factory MyReleasePage.pageBuilder(_, __) {
    return const MyReleasePage();
  }

  static String get routeName => '/my_release';

  @override
  Widget build(BuildContext context) {
    return const MyReleaseView();
  }
}

class MyReleaseView extends StatelessWidget {
  const MyReleaseView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Release',
        ),
      ),
      body: Center(
        child: Text(
          'You',
          style: theme.textTheme.bodyLarge,
        ),
      ),
    );
  }
}
