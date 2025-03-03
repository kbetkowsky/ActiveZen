import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  final TextEditingController _usernameController = TextEditingController();
  File? _image;
  final picker = ImagePicker();
  final String userId = FirebaseAuth.instance.currentUser!.uid;
  String? _downloadURL;

  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
  }

  Future<void> _fetchUserProfile() async {
    DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
        .collection('UserProfile')
        .doc(userId)
        .get();
    if (userSnapshot.exists) {
      Map<String, dynamic> userData =
          userSnapshot.data() as Map<String, dynamic>;
      setState(() {
        _usernameController.text = userData['username'];
        _downloadURL = userData['photoURL'];
      });
    }
  }

  Future getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future uploadPic(BuildContext context) async {
    String fileName = 'profilePictures/$userId.jpg';
    firebase_storage.Reference ref =
        firebase_storage.FirebaseStorage.instance.ref().child(fileName);

    await ref.putFile(_image!);
    String downloadURL = await ref.getDownloadURL();

    await FirebaseFirestore.instance.collection('UserProfile').doc(userId).set({
      'username': _usernameController.text,
      'photoURL': downloadURL,
    }, SetOptions(merge: true));

    setState(() {
      _downloadURL = downloadURL;
    });

    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profil zaktualizowany pomyślnie')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Użytkownika'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            const SizedBox(height: 20),
            if (_downloadURL != null)
              Image.network(
                _downloadURL!,
                width: 100.0,
                height: 100.0,
                fit: BoxFit.cover,
              ),
            Text('Obecna nazwa użytkownika: ${_usernameController.text}'),
            const SizedBox(height: 20),
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(
                  labelText: 'Wpisz swoją nazwę użytkownika:'),
            ),
            const SizedBox(height: 20),
            OutlinedButton(
              onPressed: getImage,
              child: const Text('Wybierz swoje zdjęcie profilowe'),
            ),
            _image != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(50.0),
                    child: Image.file(
                      _image!,
                      width: 100.0,
                      height: 100.0,
                      fit: BoxFit.cover,
                    ),
                  )
                : const Text('No image selected.'),
            ElevatedButton(
              onPressed: () => uploadPic(context),
              child: const Text('Zapisz'),
            ),
          ],
        ),
      ),
    );
  }
}
