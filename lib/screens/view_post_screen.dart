import 'package:fitappv2/screens/post_deatils_page.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ViewPostsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Posty'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('posts')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Wystąpił błąd');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data()! as Map<String, dynamic>;

              List<dynamic> imageUrls = (data['imageUrls'] is List)
                  ? List<dynamic>.from(data['imageUrls'])
                  : [];

              return Card(
                margin: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ...imageUrls
                        .map((url) => Image.network(
                              url,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: 200,
                            ))
                        .toList(),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        data['text'],
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 4.0),
                      child: Text(
                        data['content'],
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                    ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(data['userPhotoUrl'] ??
                            'https://example.com/default_avatar.png'),
                      ),
                      title: Text(data['userName'] ?? 'Anonimowy użytkownik'),
                      trailing: IconButton(
                        icon: Icon(Icons.comment),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  PostDetailsPage(documentId: document.id),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
