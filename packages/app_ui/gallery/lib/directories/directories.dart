// Copyright (c) 2024, Very Good Ventures
// https://verygood.ventures

import 'dart:collection';

import 'package:gallery/directories/custom/custom.dart';
import 'package:gallery/directories/gallery/gallery.dart';
import 'package:gallery/directories/material/material.dart';

final directories = UnmodifiableListView([
  GalleryFolder(),
  MaterialFolder(),
  CustomFolder(),
]);
