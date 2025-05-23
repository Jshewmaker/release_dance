// Copyright (c) 2024, Very Good Ventures
// https://verygood.ventures

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:release_dance/firebase_options.dart';

Future<void> bootstrap(
  Future<Widget> Function(FirebaseFirestore firestore) builder,
) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: HydratedStorageDirectory(
      (await getTemporaryDirectory()).path,
    ),
  );

  // Bloc.observer = AppBlocObserver(
  //   analyticsRepository: analyticsRepository,
  // );

  runApp(await builder(FirebaseFirestore.instance));
}
