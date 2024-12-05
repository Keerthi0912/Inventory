//import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class InventoryModel {
  String? id; // Add the id field
  String? name;
  String? addedBy;
  int? quantity;
  int? tempQuantity;

  InventoryModel({
    this.id,
    this.name,
    this.quantity,
    this.addedBy,
    this.tempQuantity,
  });

  factory InventoryModel.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
       SnapshotOptions? options,
      ) {
    final data = snapshot.data();
    return InventoryModel(
      id: snapshot.id, // Assign the document ID
      name: data?['name'],
      addedBy: data?['createdBy'],
      quantity: data?['quantity'],
      tempQuantity: data?['quantity'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (name != null) "name": name,
      if (quantity != null) "quantity": quantity,
      if (addedBy != null) "createdBy": addedBy,
    };
  }
}
