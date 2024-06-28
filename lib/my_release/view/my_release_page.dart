import 'package:flutter/material.dart';

class MyReleasePage extends StatelessWidget {
  const MyReleasePage({Key? key});

  factory MyReleasePage.pageBuilder(_, __) {
    return const MyReleasePage(
      key: Key('my_release_page'),
    );
  }

  static String get routeName => '/my_release';

  @override
  Widget build(BuildContext context) {
    return const MyReleaseView();
  }
}

class MyReleaseView extends StatelessWidget {
  const MyReleaseView({Key? key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
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
