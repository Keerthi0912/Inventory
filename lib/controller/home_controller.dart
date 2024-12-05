//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lesson6/controller/auth_controller.dart';
import 'package:lesson6/model/inventory_model.dart';
import 'package:lesson6/view/home_screen.dart';
import 'package:lesson6/view/show_snackbar.dart';

class HomeController {
  HomeState state;
  VoidCallback updateState;

  HomeController(this.state, this.updateState);

  Future<void> signOut() async {
    await firebaseSignOut();
  }

  void incrementQuantity(int index) {
    final newQuantity = state.model.inventoryList[index].tempQuantity! + 1;
    state.model.inventoryList[index].tempQuantity = newQuantity;
    updateState();
  }

  void decrementQuantity(int index) {
    if (state.model.inventoryList[index].tempQuantity! > 0) {
      final newQuantity = state.model.inventoryList[index].tempQuantity! - 1;
      state.model.inventoryList[index].tempQuantity = newQuantity;
      updateState();
    }
  }

  void onAddData(BuildContext context) async {
    //if(!state.model.formKey.currentState!.validate()){
     // return;
    //}

    if (state.model.tfName.text.trim().isEmpty || state.model.tfName.text.trim().length < 2) {
    state.model.nameErrorText = 'Name too short'; // Set error message
    updateState(); // Update the UI
    return;
    }
     //if ( state.model.tfName.text.toLowerCase()== null || state.model.tfName.text.toLowerCase().trim().length < 2) {
      //showSnackbar(context: context,message:'Name must be at least 2 characters long');
     //return;
      //}
    if (state.model.inventoryList
        .any((element) => element.name == state.model.tfName.text.toLowerCase().trim())) {
    showSnackbar(message:'${state.model.tfName.text} already exists',context:context);
    return;
    }

    Navigator.pop(context);
    final inventory = InventoryModel(
      name: state.model.tfName.text.toLowerCase(),
      quantity: 1,
      addedBy: state.model.user.email,
    );

    int time =await DateTime.now().microsecondsSinceEpoch;
    final docRef = state.model.ref.doc(time.toString());
    await docRef.set(inventory);
     getFireBaseData();
    state.model.tfName.text = '';

  }

  void onLongPress(int cIndex) {
    state.model.containerColor = Colors.transparent;
    state.model.textColor = const Color(0xff005790);
    state.model.showButton = true;
    state.model.index = cIndex;
    updateState();
  }

  void onCancel() {
     for (var item in state.model.inventoryList) {
    // Reset tempQuantity to the original quantity stored in 'quantity'
    item.tempQuantity = item.quantity;
  }
    state.model.containerColor = const Color(0xffaad481);
    state.model.textColor = Colors.black;
    state.model.showButton = false;
    updateState();
  }

  Future<void> updateQuantity(int index, int newQuantity, String id,BuildContext context) async {
    final docId = id;
    onCancel();
    try {
      if (newQuantity == 0) {
        await state.model.ref.doc(docId).delete();
      }

      else {
        await state.model.ref.doc(docId).update({'quantity': newQuantity});
      }

      getFireBaseData();

    } catch (e) {
      showSnackbar( message: 'Error updating quantity: $e',context: context);

    }
  }

  void getFireBaseData() async {
    final querySnapshot = await state.model.ref
        .where('createdBy', isEqualTo: state.model.user.email)
        .orderBy('name', descending: false)
        .get();

    state.model.inventoryList =
        querySnapshot.docs.map((doc) => doc.data()).toList();

    updateState();

    print('${state.model.inventoryList[0].id}');
  }
}
