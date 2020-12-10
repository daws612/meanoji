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
        await FirebaseFirestore.instance.collection("emojis").limit(15).get();
    allEmojis = emojis.docs;
  }

  Future<List<DocumentSnapshot>> fetchEmojisAsync(
      int startFrom, int pageLength, DocumentSnapshot continueFromCurrent) async {
    QuerySnapshot emojis;
    if (startFrom >= 0 && continueFromCurrent != null) {
      emojis = await FirebaseFirestore.instance
          .collection("emojis")
          .orderBy("base")
          .startAfterDocument(continueFromCurrent)
          .limit(pageLength)
          .get();
    } else {
      emojis = await FirebaseFirestore.instance
          .collection("emojis")
          .orderBy("base")
          .limit(pageLength)
          .get();
    }
    allEmojis != null ? allEmojis.addAll(emojis.docs) : allEmojis = emojis.docs;
    return emojis.docs;
  }
}
