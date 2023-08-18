import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MessListPage extends StatefulWidget {
  const MessListPage({Key? key}) : super(key: key);

  @override
  _MessListPageState createState() => _MessListPageState();
}

class _MessListPageState extends State<MessListPage> {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  String searchTitle = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search'),
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(10.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search by Name',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  searchTitle = value.toLowerCase().trim();
                });
              },
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: searchTitle.isEmpty
                  ? FirebaseFirestore.instance.collection('Jobs').snapshots()
                  : FirebaseFirestore.instance
                      .collection('Jobs')
                      .where('Category', whereIn: ['Mess,', 'Hostel'])
                      .where('MessTitle', isGreaterThanOrEqualTo: searchTitle)
                      .where('MessTitle', isLessThan: searchTitle + 'z')
                      .snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }

                if (snapshot.data == null || snapshot.data!.docs.length == 0) {
                  return Text('No Mess found!');
                }

                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (BuildContext context, int index) {
                    final doc = snapshot.data!.docs[index];
                    return ListTile(
                      title: Text(doc['MessTitle']),
                      // subtitle: Text(doc['Mess Discription']),
                      onTap: () {
                        // Navigate to mess details page
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
