import 'package:cloud_firestore/cloud_firestore.dart';

class Emojis {
  static List<DocumentSnapshot> allEmojis;

  List<DocumentSnapshot> getAllEmojis() {
    return allEmojis;
  }

  void setAllEmojis(List<DocumentSnapshot> emojis) {
    allEmojis = emojis;
  }

  void fetchEmojis() async {
    QuerySnapshot emojis =
        await Firestore.instance.collection("emojis").limit(15).getDocuments();
    allEmojis = emojis.documents;
  }

  Future<List<DocumentSnapshot>> fetchEmojisAsync(
      int startFrom, int pageLength) async {
    QuerySnapshot emojis;
    if (startFrom > 0) {
      emojis = await Firestore.instance
          .collection("emojis")
          .startAfterDocument(allEmojis[startFrom])
          .orderBy("base")
          .limit(pageLength)
          .getDocuments();
    } else {
      emojis = await Firestore.instance
          .collection("emojis")
          .orderBy("base")
          .limit(pageLength)
          .getDocuments();
    }
    allEmojis != null ? allEmojis.addAll(emojis.documents) : allEmojis = emojis.documents;
    return emojis.documents;
  }
}
