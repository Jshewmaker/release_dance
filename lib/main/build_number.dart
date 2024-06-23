// Copyright (c) 2024, Very Good Ventures
// https://verygood.ventures

import 'package:release_dance/src/version.dart';

int buildNumber([String version = packageVersion]) {
  final versionSegments = version.split('+');
  if (versionSegments.isEmpty) return 0;
  return int.tryParse(versionSegments.last) ?? 0;
}
