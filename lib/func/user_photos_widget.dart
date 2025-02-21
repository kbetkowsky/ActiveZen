import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';

class UserPhotosWidget extends StatefulWidget {
  @override
  _UserPhotosWidgetState createState() => _UserPhotosWidgetState();
}

class _UserPhotosWidgetState extends State<UserPhotosWidget> {
  final ImagePicker _picker = ImagePicker();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  List<String> _imageUrls = [];

  @override
  void initState() {
    super.initState();
    _loadUserImages();
  }

  Future<void> _loadUserImages() async {
    var userId = _auth.currentUser?.uid; // Uzyskaj ID bieżącego użytkownika
    if (userId != null) {
      var snapshot = await _firestore
          .collection('userImages')
          .doc(userId)
          .collection('images')
          .get();
      var urls = snapshot.docs.map((doc) => doc['imageUrl'] as String).toList();
      setState(() {
        _imageUrls = urls;
      });
    }
  }

  Future<void> _addImage() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null && _auth.currentUser != null) {
      File file = File(pickedFile.path);
      String fileName =
          'userImages/${_auth.currentUser!.uid}/${DateTime.now().millisecondsSinceEpoch}_${file.uri.pathSegments.last}';
      var uploadTask = _storage.ref(fileName).putFile(file);

      // Po zakończeniu przesyłania, zapisz URL do Firestore
      await uploadTask.then((res) async {
        var downloadUrl = await res.ref.getDownloadURL();
        await _firestore
            .collection('userImages')
            .doc(_auth.currentUser!.uid)
            .collection('images')
            .add({'imageUrl': downloadUrl});
        setState(() {
          _imageUrls.add(downloadUrl);
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
      itemCount: _imageUrls.length + 1, // Dodaj 1 dla przycisku dodawania
      itemBuilder: (context, index) {
        if (index < _imageUrls.length) {
          return Image.network(_imageUrls[index], fit: BoxFit.cover);
        } else {
          return GestureDetector(
            onTap: _addImage,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[300],
                border: Border.all(color: Colors.black38),
              ),
              child: Icon(Icons.add, size: 50),
            ),
          );
        }
      },
    );
  }
}
