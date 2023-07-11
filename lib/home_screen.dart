import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // kda maskt el table/collection eli esmo "data" fl firestore
  final CollectionReference _data =
      FirebaseFirestore.instance.collection("data");

  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController departmentController = TextEditingController();

  // await _data.add({"name": ddzz, "age":8});
  // await _data.update({"name": ddzz, "age":8});
  // await _data.doc(dataID).delete();

  Future<void> _update([DocumentSnapshot? documentSnapshot]) async {
    if (documentSnapshot != null) {
      nameController.text = documentSnapshot['name'];
      ageController.text = documentSnapshot['age'];
      departmentController.text = documentSnapshot['department'];
    }
    await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return Padding(
            padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                // to prevent the soft keyboard from covering text fields
                bottom: MediaQuery.of(context).viewInsets.bottom + 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
                TextField(
                  controller: ageController,
                  decoration: const InputDecoration(labelText: 'Age'),
                ),
                TextField(
                  controller: departmentController,
                  decoration: const InputDecoration(labelText: 'Department'),
                ),
                const SizedBox(
                  height: 20,
                ),
                OutlinedButton(
                    onPressed: () async {
                      final String name = nameController.text;
                      final String age = ageController.text;
                      final String department = departmentController.text;
                      await _data.doc(documentSnapshot!.id).update(
                          {"name": name, "age": age, "department": department});
                      nameController.text = '';
                      ageController.text = '';
                      departmentController.text = '';
                      Navigator.pop(context);
                    },
                    child: const Text("Update"))
              ],
            ),
          );
        });
  }

  Future<void> _create([DocumentSnapshot? documentSnapshot]) async {
    if (documentSnapshot != null) {
      nameController.text = documentSnapshot['name'];
      ageController.text = documentSnapshot['age'];
      departmentController.text = documentSnapshot['department'];
    }
    await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return Padding(
            padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                // to prevent the soft keyboard from covering text fields
                bottom: MediaQuery.of(context).viewInsets.bottom + 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
                TextField(
                  controller: ageController,
                  decoration: const InputDecoration(labelText: 'Age'),
                ),
                TextField(
                  controller: departmentController,
                  decoration: const InputDecoration(labelText: 'Department'),
                ),
                const SizedBox(
                  height: 20,
                ),
                OutlinedButton(
                    onPressed: () async {
                      final String name = nameController.text;
                      final String age = ageController.text;
                      final String department = departmentController.text;
                      await _data.add(
                          {"name": name, "age": age, "department": department});
                      nameController.text = '';
                      ageController.text = '';
                      departmentController.text = '';
                      Navigator.pop(context);
                    },
                    child: const Text("Add"))
              ],
            ),
          );
        });
  }

  Future<void> _delete(String itemId) async {
    await _data.doc(itemId).delete();

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
      "Item deleted successfully",
      textAlign: TextAlign.center,
    )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        floatingActionButton: FloatingActionButton(
            onPressed: () => _create(), child: const Icon(Icons.add)),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        body: StreamBuilder(
            stream: _data.snapshots(), // build the connection
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      final DocumentSnapshot documentSnapshot =
                          snapshot.data!.docs[index];
                      return Card(
                        margin: const EdgeInsets.all(12),
                        child: ListTile(
                          title: Text(documentSnapshot['name']),
                          subtitle: Text(documentSnapshot['department']),
                          leading: Text(documentSnapshot['age']),
                          trailing: SizedBox(
                            width: 100,
                            child: Row(
                              children: [
                                IconButton(
                                    onPressed: () => _update(documentSnapshot),
                                    icon: const Icon(Icons.edit)),
                                IconButton(
                                    onPressed: () =>
                                        _delete(documentSnapshot.id),
                                    icon: const Icon(Icons.delete)),
                              ],
                            ),
                          ),
                        ),
                      );
                    });
              } else {
                return Container();
              }
            }));
  }
}
