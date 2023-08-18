import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AddImage extends StatefulWidget {
  const AddImage({Key? key}) : super(key: key);

  @override
  State<AddImage> createState() => _AddImageState();
}

class _AddImageState extends State<AddImage> {
  GlobalKey key = GlobalKey();
  CollectionReference _reference =
      FirebaseFirestore.instance.collection('shopping list');
  String imageUrl = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Image')),
      body: IconButton(
        onPressed: () async {
          ImagePicker imagePicker = ImagePicker();
          XFile? file =
              await imagePicker.pickImage(source: ImageSource.gallery);
          print("${file?.path}");
          if (file == null) return;
          String uniqueFileName =
              DateTime.now().microsecondsSinceEpoch.toString();
          Reference referenceRoot = FirebaseStorage.instance.ref();
          Reference referenceDirImages = referenceRoot.child('images');
          Reference referenceImageToUpload =
              referenceDirImages.child(uniqueFileName);

          try {
            await referenceImageToUpload.putFile(File(file.path));
            imageUrl = await referenceImageToUpload.getDownloadURL();
          } catch (error) {}
          // _reference.add(dataToSend);
        },
        icon: Icon(Icons.camera_alt),
      
      ),
      
    );
  }
}
