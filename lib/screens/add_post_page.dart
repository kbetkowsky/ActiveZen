import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class AddPostPage extends StatefulWidget {
  const AddPostPage({super.key});

  @override
  _AddPostPageState createState() => _AddPostPageState();
}

class _AddPostPageState extends State<AddPostPage> {
  final TextEditingController _textController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  List<File> images = [];
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> pickImages() async {
    final ImagePicker picker = ImagePicker();
    final List<XFile>? selectedImages = await picker.pickMultiImage();

    if (selectedImages == null || selectedImages.isEmpty) return;

    setState(() {
      images = selectedImages.map((xFile) => File(xFile.path)).toList();
    });
  }

  Future<void> uploadImagesAndPost() async {
    if (_textController.text.isEmpty ||
        _contentController.text.isEmpty ||
        images.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Wypełnij wszystkie pola i dodaj zdjęcia!')),
      );
      return;
    }

    List<String> imageUrls = [];
    FirebaseStorage storage = FirebaseStorage.instance;

    try {
      for (var image in images) {
        String fileName =
            'posts/${DateTime.now().millisecondsSinceEpoch}_${image.path.split('/').last}';
        TaskSnapshot snapshot = await storage.ref(fileName).putFile(image);
        String imageUrl = await snapshot.ref.getDownloadURL();
        imageUrls.add(imageUrl);
      }
      await addPostToFirestore(imageUrls: imageUrls);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Błąd przesyłania obrazu: $e')),
      );
    }
  }

  Future<void> addPostToFirestore({required List<String> imageUrls}) async {
    final user = _auth.currentUser;
    if (user == null) return;

    final userId = user.uid;
    final userData = await FirebaseFirestore.instance
        .collection('UserProfile')
        .doc(userId)
        .get();

    final userName = userData.data()?['username'] ?? 'Anonim';
    final userPhotoUrl = userData.data()?['photoURL'] ?? '';

    await FirebaseFirestore.instance.collection('posts').add({
      'text': _textController.text,
      'content': _contentController.text,
      'userId': userId,
      'userName': userName,
      'userPhotoUrl': userPhotoUrl,
      'imageUrls': imageUrls,
      'likes': 0,
      'comments': [],
      'timestamp': FieldValue.serverTimestamp(),
    });

    _textController.clear();
    _contentController.clear();
    setState(() {
      images = [];
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Post dodany pomyślnie!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dodaj Post')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _textController,
              decoration: const InputDecoration(labelText: 'Tytuł'),
            ),
            const SizedBox(height: 8.0),
            TextField(
              controller: _contentController,
              decoration: const InputDecoration(labelText: 'Zawartość'),
              keyboardType: TextInputType.multiline,
              maxLines: null,
            ),
            const SizedBox(height: 8.0),
            Wrap(
              spacing: 8.0,
              children: images
                  .map((image) => Image.file(image, width: 100, height: 100))
                  .toList(),
            ),
            const SizedBox(height: 8.0),
            ElevatedButton(
              onPressed: pickImages,
              child: const Text('Wybierz zdjęcia'),
            ),
            ElevatedButton(
              onPressed: uploadImagesAndPost,
              child: const Text('Dodaj Post'),
            ),
          ],
        ),
      ),
    );
  }
}
