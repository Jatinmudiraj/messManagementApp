import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project3/pages/todayScreen.dart';
import 'package:project3/pages/welcome_screen.dart';

import 'package:project3/widgets/Top_Bar.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // final String? userName = FirebaseAuth.instance.currentUser?.displayName;
  int currentPage = 0;
  final PageController _pageController = PageController(initialPage: 0);
  final List<String> images = [
    'https://firebasestorage.googleapis.com/v0/b/project3-917bd.appspot.com/o/gig_images%2FHostel_Room_1.jpg?alt=media&token=e1b68a0e-0e4a-4854-9408-8c891df0e663',
    'https://firebasestorage.googleapis.com/v0/b/project3-917bd.appspot.com/o/gig_images%2FMess_Image_1.jpeg?alt=media&token=5fd37849-2bdc-4e78-9c3f-eba8a5162ef2',
    'https://firebasestorage.googleapis.com/v0/b/project3-917bd.appspot.com/o/gig_images%2FHostel_Room_2.jpeg?alt=media&token=b02cb093-e8a4-402d-bf36-ce78d13c8189',
    'https://firebasestorage.googleapis.com/v0/b/project3-917bd.appspot.com/o/gig_images%2FMess_Image_3.jpg?alt=media&token=4a902fac-7f0c-42cf-b0d4-2660e50d2070',
    'https://firebasestorage.googleapis.com/v0/b/project3-917bd.appspot.com/o/gig_images%2FHostel_Room_3.jpg?alt=media&token=065687c9-20a9-4706-949c-e8bac8cbf692',
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
            child: Text(
          "Mess Management App",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
        )),
      ),
      drawer: NavBar(),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Stack(
                  children: [
                    SizedBox(
                      height: 200,
                      child: PageView.builder(
                        controller: _pageController,
                        onPageChanged: (int page) {
                          setState(() {
                            currentPage = page;
                          });
                        },
                        itemCount: images.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(images[index]),
                                fit: BoxFit.cover,
                              ),
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.3),
                                  blurRadius: 5,
                                  spreadRadius: 2,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            margin: EdgeInsets.symmetric(horizontal: 10),
                          );
                        },
                      ),
                    ),
                    Positioned(
                      bottom: 10,
                      left: 0,
                      right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          images.length,
                          (index) => Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: currentPage == index
                                    ? Colors.white
                                    : Colors.grey,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Text(
                  'Best Hostel',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 1,
              ),
              SingleChildScrollView(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('Jobs')
                      .where('Category', isEqualTo: 'Hostel')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return CircularProgressIndicator();
                    }

                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: snapshot.data!.docs.map((job) {
                          return Padding(
                            padding: EdgeInsets.only(left: 8, right: 8),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => JobDetails(job: job),
                                  ),
                                );
                              },
                              child: Container(
                                width: 250,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10.0),
                                  border: Border.all(
                                    color: Colors.grey.shade300,
                                    width: 1.0,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.3),
                                      blurRadius: 5,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(10.0),
                                      ),
                                      child: Image.network(
                                        job['Image'],
                                        height: 150.0,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    // SizedBox(height: 10.0),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 8, right: 8, top: 2),
                                      child: Text(
                                        job['MessTitle'],
                                        style: TextStyle(
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Text(
                  'Best Mess',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 1,
              ),

              SingleChildScrollView(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('Jobs')
                      .where('Category', isEqualTo: 'Mess,')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return CircularProgressIndicator();
                    }

                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: snapshot.data!.docs.map((job) {
                          return Padding(
                            padding: EdgeInsets.only(left: 8, right: 8),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => JobDetails(job: job),
                                  ),
                                );
                              },
                              child: Container(
                                width: 250,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10.0),
                                  border: Border.all(
                                    color: Colors.grey.shade300,
                                    width: 1.0,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.3),
                                      blurRadius: 5,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(10.0),
                                      ),
                                      child: Image.network(
                                        job['Image'],
                                        height: 150.0,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    // SizedBox(height: 10.0),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 8, right: 8, top: 2),
                                      child: Text(
                                        job['MessTitle'],
                                        style: TextStyle(
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    );
                  },
                ),
              ),

              SizedBox(
                height: 8,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Text(
                  'Nearest Mess',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 1,
              ),

              SingleChildScrollView(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('Jobs')
                      .where('Category', isEqualTo: 'Mess,')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return CircularProgressIndicator();
                    }

                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: snapshot.data!.docs.map((job) {
                          return Padding(
                            padding: EdgeInsets.only(left: 8, right: 8),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => JobDetails(job: job),
                                  ),
                                );
                              },
                              child: Container(
                                width: 250,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10.0),
                                  border: Border.all(
                                    color: Colors.grey.shade300,
                                    width: 1.0,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.3),
                                      blurRadius: 5,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(10.0),
                                      ),
                                      child: Image.network(
                                        job['Image'],
                                        height: 150.0,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    // SizedBox(height: 10.0),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 8, right: 8, top: 2),
                                      child: Text(
                                        job['MessTitle'],
                                        style: TextStyle(
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class JobDetails extends StatelessWidget {
  final DocumentSnapshot job;

  const JobDetails({Key? key, required this.job}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<dynamic> comments = job.get('Comments');

    return Scaffold(
      appBar: AppBar(
        title: Text(job['MessTitle']),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 2),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Container(
                    height: 300.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(30.0),
                        bottomRight: Radius.circular(30.0),
                      ),
                      image: DecorationImage(
                        image: NetworkImage(job['Image']),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 20.0,
                    left: 20.0,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 5.0,
                        horizontal: 10.0,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Text(
                        job['Category'],
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {},
                    child: Text('Contact Us'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TodaySceen(),
                          ));
                    },
                    child: Text('Attendance'),
                  ),
                ],
              ),
              SizedBox(height: 8.0),
              Padding(
                padding:
                    const EdgeInsets.only(top: 8, bottom: 5, left: 8, right: 8),
                child: Text(
                  job['MessTitle'],
                  style: TextStyle(
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              // SizedBox(height: 8.0),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Detail:\n" + job['Mess Discription'],
                  style: TextStyle(
                    fontSize: 20.0,
                  ),
                ),
              ),
              // SizedBox(height: 20.0),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Join with us on: " + job['Date Time'],
                  style: TextStyle(
                    fontSize: 20.0,
                  ),
                ),
              ),
              // SizedBox(height: 20.0),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Email: " + job['Email'],
                  style: TextStyle(
                    fontSize: 20.0,
                  ),
                ),
              ),
              // SizedBox(height: 20.0),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Location: " + job['location'],
                  style: TextStyle(
                    fontSize: 20.0,
                  ),
                ),
              ),
              // SizedBox(height: 20.0),
              // SizedBox(height: 20.0),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Comments',
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10.0),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: comments.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Text(
                            comments[index],
                            style: TextStyle(fontSize: 18.0),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
