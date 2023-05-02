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
  TextEditingController placeImageUrlFieldController = TextEditingController();
  TextEditingController placeAddressFieldController = TextEditingController();
  TextEditingController placeNumberFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
              icon: Icon(Icons.add))
        ],
      ),
      body: StreamBuilder(
          stream: clients.snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (ctx, index) {
                    final data = snapshot.data!.docs[index];

                    return Padding(
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
                              SizedBox(
                                width: 75,
                                height: 75,
                                child: ClipOval(child: Image.network(data["imageUrl"], fit: BoxFit.fill)),
                              ),
                              const SizedBox(width: 8),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text("Name : ${data["name"]}"),
                                  Text("Address : ${data["addrress"]}"),
                                  Text("Number : ${data["number"]}"),
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
                    );
                  });
            } else {
              return CircularProgressIndicator();
            }
          }),
    );
  }

  deleteContact(String documentId) async {
    await clients.doc(documentId).delete();
  }

  updateContact(QueryDocumentSnapshot<Map<String, dynamic>> data) async {
    placeNameFieldController.text = data["name"];
    placeImageUrlFieldController.text = data["imageUrl"];
    placeAddressFieldController.text = data["addrress"];
    placeNumberFieldController.text = data["number"];

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
                  controller: placeImageUrlFieldController,
                  decoration: const InputDecoration(labelText: "Place Image URL"),
                ),
                TextField(
                  controller: placeAddressFieldController,
                  decoration: const InputDecoration(labelText: "Place Address"),
                ),
                TextField(
                  controller: placeNumberFieldController,
                  decoration: const InputDecoration(labelText: "Place Phone Number"),
                ),
                Container(
                  height: 1,
                  color: Colors.amber,
                ),
                TextButton(
                    onPressed: () async {
                      await clients.doc(data.id).update({
                        "name": placeNameFieldController.text,
                        "addrress": placeAddressFieldController.text,
                        "number": placeNumberFieldController.text,
                        "imageUrl": placeImageUrlFieldController.text,
                      });
                      placeNameFieldController.text = "";
                      placeAddressFieldController.text = "";
                      placeNumberFieldController.text = "";
                      placeImageUrlFieldController.text = "";

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
                  controller: placeImageUrlFieldController,
                  decoration: const InputDecoration(labelText: "Place Image URL"),
                ),
                TextField(
                  controller: placeAddressFieldController,
                  decoration: const InputDecoration(labelText: "Place Address"),
                ),
                TextField(
                  controller: placeNumberFieldController,
                  decoration: const InputDecoration(labelText: "Place Phone Number"),
                ),
                Container(
                  height: 1,
                  color: Colors.amber,
                ),
                TextButton(
                    onPressed: () async {
                      await clients.add({
                        "name": placeNameFieldController.text,
                        "addrress": placeAddressFieldController.text,
                        "number": placeNumberFieldController.text,
                        "imageUrl": placeImageUrlFieldController.text,
                      });
                      placeNameFieldController.text = "";
                      placeAddressFieldController.text = "";
                      placeNumberFieldController.text = "";
                      placeImageUrlFieldController.text = "";

                      Navigator.of(context).pop();
                    },
                    child: const Text("Add New Place"))
              ],
            ),
          );
        });
  }
}
