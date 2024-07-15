import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:release_dance/checkout/checkout.dart';

List<Page<dynamic>> onGenerateCheckoutPages(
    CheckoutFlow state, List<Page<dynamic>> pages) {
  return [
    if (state.status == FlowStatus.notStarted) CheckoutPageOne.page(1),
    if (state.status == FlowStatus.pageOne) CheckoutPageTwo.page(),
  ];
}
