import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:release_dance/checkout/checkout.dart';

List<Page<dynamic>> onGenerateCheckoutPages(
  CheckoutFlow state,
  List<Page<dynamic>> pages,
  int duration,
) {
  return [
    if (state.status == FlowStatus.selectPackage)
      CheckoutPackageSelectionView.page(duration),
    if (state.status == FlowStatus.checkout) ConfirmCheckoutView.page(),
  ];
}
