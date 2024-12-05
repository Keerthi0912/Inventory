//import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lesson6/model/inventory_model.dart';


class HomeModel {
  String? nameErrorText;
  int? originalQuantity;
  User user;
  int quantity=1;
  final formKey = GlobalKey<FormState>();
  List<InventoryModel> inventoryList=[];
  Color containerColor = const Color(0xffaad481);
  Color textColor = Colors.black;
  TextEditingController tfName=TextEditingController();
  bool showButton = false;
  int index = 0;
  CollectionReference inventoryCollection =
      FirebaseFirestore.instance.collection('inventory');
  final ref = FirebaseFirestore.instance.collection('inventory').withConverter(
        fromFirestore: InventoryModel.fromFirestore,
        toFirestore: (InventoryModel city, _) => city.toFirestore(),
      );




  HomeModel(this.user);
}
