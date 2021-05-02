import 'dart:convert';

import 'package:air_purifier/services/streaming_shared_preferences_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FirestoreService {
  final CollectionReference _userCollection =
      FirebaseFirestore.instance.collection('Devices');
  final CollectionReference _responseCollection = FirebaseFirestore.instance
      .collection(
          'Responses ${FirebaseAuth.instance.currentUser?.uid ?? 'test'}');

  Future<void> storeResponses({@required String uid, @required mac}) async {
    await _responseCollection
        .doc(uid)
        .set({"Response": mac, "Time": DateTime.now()});
  }

  Future<DocumentSnapshot> retrieveUserDocument(String uid) async {
    return await _userCollection.doc(uid).get();
  }

  Future<void> userData(
      String uid, List<String> macId, List<String> deviceName) async {
    await _userCollection.doc(uid).update({
      "MAC": macId,
      "name": deviceName,
    });
  }
}
