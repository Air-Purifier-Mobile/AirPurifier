import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FirestoreService{
  final CollectionReference _userCollection =
  FirebaseFirestore.instance.collection('Devices');

  Future<void> storeUserData({@required String uid, @required mac}) async {
    await _userCollection.doc(uid).set({"MAC" : mac});
  }

  Future<DocumentSnapshot> retrieveUserDocument(String uid) async {
    return await _userCollection.doc(uid).get();
  }
}
