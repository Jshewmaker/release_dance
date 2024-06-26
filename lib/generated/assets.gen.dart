/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: directives_ordering,unnecessary_import,implicit_dynamic_list_literal,deprecated_member_use

import 'package:flutter/widgets.dart';

class $AssetsImagesGen {
  const $AssetsImagesGen();

  /// File path: assets/images/dancer-silhouette.png
  AssetGenImage get dancerSilhouette =>
      const AssetGenImage('assets/images/dancer-silhouette.png');

  /// File path: assets/images/onboarding-features.png
  AssetGenImage get onboardingFeatures =>
      const AssetGenImage('assets/images/onboarding-features.png');

  /// File path: assets/images/onboarding-summary.png
  AssetGenImage get onboardingSummary =>
      const AssetGenImage('assets/images/onboarding-summary.png');

  /// File path: assets/images/onboarding-welcome.png
  AssetGenImage get onboardingWelcome =>
      const AssetGenImage('assets/images/onboarding-welcome.png');

  /// File path: assets/images/pride-promo.png
  AssetGenImage get pridePromo =>
      const AssetGenImage('assets/images/pride-promo.png');

  /// File path: assets/images/release-studio.png
  AssetGenImage get releaseStudio =>
      const AssetGenImage('assets/images/release-studio.png');

  /// File path: assets/images/summer-giveaway.png
  AssetGenImage get summerGiveaway =>
      const AssetGenImage('assets/images/summer-giveaway.png');

  /// File path: assets/images/unicorn-vgv-black.png
  AssetGenImage get unicornVgvBlack =>
      const AssetGenImage('assets/images/unicorn-vgv-black.png');

  /// List of all assets
  List<AssetGenImage> get values => [
        dancerSilhouette,
        onboardingFeatures,
        onboardingSummary,
        onboardingWelcome,
        pridePromo,
        releaseStudio,
        summerGiveaway,
        unicornVgvBlack
      ];
}

class Assets {
  Assets._();

  static const $AssetsImagesGen images = $AssetsImagesGen();
}

class AssetGenImage {
  const AssetGenImage(
    this._assetName, {
    this.size,
    this.flavors = const {},
  });

  final String _assetName;

  final Size? size;
  final Set<String> flavors;

  Image image({
    Key? key,
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = false,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.low,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.asset(
      _assetName,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      package: package,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  ImageProvider provider({
    AssetBundle? bundle,
    String? package,
  }) {
    return AssetImage(
      _assetName,
      bundle: bundle,
      package: package,
    );
  }

  String get path => _assetName;

  String get keyName => _assetName;
}
