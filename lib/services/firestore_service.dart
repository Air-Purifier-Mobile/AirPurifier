import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FirestoreService {
  final CollectionReference _userCollection =
      FirebaseFirestore.instance.collection('Devices');
  final CollectionReference _responseCollection =
      FirebaseFirestore.instance.collection('Responses');
  Future<void> storeUserData({@required String uid, @required mac}) async {
    await _userCollection.doc(uid).set({"MAC": mac});
  }

  Future<void> storeResponses({@required String uid, @required mac}) async {
    await _responseCollection.doc(uid).set({"Response": mac});
  }

  Future<DocumentSnapshot> retrieveUserDocument(String uid) async {
    return await _userCollection.doc(uid).get();
  }
}
