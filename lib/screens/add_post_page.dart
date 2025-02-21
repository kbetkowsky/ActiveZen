import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Dodane do uzyskania informacji o użytkowniku
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class AddPostPage extends StatefulWidget {
  @override
  _AddPostPageState createState() => _AddPostPageState();
}

class _AddPostPageState extends State<AddPostPage> {
  final TextEditingController _textController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  List<File> images = [];
  final FirebaseAuth _auth = FirebaseAuth.instance; // Instancja FirebaseAuth

  Future<void> pickImages() async {
    final ImagePicker picker = ImagePicker();
    final List<XFile>? selectedImages = await picker.pickMultiImage();

    if (selectedImages != null && selectedImages.isNotEmpty) {
      setState(() {
        images = selectedImages.map((xFile) => File(xFile.path)).toList();
      });
    }
  }

  Future<void> uploadImagesAndPost() async {
    if (_textController.text.isEmpty ||
        _contentController.text.isEmpty ||
        images.isEmpty) {
      // Logika wyświetlania komunikatu o błędzie
      return;
    }

    List<String> imageUrls = [];
    FirebaseStorage storage = FirebaseStorage.instance;

    for (var image in images) {
      String fileName =
          'posts/${DateTime.now().millisecondsSinceEpoch}_${image.path.split('/').last}';
      try {
        TaskSnapshot snapshot = await storage.ref(fileName).putFile(image);
        String imageUrl = await snapshot.ref.getDownloadURL();
        imageUrls.add(imageUrl);
      } catch (e) {
        // Obsługa błędów
        return; // Przerwij jeśli któryś z obrazów się nie przesłał
      }
    }

    addPostToFirestore(imageUrls: imageUrls);
  }

  Future<void> addPostToFirestore({required List<String> imageUrls}) async {
    final user = _auth.currentUser;
    if (user != null) {
      final userId = user.uid;
      // Pobierz dane użytkownika z Firestore
      final userData = await FirebaseFirestore.instance
          .collection('UserProfile')
          .doc(userId)
          .get();
      final userName =
          userData['username'] ?? 'Anonim'; // Ustal domyślną nazwę użytkownika
      final userPhotoUrl =
          userData['photoURL'] ?? ''; // Ustal domyślne zdjęcie profilowe

      FirebaseFirestore firestore = FirebaseFirestore.instance;
      await firestore.collection('posts').add(
        {
          'text': _textController.text,
          'content': _contentController.text,
          'userId': userId,
          'userName': userName, // Nazwa użytkownika
          'userPhotoUrl': userPhotoUrl, // Zdjęcie profilowe użytkownika
          'imageUrls': imageUrls,
          'likes': 0,
          'comments': [],
          'timestamp': FieldValue.serverTimestamp(),
        },
      );

      // Wyczyść formularz
      _textController.clear();
      _contentController.clear();
      setState(() {
        images = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dodaj Post'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _textController,
              decoration: InputDecoration(labelText: 'Tytuł'),
            ),
            SizedBox(height: 8.0),
            TextField(
              controller: _contentController,
              decoration: InputDecoration(labelText: 'Zawartość'),
              keyboardType: TextInputType.multiline,
              maxLines: null,
            ),
            SizedBox(height: 8.0),
            Wrap(
              spacing: 8.0,
              children: images
                  .map((image) => Image.file(image, width: 100, height: 100))
                  .toList(),
            ),
            SizedBox(height: 8.0),
            ElevatedButton(
              onPressed: pickImages,
              child: Text('Wybierz zdjęcia'),
            ),
            ElevatedButton(
              onPressed: uploadImagesAndPost,
              child: Text('Dodaj Post'),
            ),
          ],
        ),
      ),
    );
  }
}
