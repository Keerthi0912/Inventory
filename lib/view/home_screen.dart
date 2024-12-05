import 'package:flutter/material.dart';
import 'package:lesson6/controller/auth_controller.dart';
import 'package:lesson6/controller/home_controller.dart';
import 'package:lesson6/model/home_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return HomeState();
  }
}

class HomeState extends State<HomeScreen> {
  late HomeController con;
  late HomeModel model;

  @override
  void initState() {
    super.initState();
    con = HomeController(this, updateState);
    model = HomeModel(currentUser!);
    con.getFireBaseData(); // Fetch the inventory list once
  }

  void updateState() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Inventory'),
      ),
      body: model.inventoryList.isEmpty
          ? const Center(child: Text('No inventory items found.'))
          : ListView.separated(
              padding: const EdgeInsets.all(20),
              itemBuilder: (context, index) {
                final item = model.inventoryList[index];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onLongPress: () {
                        setState(() {
                          model.showButton = true;
                          model.index = index;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        color: model.showButton && (model.index == index)
                            ? Colors.transparent
                            : const Color(0xffaad481),
                        child: Row(
                          children: [
                            Text(
                              '${item.name} (qty: ${item.quantity})',
                              style: TextStyle(
                                color:
                                    model.showButton && (model.index == index)
                                        ? const Color(0xff005790)
                                        : Colors.black,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (model.showButton && (model.index == index))
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Row(
                                children: [
                                  InkWell(
                                    onTap: () => con.decrementQuantity(index),
                                    child: const Icon(
                                      // Icons.minimize_sharp,
                                      Icons.remove,
                                     color: Colors.red,
                                    ),
                                    ),
                                  
                                  const SizedBox(width: 10),
                                  Text(item.tempQuantity.toString()),
                                  const SizedBox(width: 10),
                                  InkWell(
                                    onTap: () => con.incrementQuantity(index),
                                    child: const Icon(
                                      Icons.add,
                                      color: Color(0xff005790),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  InkWell(
                                      onTap: () => con.updateQuantity(
                                          index,
                                          item.tempQuantity!,
                                          item.id!,
                                          context),
                                      child: const Icon(Icons.check,
                                          color: Color(0xff005790))),
                                  const SizedBox(width: 20),
                                  InkWell(
                                    onTap: con.onCancel,
                                    child: const Icon(Icons.close,
                                        color: Color(0xff005790)),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                  ],
                );
              },
              separatorBuilder: (context, index) => const SizedBox(height: 30),
              itemCount: model.inventoryList.length,
            ),
      drawer: drawerView(context),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return StatefulBuilder(
                builder: (context, setState) {
                  bool isTyping = false; // Track if the user is typing

                  return AlertDialog(
                    title: const Text('Add a new item'),
                    content: Form(
                      key: model.formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextFormField(
                            controller: model.tfName,
                            decoration: InputDecoration(
                              //labelText: isTyping ? null : 'Name',
                              hintText: isTyping
                                  ? ''
                                  : 'Name', // Hide "Name" when typing
                              errorText: model
                                  .nameErrorText, // Dynamically show the error message
                              errorStyle: const TextStyle(
                                  color: Colors.red), // Error text in red
                              focusedBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors
                                        .black), // Always black underline when focused
                              ),
                              enabledBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors
                                        .black), // Black underline when not focused
                              ),
                              errorBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors
                                        .black), // Black underline when error occurs
                              ),
                            ),
                            onChanged: (value) {
                              setState(() {
                                isTyping =
                                    value.isNotEmpty; // Update typing state
                                if (value.trim().length >= 2) {
                                  model.nameErrorText =
                                      null; // Clear error dynamically
                                }
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    actions: [
                      ElevatedButton(
                        onPressed: () {
                          if (model.tfName.text.trim().isEmpty ||
                              model.tfName.text.trim().length < 2) {
                            setState(() {
                              model.nameErrorText =
                                  'Name too short'; // Show error message
                            });
                            return;
                          }
                          con.onAddData(
                              context); // Call the controller logic to add data
                        },
                        child: const Text('Create'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          model.tfName.text = '';
                          model.nameErrorText = null; // Reset error
                          Navigator.pop(context);
                        },
                        child: const Text('Cancel'),
                      ),
                    ],
                  );
                },
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget drawerView(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            accountName: const Text('No profile'),
            accountEmail: Text(model.user.email!),
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Sign Out'),
            onTap: con.signOut,
          ),
        ],
      ),
    );
  }
}
