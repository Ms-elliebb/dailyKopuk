import 'package:daily_kopuk/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

import 'dart:io';

class HomePage extends StatelessWidget {
  final ImagePicker _picker = ImagePicker();
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  HomePage({super.key});

  Future<void> _uploadMedia() async {
    final XFile? media = await _picker.pickImage(source: ImageSource.gallery);
    if (media != null) {
      final ref = _storage.ref().child('uploads/${media.name}');
      await ref.putFile(File(media.path));

      final url = await ref.getDownloadURL();
      await _firestore.collection('posts').add({'url': url, 'timestamp': Timestamp.now()});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Photo Share App'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => AuthService().signOut(),
          ),
        ],
      ),
      body: StreamBuilder(
        stream: _firestore.collection('posts').orderBy('timestamp', descending: true).snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) return const CircularProgressIndicator();
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final post = snapshot.data!.docs[index];
              return Image.network(post['url']);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _uploadMedia,
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
