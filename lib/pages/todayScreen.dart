import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:slide_to_act/slide_to_act.dart';

// import '../utils/user.dart';

class TodaySceen extends StatefulWidget {
  const TodaySceen({Key? key}) : super(key: key);

  @override
  State<TodaySceen> createState() => _TodaySceenState();
}

class _TodaySceenState extends State<TodaySceen> {
  final String? userName = FirebaseAuth.instance.currentUser?.displayName;
  String checkIn = "--/--";
  String checkOut = "--/--";
  String date = DateFormat('dd MMMM yyyy').format(DateTime.now());
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
        date = snap2["date"];
      });
    } catch (e) {
      setState(() {
        checkIn = "--/--";
        checkOut = "--/--";
        date = DateFormat('dd MMMM yyyy').format(DateTime.now());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWeight = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(title: Text("Today's Attendance")),
      body: SingleChildScrollView(
          padding: EdgeInsets.only(top: 20, bottom: 20, left: 20, right: 20),
          child: Column(
            children: [
              
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Welcome",
                  style: TextStyle(
                      color: Colors.black54, fontSize: screenWeight / 20),
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Customer $userName",
                  style: TextStyle(
                      color: Colors.black54, fontSize: screenWeight / 20),
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Today's Status",
                  style: TextStyle(
                      color: Colors.black54, fontSize: screenWeight / 10),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 12, bottom: 32),
                height: 150,
                decoration: const BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black,
                        blurRadius: 10,
                        offset: Offset(2, 2),
                      ),
                    ],
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                child: Padding(
                  padding: const EdgeInsets.only(top: 40),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                            child: Column(
                          children: [
                            Text(
                              "Check In",
                              style: TextStyle(
                                  fontSize: screenWeight / 20,
                                  color: Colors.black),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              checkIn,
                              style: TextStyle(
                                  fontFamily: "NexaBold",
                                  fontSize: screenWeight / 18),
                            )
                          ],
                        )),
                        Expanded(
                            child: Column(
                          children: [
                            Text(
                              "Check Out",
                              style: TextStyle(
                                  fontSize: screenWeight / 20,
                                  color: Colors.black),
                            ),
                            // Text("--/--"),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              checkOut,
                              style: TextStyle(
                                  fontFamily: "NexaBold",
                                  fontSize: screenWeight / 18),
                            )
                          ],
                        ))
                      ]),
                ),
              ),
              Container(
                  alignment: Alignment.centerLeft,
                  child: RichText(
                    text: TextSpan(
                        text: DateTime.now().day.toString(),
                        style: TextStyle(
                            color: Colors.red, fontSize: screenWeight / 18),
                        children: [
                          TextSpan(
                              text: DateFormat(" MMMM yyyy")
                                  .format(DateTime.now()),
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: screenWeight / 18))
                        ]),
                  )),
                  SizedBox(height: 8,),
              StreamBuilder(
                  stream: Stream.periodic(const Duration(seconds: 1)),
                  builder: (context, snapshot) {
                    return Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        DateFormat("hh:mm:ss a").format(DateTime.now()),
                        style: TextStyle(
                            fontFamily: "NexaBold",
                            fontSize: screenWeight / 20,
                            color: Colors.black38),
                      ),
                    );
                  }),
              checkOut == "--/--"
                  ? Container(
                      margin: EdgeInsets.only(top: 24),
                      child: Builder(
                        builder: (context) {
                          final GlobalKey<SlideActionState> key = GlobalKey();
                          return SlideAction(
                            text: checkIn == "--/--"
                                ? "Slide to Check In"
                                : "Slide to Check Out",
                            textStyle: TextStyle(
                                color: Colors.black,
                                fontSize: screenWeight / 20),
                            outerColor: Colors.white,
                            innerColor: Colors.red,
                            key: key,
                            onSubmit: () async {
                              Timer(Duration(seconds: 1), () {
                                key.currentState!.reset();
                              });
                              QuerySnapshot snap = await FirebaseFirestore
                                  .instance
                                  .collection("Employee")
                                  .where('username', isEqualTo: userName)
                                  .get();
                              // print(snap.docs[0].id);
                              DocumentSnapshot snap2 = await FirebaseFirestore
                                  .instance
                                  .collection("Employee")
                                  .doc(snap.docs[0].id)
                                  .collection("Record")
                                  .doc(DateFormat('dd MMMM yyyy')
                                      .format(DateTime.now()))
                                  .get();
                              try {
                                String checkIn = snap2['checkIn'];
                                setState(() {
                                  checkOut = DateFormat("hh:mm")
                                      .format(DateTime.now());
                                  date = DateFormat('dd MMMM yyyy')
                                      .format(DateTime.now());
                                });
                                await FirebaseFirestore.instance
                                    .collection("Employee")
                                    .doc(snap.docs[0].id)
                                    .collection("Record")
                                    .doc(DateFormat("dd MMMM yyyy")
                                        .format(DateTime.now()))
                                    .update({
                                  "checkIn": checkIn,
                                  "checkOut": DateFormat('hh:mm')
                                      .format(DateTime.now()),
                                  "date": DateFormat('dd MMMM yyyy')
                                      .format(DateTime.now())
                                });
                              } catch (e) {
                                setState(() {
                                  checkIn = DateFormat("hh:mm")
                                      .format(DateTime.now());
                                });
                                await FirebaseFirestore.instance
                                    .collection("Employee")
                                    .doc(snap.docs[0].id)
                                    .collection("Record")
                                    .doc(DateFormat("dd MMMM yyyy")
                                        .format(DateTime.now()))
                                    .set({
                                  "checkIn": DateFormat('hh:mm')
                                      .format(DateTime.now()),
                                  "date": DateFormat('dd MMMM yyyy')
                                      .format(DateTime.now())
                                });
                              }
                            },
                          );
                        },
                      ),
                    )
                  : Container(
                      margin: EdgeInsets.only(top: 32),
                      child: Text(
                        "You have Completed this day!",
                        style: TextStyle(
                            color: Colors.black, fontSize: screenWeight / 20),
                      ),
                    )
            ],
          )),
    );
  }
}
