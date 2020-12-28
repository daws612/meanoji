import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meanoji/services/meanoji-shared-preferences.dart';

class FirebaseService {
  final databaseReference = FirebaseFirestore.instance;

  Future<DocumentSnapshot> getEmoji() async {
    CollectionReference emojisdb = databaseReference.collection("emojis");
    // String randomID = emojisdb.document().documentID;
    // await emojisdb.document(randomID).get().then((DocumentSnapshot snapshot) {
    //   if(!snapshot.exists)
    //     getEmoji();
    //   else
    //     print(snapshot.data);
    // });
    DocumentSnapshot snapshot =
        await emojisdb.doc("1WNFqYSsLHFsRttuuqoV").get();
    return snapshot;
    //.then((DocumentSnapshot snapshot) {
    //print(snapshot.data);
    //snapshot.documents.forEach((f) => print('${f.data}}'));
    // });
  }

  Future<bool> saveComment(
      String comment, String emojiUniCode, String emojiDocumentID) async {
    //This creates random document id
    DocumentReference ref = await databaseReference.collection("comments").add({
      'emojiID': emojiDocumentID,
      'unicode': emojiUniCode,
      'comment': comment,
      'createdAt': DateTime.now().toUtc().millisecondsSinceEpoch,
      'username': await MeanojiPreferences.getUserName()
    });
    print(ref.id);

    if(ref.id != null)
        return true;
    return false;
  }

  Future<bool> saveUser(String userName, String email) async {
    //This creates random document id
    if (userName == null || email == null || userName.isEmpty || email.isEmpty)
      return false;
    DocumentReference ref = await databaseReference.collection("users").add({
      'username': userName,
      'email': email,
      'createdAt': DateTime.now().toUtc().millisecondsSinceEpoch,
    });
    print(ref.id);
    if (ref.id != null) {
      MeanojiPreferences.setUserName(userName);
      return true;
    }
    return false;
  }

  void createRecord() async {
    //1 is emojiID
    await databaseReference
        .collection("comments")
        .doc("1")
        .set({'comment': 'New comment for emoji1', 'username': 'dawstest'});

    //This creates random document id
    // DocumentReference ref = await databaseReference.collection("comments").add({
    //   'title': 'Flutter in Action',
    //   'description': 'Complete Programming Guide to learn Flutter'
    // });
    //print(ref.documentID);
  }

  Future<QuerySnapshot> getCommentsForEmoji(String emojiID) async {
    QuerySnapshot snapshot = await databaseReference
        .collection("comments")
        .where("emojiID", isEqualTo: emojiID)
        .get();
    return snapshot;
  }

  Future<DocumentSnapshot> getEmojiDetails(DocumentSnapshot a) async {
    CollectionReference emojisdb = databaseReference.collection("emojis");
    DocumentSnapshot snapshot = await emojisdb.doc(a.id).get();
    return snapshot;
  }
}
