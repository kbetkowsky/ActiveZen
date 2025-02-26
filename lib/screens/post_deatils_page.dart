import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PostDetailsPage extends StatefulWidget {
  final String documentId;

  const PostDetailsPage({super.key, required this.documentId});

  @override
  _PostDetailsPageState createState() => _PostDetailsPageState();
}

class _PostDetailsPageState extends State<PostDetailsPage> {
  final TextEditingController _commentController = TextEditingController();

  void addLike() async {
    FirebaseFirestore.instance
        .collection('posts')
        .doc(widget.documentId)
        .update({
      'likes': FieldValue.increment(1),
    });
  }

  void addComment() {
    if (_commentController.text.trim().isNotEmpty) {
      FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.documentId)
          .update({
        'comments': FieldValue.arrayUnion([
          {
            'text': _commentController.text,
            'timestamp': DateTime.now(),
          }
        ]),
      });
      _commentController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Szczegóły postu'),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('posts')
                  .doc(widget.documentId)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const CircularProgressIndicator();

                var post = snapshot.data!.data() as Map<String, dynamic>;
                var comments = List.from(post['comments'] ?? []);
                var likes = post['likes'] ?? 0;

                return ListView(
                  children: [
                    ListTile(
                      title: Text('Polubienia: $likes'),
                      trailing: IconButton(
                        icon: const Icon(Icons.thumb_up),
                        onPressed: addLike,
                      ),
                    ),
                    const Divider(),
                    ...comments.map((comment) {
                      return ListTile(
                        title: Text(comment['text']),
                        subtitle:
                            Text(comment['timestamp'].toDate().toString()),
                      );
                    }),
                  ],
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _commentController,
                    decoration:
                        const InputDecoration(labelText: 'Dodaj komentarz'),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: addComment,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
