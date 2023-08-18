import 'package:flutter/material.dart';
import 'package:project3/pages/MessExpensePage.dart';
import 'package:project3/pages/create_gig.dart';
import 'package:project3/pages/history.dart';
import 'package:project3/pages/todayScreen.dart';
class Functional extends StatefulWidget {
  const Functional({Key? key}) : super(key: key);

  @override
  State<Functional> createState() => _FunctionalState();
}

class _FunctionalState extends State<Functional> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // leading: Icon(Icons.arrow_back_ios_new),
        // actions: [IconButton(onPressed: () {
        //                 Navigator.pop(context);
        //               }, icon: Icon(
        //   Icons.arrow_back_ios_new,
        //   color: Colors.black,
        // ),)],
        title: Text('FUNCTIONAL PAGE'),
      ),
      body: Container(
        margin: EdgeInsets.only(top: 50,left: 10,right: 10),
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
            SizedBox(height: 20,),
            SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () {
                    
                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                      return const CreateGig();
                    }));
                  },
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: 40, vertical: 15),
                          side: BorderSide(
                            color: Colors.blue[900]!,
                            width: 2,
                          ),
                        ),
                        child: Text(
                          'Create Product',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.blue[900],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20,),
            SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () {
                    
                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                      return const TodaySceen();
                    }));
                  },
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          // backgroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(
                              horizontal: 40, vertical: 15),
                          side: BorderSide(
                            color: Colors.blue[900]!,
                            width: 2,
                          ),
                        ),
                        child: Text(
                          'Attendance',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.blue[900],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 20,),
            SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () {
                    
                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                      return MessExpenseCalculator();
                    }));
                  },
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: 40, vertical: 15),
                          side: BorderSide(
                            color: Colors.blue[900]!,
                            width: 2,
                          ),
                        ),
                        child: Text(
                          'Calculate Expense',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.blue[900],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                     SizedBox(height: 20,),
            SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () {
                    
                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                      return const MyWidget();
                    }));
                  },
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: 40, vertical: 15),
                          side: BorderSide(
                            color: Colors.blue[900]!,
                            width: 2,
                          ),
                        ),
                        child: Text(
                          'Attandance History',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.blue[900],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    
          ]),
        ),
      ),
    );
  }
}