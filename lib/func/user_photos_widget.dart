import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';

class UserPhotosWidget extends StatefulWidget {
  const UserPhotosWidget({super.key});

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
    var userId = _auth.currentUser?.uid;
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Moje Zdjęcia'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 8.0,
            mainAxisSpacing: 8.0,
          ),
          itemCount: _imageUrls.length + 1,
          itemBuilder: (context, index) {
            if (index < _imageUrls.length) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(
                  _imageUrls[index],
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    );
                  },
                ),
              );
            } else {
              return GestureDetector(
                onTap: _addImage,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(color: Colors.black38),
                  ),
                  child: const Icon(Icons.add, size: 50, color: Colors.teal),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
