class Post {
  String id;
  String text; // Zamiast 'title'
  String
      content; // Jeżeli pole 'content' jest inne w Firestore, zmień też tutaj
  DateTime date; // Zamiast 'dateCreated'
  String userId; // Zamiast 'authorId'

  Post({
    required this.id,
    required this.text,
    required this.content,
    required this.date,
    required this.userId,
  });
}
