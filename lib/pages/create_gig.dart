import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:project3/auth/firebase_auth_service.dart';
import 'package:project3/utils/global_method.dart';
import 'package:project3/utils/global_variables.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:project3/utils/persistent.dart';
import 'package:uuid/uuid.dart';

class CreateGig extends StatefulWidget {
  const CreateGig({Key? key}) : super(key: key);

  @override
  State<CreateGig> createState() => _CreateGigState();
}

class _CreateGigState extends State<CreateGig> {
  final TextEditingController _MessNameController = TextEditingController();
  final TextEditingController _MessDiscriptionController =
      TextEditingController();
  final TextEditingController _MessDatelineController =
      TextEditingController(text: 'Mess Deadline');
  final TextEditingController _MessTypeController =
      TextEditingController(text: 'Select Mess Category');

  final _formKey = GlobalKey<FormState>();
  String imageUrl='';
  // CollectionReference _reference =
  //     FirebaseFirestore.instance.collection("Jobs");
  DateTime? picked;
  Timestamp? deadlineDateTimeStamp;
  bool _isLoading = false;
  @override
  void dispose() {
    super.dispose();
    _MessTypeController.dispose();
    _MessNameController.dispose();
    _MessDatelineController.dispose();
    _MessDiscriptionController.dispose();
  }

  Widget _textTitles({required String label}) {
    return Padding(
      padding: EdgeInsets.all(5.0),
      child: Text(
        label,
        style: TextStyle(
            color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _textFormFields({
  required String valueKey,
  required TextEditingController controller,
  required bool enabled,
  required Function fct,
  required int maxLength,
}) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: InkWell(
      onTap: () {
        fct();
      },
      child: TextFormField(
        validator: (value) {
          if (value!.isEmpty) {
            return 'Value is missing';
          }
          return null;
        },
        controller: controller,
        enabled: enabled,
        key: ValueKey(valueKey),
        style: TextStyle(color: Colors.black, fontSize: 16.0),
        maxLines: valueKey == 'Description' ? 3 : 1,
        maxLength: maxLength,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          filled: true,
          fillColor: Color.fromARGB(192, 242, 253, 255),
          contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey[400]!),
            borderRadius: BorderRadius.circular(10.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blueAccent),
            borderRadius: BorderRadius.circular(10.0),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red),
            borderRadius: BorderRadius.circular(10.0),
          ),
          errorStyle: TextStyle(fontSize: 12.0),
          labelText: valueKey,
          labelStyle: TextStyle(color: Colors.grey[700], fontSize: 16.0),
          // prefixIcon: Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 12.0),
          //   child: Text(
          //     valueKey,
          //     style: TextStyle(
          //       color: Colors.grey[600],
          //       fontSize: 16.0,
          //     ),
          //   ),
          // ),
        ),
      ),
    ),
  );
}


  _showTaskCategoiesDialog({required Size size}) {
    showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            backgroundColor: Color.fromARGB(182, 153, 235, 255),
            title: Text(
              "Mess Category",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color: Color.fromARGB(255, 0, 0, 0)),
              
            ),
            content: Container(
              width: size.width * 0.9,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: Persistent.messCategoryList.length,
                itemBuilder: (ctx, index) {
                  return InkWell(
                    onTap: () {
                      setState(() {
                        _MessTypeController.text =
                            Persistent.messCategoryList[index];
                      });
                      Navigator.pop(context);
                    },
                    child: Row(
                      children: [
                        Icon(
                          Icons.arrow_right_alt_outlined,
                          color: Color.fromARGB(255, 255, 201, 201),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8),
                          child: Text(
                            Persistent.messCategoryList[index],
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.canPop(context) ? Navigator.pop(context) : null;
                  },
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ))
            ],
          );
        });
  }

  void _pickDateDialog() async {
    picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now().subtract(const Duration(days: 0)),
        lastDate: DateTime(2100));
    if (picked != null) {
      setState(() {
        _MessDatelineController.text =
            '${picked!.year} - ${picked!.month}- ${picked!.day}';
        deadlineDateTimeStamp = Timestamp.fromMicrosecondsSinceEpoch(
            picked!.microsecondsSinceEpoch);
      });
    }
  }

  void _uploadTask() async {
    final messId = Uuid().v4();
    
    User? user = FirebaseAuth.instance.currentUser;
    final _uid = user!.uid;
    final isValid = _formKey.currentState!.validate();
    if (isValid) {
      if (_MessDatelineController.text == 'Choose Date' ||
          _MessTypeController.text == 'Choose Category') {
        GlobalMethod.showErrorDialog(
            error: "Please pick everything", ctx: context);
        return;
      }
      setState(() {
        _isLoading = true;
        // _reference.add(_uploadTask);
      });
      try {
      //   final picker = ImagePicker();
      // final pickedFile = await picker.getImage(source: ImageSource.gallery);
      // if (pickedFile != null) {
      //   final File file = File(pickedFile.path);
      //   final Reference ref = FirebaseStorage.instance.ref().child('gig_images').child(messId);
      //   final UploadTask task = ref.putFile(file);
      //   final TaskSnapshot snapshot = await task.whenComplete(() {});
      //   final String downloadUrl = await snapshot.ref.getDownloadURL();
      //   imageUrl = downloadUrl;
      // }
        await FirebaseFirestore.instance.collection("Jobs").doc(messId).set({
          "MessId": messId,
          "uploadedby": _uid,
          "Email": user.email,
          'MessTitle': _MessNameController.text,
          'Mess Discription': _MessDiscriptionController.text ,
          'Date Time': _MessDatelineController.text,
          'deadlinedateTimeStamp': deadlineDateTimeStamp,
          'Category': _MessTypeController.text,
          'Comments': [],
          'createdAt': Timestamp.now(),
          'name': user.displayName,
          'Image': imageUrl,
          'location': location,
          'applicants': 0,
        }
        
      
        );
        
        await Fluttertoast.showToast(
          msg: 'The task has been uploaded',
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: Colors.grey,
          fontSize: 18,
        );
        _MessNameController.clear();
        _MessDiscriptionController.clear();
        setState(() {
          _MessTypeController.text = 'Choose Type';
          _MessDatelineController.text = "Choose Date";
        });
      } catch (error) {
        {
          setState(() {
            _isLoading = false;
          });
          GlobalMethod.showErrorDialog(error: error.toString(), ctx: context);
        }
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      print('Its not valid');
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(title: Text('Create Product')),
      body: Center(
          child: Padding(
        padding: EdgeInsets.all(7.0),
        child: Card(
          color: Colors.white,
          child: SingleChildScrollView(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 10,
              ),
              Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: EdgeInsets.all(2),
                  child: Text(
                    "Please Fill Forom",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 40,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Divider(
                thickness: 10,
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _textTitles(label: 'Mess Type:'),
                      _textFormFields(
                        valueKey: 'MessType',
                        controller: _MessTypeController,
                        enabled: false,
                        fct: () {
                          _showTaskCategoiesDialog(size: size);
                        },
                        maxLength: 100,
                      ),
                      _textTitles(label: 'Mess Name:'),
                      _textFormFields(
                        valueKey: 'MessName',
                        controller: _MessNameController,
                        enabled: true,
                        fct: () {},
                        maxLength: 100,
                      ),
                      _textTitles(label: 'Mess Discription:'),
                      _textFormFields(
                        valueKey: 'MessDiscription',
                        controller: _MessDiscriptionController,
                        enabled: true,
                        fct: () {},
                        maxLength: 100,
                      ),
                      _textTitles(label: 'Mess Dateline:'),
                      _textFormFields(
                        valueKey: 'MessDateline',
                        controller: _MessDatelineController,
                        enabled: false,
                        fct: () {
                          _pickDateDialog();
                        },
                        maxLength: 100,
                      ),
                    ],
                  ),
                ),
              ),
              Center(
                child: IconButton(
        onPressed: () async {
  final messId = Uuid().v4();
  final picker = ImagePicker();
  final pickedFile = await picker.getImage(source: ImageSource.gallery);
  if (pickedFile != null) {
    final File file = File(pickedFile.path);
    final Reference ref = FirebaseStorage.instance.ref().child('gig_images').child(messId);
    final UploadTask task = ref.putFile(file);
    final TaskSnapshot snapshot = await task.whenComplete(() {});
    final String downloadUrl = await snapshot.ref.getDownloadURL();
    imageUrl = downloadUrl;
    
  }
},

        icon: Icon(Icons.camera_alt,color: Color.fromARGB(238, 161, 239, 253),),
        
      ),
              ),
              Center(
                child: Padding(
                  padding: EdgeInsets.all(30),
                  child: _isLoading
                      ? CircularProgressIndicator()
                      : MaterialButton(
                          onPressed: () {
                            _uploadTask();
                          },
                          color: Color.fromARGB(185, 193, 248, 255),
                          elevation: 8,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(13)),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: 14,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Post Now',
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 0, 0, 0),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 25),
                                ),
                                SizedBox(
                                  width: 9,
                                ),
                                Icon(
                                  Icons.upload_file,
                                  color: Color.fromARGB(255, 0, 0, 0),
                                )
                              ],
                            ),
                          ),
                        ),
                ),
              ),
            ],
          )),
        ),
      )),
    );
  }
}
