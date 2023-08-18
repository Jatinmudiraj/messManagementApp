
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../utils/user.dart';

class MyWidget extends StatefulWidget {
  const MyWidget({Key? key}) : super(key: key);

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  // final String? userName = FirebaseAuth.instance.currentUser?.displayName;
  final String userName = FirebaseAuth.instance.currentUser!.displayName!;

  String checkIn = "--/--";
  String checkOut = "--/--";

  @override
  void initState() {
    super.initState();
    _getRecord();
  }

  void _getRecord() async {
    try {
      QuerySnapshot snap = await FirebaseFirestore.instance
          .collection("Employee")
          .where('username', isEqualTo: userName)
          .get();
      print(snap.docs[0].id);
      DocumentSnapshot snap2 = await FirebaseFirestore.instance
          .collection("Employee")
          .doc(snap.docs[0].id)
          .collection("Record")
          .doc(DateFormat('dd MMMM yyyy').format(DateTime.now()))
          .get();
      setState(() {
        checkIn = snap2["checkIn"];
        checkOut = snap2["checkOut"];
      });
    } catch (e) {
      setState(() {
        checkIn = "--/--";
        checkOut = "--/--";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWeight = MediaQuery.of(context).size.width;
    var snap;
    return Scaffold(
      appBar: AppBar(title: Text('Attendance History')),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(top: 10, bottom: 0, left: 20, right: 20),
        child: Column(children: [
          Container(
            alignment: Alignment.centerLeft,
            child: Text(
              "My Attendance",
              style:
                  TextStyle(color: Colors.black54, fontSize: screenWeight / 15, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 10,),
          Stack(
            children: [
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  DateFormat('MMMM').format(DateTime.now()),
                  style: TextStyle(
                      color: Colors.black54, fontSize: screenWeight / 18,fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                alignment: Alignment.centerRight,
                child: Text(
                  "Pick a Month",
                  style: TextStyle(
                      color: Colors.black54, fontSize: screenWeight / 18,fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.only(bottom: 90,top: 10),
            height: screenHeight - screenWeight / 5,
            child: 
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("Employee")
                  .where('username', isEqualTo: userName)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData) {
                  final snap = snapshot.data!.docs;
                  return ListView.builder(
  itemCount: snap.length,
  itemBuilder: (context, index) {
    final docId = snap[index].id;
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection("Employee")
          .doc(docId)
          .collection("Record")
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
        if (snapshot.hasData) {
          final records = snapshot.data!.docs.map((doc) => doc.data()).toList();

          return ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: records.length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                margin: EdgeInsets.only(top: 2, bottom: 12),
                height: 150,
                decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 10,
                        offset: Offset(2, 2),
                      ),
                    ],
                    borderRadius:
                        BorderRadius.all(Radius.circular(20))),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment:
                                  CrossAxisAlignment.center,
                              children: [
                                Text(
                                  records[index]['date'].toString(),
                                  style: TextStyle(
                                      fontSize: 25,
                                      color: Colors.blue,
                                      fontWeight:
                                          FontWeight.bold),
                                ),
                                SizedBox(height: 10,)
                              ],
                            ),
                          ),
                          Container(
                            height: 80,
                            child: VerticalDivider(
                              color: Colors.grey[400],
                              thickness: 1,
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "Check In",
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.grey[600],
                                      fontWeight:
                                          FontWeight.bold),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  records[index]['checkIn'].toString(),
                                  style: TextStyle(
                                      fontSize: 30,
                                      color: Colors.blue,
                                      fontWeight:
                                          FontWeight.bold),
                                )
                              ],
                            ),
                          ),
                          Container(
                            height: 80,
                            child: VerticalDivider(
                              color: Colors.grey[400],
                              thickness: 1,
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "Check Out",
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.grey[600],
                                      fontWeight:
                                          FontWeight.bold),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  records[index]['checkOut'].toString(),
                                  style: TextStyle(
                                      fontSize: 30,
                                      color: Colors.blue,
                                      fontWeight:
                                          FontWeight.bold),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }
        return SizedBox.shrink();
      },
    );
  },
);
                } else {
                  return const SizedBox();
                }
              },
            ),
          )
        ]),
      ),
    );
  }
}
