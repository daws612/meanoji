import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  final databaseReference = Firestore.instance;

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
