import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meanoji/services/meanoji-shared-preferences.dart';

class FirebaseService {
  final databaseReference = Firestore.instance;

  Future<DocumentSnapshot> getEmoji() async{
    CollectionReference emojisdb = databaseReference.collection("emojis");
    // String randomID = emojisdb.document().documentID;
    // await emojisdb.document(randomID).get().then((DocumentSnapshot snapshot) {
    //   if(!snapshot.exists)
    //     getEmoji();
    //   else
    //     print(snapshot.data);
    // });
    DocumentSnapshot snapshot = await emojisdb.document("1WNFqYSsLHFsRttuuqoV").get();
    return snapshot;
        //.then((DocumentSnapshot snapshot) {
          //print(snapshot.data);
      //snapshot.documents.forEach((f) => print('${f.data}}'));
   // });
  }

  void saveComment(String comment, String emojiUniCode) async {
    //This creates random document id
    DocumentReference ref = await databaseReference.collection("comments").add({
      'unicode': emojiUniCode,
      'comment': comment,
      'createdAt': DateTime.now().toUtc().millisecondsSinceEpoch,
      'username' : MeanojiPreferences.getUserName()
    });
    print(ref.documentID);
  }

  Future<bool> saveUser(String userName, String email) async {
    //This creates random document id
    if(userName == null || email == null || userName.isEmpty || email.isEmpty)
      return false;
    DocumentReference ref = await databaseReference.collection("users").add({
      'username': userName,
      'email': email,
      'createdAt': DateTime.now().toUtc().millisecondsSinceEpoch,
    });
    print(ref.documentID);
    if(ref.documentID != null) {
      MeanojiPreferences.setUserName(userName);
      return true;
    }
    return false;
  }

  void createRecord() async {
    //1 is emojiID
    await databaseReference
        .collection("comments")
        .document("1")
        .setData({'comment': 'New comment for emoji1', 'username': 'dawstest'});

    //This creates random document id
    // DocumentReference ref = await databaseReference.collection("comments").add({
    //   'title': 'Flutter in Action',
    //   'description': 'Complete Programming Guide to learn Flutter'
    // });
    //print(ref.documentID);
  }

  void getData() {
    databaseReference
        .collection("comments")
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((f) => print('${f.data}}'));
    });
  }
}
