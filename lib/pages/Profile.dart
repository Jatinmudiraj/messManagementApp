import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project3/pages/welcome_screen.dart';
import 'package:image_picker/image_picker.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final String? userName = FirebaseAuth.instance.currentUser?.displayName;
  final String? user = FirebaseAuth.instance.currentUser?.email;
  final TextEditingController _nameController = TextEditingController(
    text: FirebaseAuth.instance.currentUser?.displayName ?? '',
  );
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _locationController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }

  File? _image;

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: source);
    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Profile',
          style: TextStyle(
            fontSize: 30,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Edit Profile'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // TextFormField(
                        //   controller: _nameController,
                        //   decoration: InputDecoration(
                        //     labelText: 'Name',
                        //   ),
                        // ),
                        TextFormField(
                          controller: _locationController,
                          decoration: InputDecoration(
                            labelText: 'Location',
                          ),
                        ),
                        TextFormField(
                          controller: _phoneNumberController,
                          decoration: InputDecoration(
                            labelText: 'Phone Number',
                          ),
                        ),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('Cancel'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // Save the new profile information
                          String newName = _nameController.text.trim();
                          String newLocation = _locationController.text.trim();
                          String newPhoneNumber =
                              _phoneNumberController.text.trim();

                          // Update the user's display name in Firebase Auth
                          FirebaseAuth.instance.currentUser
                              ?.updateDisplayName(newName);

                          // Update the user's profile information in your database or storage
                          // ...

                          // Close the dialog
                          Navigator.pop(context);
                        },
                        child: Text('Save'),
                      ),
                    ],
                  );
                },
              );
            },
            icon: Icon(
              Icons.settings,
              color: Colors.black,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(height: 40),
          Stack(
            children: [
              CircleAvatar(
                radius: 70,
                backgroundImage: _image != null
                    ? FileImage(_image!) as ImageProvider<Object>
                    : NetworkImage(
                            'https://firebasestorage.googleapis.com/v0/b/project3-917bd.appspot.com/o/gig_images%2Fprofile.png?alt=media&token=e244aaa7-3cf2-4754-97d5-c84201d32bff')
                        as ImageProvider<Object>,
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: () async {
                    await _pickImage(ImageSource.gallery);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Icon(
                      Icons.camera_alt,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Text(
            userName!,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 5),
          Text(
            _phoneNumberController.text,
            style: TextStyle(
              fontSize: 20,
              color: Colors.grey[700],
            ),
          ),
          SizedBox(height: 5),
          Text(
            user!,
            style: TextStyle(
              fontSize: 20,
              color: Colors.grey[700],
            ),
          ),
          SizedBox(height: 5),
          Text(
            _locationController.text,
            style: TextStyle(
              fontSize: 20,
              color: Colors.grey[700],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                color: Colors.grey[200],
              ),
              child: Padding(
                padding: EdgeInsets.all(30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Edit Profile'),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    // TextFormField(
                                    //   controller: _nameController,
                                    //   decoration: InputDecoration(
                                    //     labelText: 'Name',
                                    //   ),
                                    // ),
                                    TextFormField(
                                      controller: _locationController,
                                      decoration: InputDecoration(
                                        labelText: 'Location',
                                      ),
                                    ),
                                    TextFormField(
                                      controller: _phoneNumberController,
                                      decoration: InputDecoration(
                                        labelText: 'Phone Number',
                                      ),
                                    ),
                                  ],
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text('Cancel'),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      // Save the new profile information
                                      String newName =
                                          _nameController.text.trim();
                                      String newLocation =
                                          _locationController.text.trim();
                                      String newPhoneNumber =
                                          _phoneNumberController.text.trim();

                                      // Update the user's display name in Firebase Auth
                                      FirebaseAuth.instance.currentUser
                                          ?.updateDisplayName(newName);

                                      // Update the user's profile information in your database or storage
                                      // ...

                                      // Close the dialog
                                      Navigator.pop(context);
                                    },
                                    child: Text('Save'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.blue[900],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: 40,
                            vertical: 15,
                          ),
                        ),
                        child: Text(
                          'Edit Profile',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () async {
                          await FirebaseAuth.instance.signOut();
                          if (!mounted) return;
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return const WelcomeScreen();
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
                          'Log Out',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.blue[900],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
