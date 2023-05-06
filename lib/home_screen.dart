import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final clients = FirebaseFirestore.instance.collection("clients");
  TextEditingController placeNameFieldController = TextEditingController();
  TextEditingController placeNumberFieldController = TextEditingController();
  TextEditingController placeBillAmountFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: clients.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            double totalAmount = 0;
            var myList = snapshot.data!.docs;
            myList.sort((a, b) => a["name"].compareTo(b["name"]));

            return Scaffold(
              appBar: AppBar(
                title: const Text(
                  "Yellow Paper",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                actions: [
                  IconButton(
                      onPressed: () {
                        addNewPlace();
                      },
                      icon: const Icon(Icons.add))
                ],
              ),
              body: ListView.builder(
                  itemCount: myList.length + 1,
                  itemBuilder: (ctx, index) {
                    if (index == myList.length) {
                      return Container(
                        height: 100,
                        child: Center(child: Text("Total Amount : $totalAmount ")),
                      );
                    } else {
                      final data = myList[index];

                      if (data["amount"] != "") {
                        totalAmount = totalAmount + double.parse(data["amount"]);
                      }

                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              height: 100,
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 5,
                                    blurRadius: 7,
                                    offset: const Offset(0, 3), // changes position of shadow
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    const Icon(Icons.note),
                                    const SizedBox(width: 8),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Text("Name : ${data["name"]}"),
                                        Text("Number : ${data["number"]}"),
                                        Text("Amount : ${data["amount"]}"),
                                      ],
                                    ),
                                    Expanded(child: Container()),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        InkWell(
                                            onTap: () {
                                              updateContact(data);
                                            },
                                            child: Icon(Icons.edit)),
                                        InkWell(
                                            onTap: () {
                                              deleteContact(data.id);
                                            },
                                            child: Icon(Icons.delete)),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    }
                  }),
            );
          } else {
            return CircularProgressIndicator();
          }
        });
  }

  deleteContact(String documentId) {
    clients.doc(documentId).delete();
  }

  updateContact(QueryDocumentSnapshot<Map<String, dynamic>> data) async {
    placeNameFieldController.text = data["name"];
    placeNumberFieldController.text = data["number"];
    placeBillAmountFieldController.text = data["amount"];

    await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (ctx) {
          return Padding(
            padding:
                EdgeInsets.only(top: 20, right: 20, left: 20, bottom: MediaQuery.of(context).viewInsets.bottom + 20),
            child: Column(
              children: [
                TextField(
                  controller: placeNameFieldController,
                  decoration: const InputDecoration(labelText: "Place Name"),
                ),
                TextField(
                  controller: placeNumberFieldController,
                  decoration: const InputDecoration(labelText: "Place Phone Number"),
                ),
                TextField(
                  controller: placeBillAmountFieldController,
                  decoration: const InputDecoration(labelText: "Place Amount"),
                ),
                Container(
                  height: 1,
                  color: Colors.amber,
                ),
                TextButton(
                    onPressed: () async {
                      await clients.doc(data.id).update({
                        "name": placeNameFieldController.text,
                        "number": placeNumberFieldController.text,
                        "amount": placeBillAmountFieldController.text,
                      });
                      placeNameFieldController.text = "";
                      placeNumberFieldController.text = "";
                      placeBillAmountFieldController.text = "";

                      Navigator.of(context).pop();
                    },
                    child: const Text("Update Place"))
              ],
            ),
          );
        });
  }

  addNewPlace() async {
    await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (ctx) {
          return Padding(
            padding:
                EdgeInsets.only(top: 20, right: 20, left: 20, bottom: MediaQuery.of(context).viewInsets.bottom + 20),
            child: Column(
              children: [
                TextField(
                  controller: placeNameFieldController,
                  decoration: const InputDecoration(labelText: "Place Name"),
                ),
                TextField(
                  controller: placeNumberFieldController,
                  decoration: const InputDecoration(labelText: "Place Phone Number"),
                ),
                TextField(
                  controller: placeBillAmountFieldController,
                  decoration: const InputDecoration(labelText: "Place Amount"),
                ),
                Container(
                  height: 1,
                  color: Colors.amber,
                ),
                TextButton(
                    onPressed: () async {
                      if (placeNameFieldController.text.isNotEmpty &&
                          placeNumberFieldController.text.isNotEmpty &&
                          placeBillAmountFieldController.text.isNotEmpty) {
                        await clients.add({
                          "name": placeNameFieldController.text,
                          "number": placeNumberFieldController.text,
                          "amount": placeBillAmountFieldController.text,
                        });
                        placeNameFieldController.text = "";
                        placeNumberFieldController.text = "";
                        placeBillAmountFieldController.text = "";

                        Navigator.of(context).pop();
                      } else {
                        print("some of the field is empty");
                      }
                    },
                    child: const Text("Add New Place"))
              ],
            ),
          );
        });
  }
}
