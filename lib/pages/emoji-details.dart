import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:meanoji/services/firebase-service.dart';
import 'package:meanoji/services/meanoji-shared-preferences.dart';
import 'emoji-search-delegate.dart';

class EmojiDetails extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new EmojiDetailsState();
}

class EmojiDetailsState extends State<EmojiDetails> {
  DocumentSnapshot snapshot;

  bool _enableComment = false;

  @override
  void initState() {
    super.initState();
    Future<DocumentSnapshot> snapshot = FirebaseService().getEmoji();
    snapshot.then((value) {
      setState(() {
        this.snapshot = value;
      });
    });

    MeanojiPreferences.hasUserName().then((status) {
      setState(() {
        _enableComment = status;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              expandedHeight: 240.0,
              floating: false,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  title: Text(snapshot != null ? snapshot.data[
                                        "base"] : "oops! We do not know.",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.0,
                      )),
                  background: snapshot != null
                      ? Center(
                          child: Container(
                            width: 120,
                            height: 150,
                            child: FittedBox(
                              fit: BoxFit.cover,
                              child: RichText(
                                  textAlign: TextAlign.center,
                                  text: TextSpan(
                                    text: snapshot.data[
                                        "moji"], //'🧭 🏳️\u200d🌈', // emoji characters
                                    style: TextStyle(
                                      fontFamily: 'EmojiOne',
                                      //fontSize: 120,
                                    ),
                                  )),
                            ),
                        ))
                      : Image(
                          image: new AssetImage('openmoji618/1F60A.png'),
                          fit: BoxFit.cover,
                        )),
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    showSearchPage(context, EmojiSearchDelegate());
                  },
                ),
              ],
            ),
          ];
        },
        body: Center(
            child: Column(
          children: [
            Expanded(child: _commentsListView(context)),
            Padding(
              padding: EdgeInsets.fromLTRB(15, 0, 15, 15),
              child: TextFormField(
                enabled: _enableComment,
                maxLines: null,
                autofocus: false,
                textInputAction: TextInputAction.send,
                style:
                    TextStyle(color: Colors.black, fontFamily: 'SFUIDisplay'),
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(15),
                  labelText: 'What does this emoji mean to you?',
                  prefixIcon: Icon(Icons.comment),
                  labelStyle: TextStyle(fontSize: 15),
                  border: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(25.0),
                    borderSide: new BorderSide(),
                  ),
                  suffixIcon: Icon(Icons.send),
                ),
                onSaved: (value) {_savecomment(value, snapshot);},
              ),
            ),
          ],
        )),
      ),
    );
  }

  Widget _commentsListView(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.all(0),
      itemBuilder: (context, index) {
        return Card(
          child: ListTile(
            leading: new Image.asset('openmoji618/1F60A.png'),
            title: Text('row $index'),
          ),
        );
      },
    );
  }

  void _savecomment(String comment, DocumentSnapshot snapshot) {
    FirebaseService().saveComment(comment, snapshot.data["unicode"]);
  }

  //Shows Search result
  void showSearchPage(BuildContext context, EmojiSearchDelegate searchDelegate) async {
    
    final DocumentSnapshot selected = await showSearch<DocumentSnapshot>(
      context: context,
      delegate: searchDelegate,
    );

    if (selected != null) {
      String code = selected.data['code'];
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text('Your Word Choice: $code'),
        ),
      );
      setState(() {
        this.snapshot = selected;
      });
    }
  }
}
