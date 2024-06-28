// ignore_for_file: prefer_const_constructors
import 'package:cloud_firestore_client/cloud_firestore_client.dart';
import 'package:test/test.dart';

void main() {
  group('CloudFirestoreClient', () {
    test('can be instantiated', () {
      expect(CloudFirestoreClient(), isNotNull);
    });
  });
}
