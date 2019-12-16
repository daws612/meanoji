import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:meanoji/pages/splash.dart';
import 'package:meanoji/services/firebase-service.dart';
import 'package:meanoji/services/meanoji-shared-preferences.dart';
import 'emoji-search-delegate.dart';

class EmojiDetails extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new EmojiDetailsState();
}

class EmojiDetailsState extends State<EmojiDetails>
    with SingleTickerProviderStateMixin {
  DocumentSnapshot snapshot;

  bool _enableComment = false;
  TextEditingController _commentController = new TextEditingController();
  QuerySnapshot comments;

  AnimationController _animecontroller;
  Animation<double> opacityAnim;
  Animation<double> verticalOffsetAnim;

  @override
  void initState() {
    super.initState();
    Future<DocumentSnapshot> snapshot = FirebaseService().getEmoji();
    snapshot.then((value) {
      setState(() {
        this.snapshot = value;
      });
      _fetchEmojiComments();
    });

    MeanojiPreferences.hasUserName().then((status) {
      setState(() {
        _enableComment = status;
      });
    });

    _animecontroller = AnimationController(
        duration: const Duration(milliseconds: 200), vsync: this);
    // _animecontroller.addListener(() {
    //   setState(() {});
    // });
  }

  @override
  void dispose() {
    super.dispose();
    _commentController.dispose();
  }

  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   super.didChangeAppLifecycleState(state);
  //   if (state == AppLifecycleState.paused) {
  //     // went to Background
  //   }
  //   if (state == AppLifecycleState.resumed) {}
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              expandedHeight:
                  MediaQuery.of(context).size.height * 0.24, //240.0,
              floating: false,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  title: Text(
                      snapshot != null
                          ? snapshot.data["code"]
                          : "oops! We do not know.",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.0,
                      )),
                  background: snapshot != null
                      ? Center(
                          child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * 0.2,
                          child: FittedBox(
                            fit: BoxFit.contain,
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
              child: TextField(
                controller: _commentController,
                readOnly: !_enableComment,
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
                  suffixIcon: IconButton(
                    icon: Icon(Icons.send),
                    onPressed: () {
                      _savecomment(_commentController.text, snapshot);
                    },
                  ),
                ),
                onSubmitted: (value) {
                  _savecomment(value, snapshot);
                },
                onTap: () {
                  _showSignupDialog(context);
                },
              ),
            ),
          ],
        )),
      ),
    );
  }

  void _fetchEmojiComments() {
    if (snapshot != null && snapshot.documentID.isNotEmpty) {
      FirebaseService()
          .getCommentsForEmoji(snapshot.documentID)
          .then((comments) {
        setState(() {
          this.comments = comments;
        });
      });
    }
  }

  Widget _commentsListView(BuildContext context) {
    if (comments != null && comments.documents.isNotEmpty) {
      _animecontroller.reset();
      _animecontroller.forward();
      return ListView.builder(
        padding: EdgeInsets.all(0),
        itemCount: comments.documents.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              //leading: new Image.asset('openmoji618/1F60A.png'),
              title: Text(comments.documents[index].data["comment"]),
            ),
          );
          //TODO this animation causes infinite loop
          // var stepTime = 1.0 / comments.documents.length;
          // var animationStart = stepTime * index;
          // var animationEnd = stepTime + animationStart;
          // this.opacityAnim = Tween<double>(begin: 0, end: 1).animate(
          //     CurvedAnimation(
          //         parent: _animecontroller,
          //         curve: Interval(animationStart, animationEnd,
          //             curve: Curves.decelerate)));
          // this.verticalOffsetAnim = Tween<double>(begin: -20, end: 0).animate(
          //     CurvedAnimation(
          //         parent: _animecontroller,
          //         curve: Interval(animationStart, animationEnd,
          //             curve: Curves.decelerate)));
          // return Transform.translate(
          //     offset: Offset(0, verticalOffsetAnim.value),
          //     child: Opacity(
          //         opacity: opacityAnim != null ? opacityAnim.value : 1,
          //         child: Card(
          //           child: ListTile(
          //             //leading: new Image.asset('openmoji618/1F60A.png'),
          //             title: Text(comments.documents[index].data["comment"]),
          //           ),
          //         )));
        },
      );
    } else {
      return Center(child: Text("No comments yet. Be the first one to add!"));
    }
  }

  void _savecomment(String comment, DocumentSnapshot snapshot) {
    FirebaseService()
        .saveComment(comment, snapshot.data["unicode"], snapshot.documentID);
  }

  //Shows Search result
  void showSearchPage(
      BuildContext context, EmojiSearchDelegate searchDelegate) async {
    final DocumentSnapshot selected = await showSearch<DocumentSnapshot>(
      context: context,
      delegate: searchDelegate,
    );

    if (selected != null) {
      setState(() {
        this.snapshot = selected;
        this.comments = null;
      });
      _fetchEmojiComments();
    }
  }

  void _showSignupDialog(BuildContext context) async {
    if (!_enableComment) {
      await SplashState.showIt(context, false).then((val) {
        MeanojiPreferences.hasUserName().then((status) {
          setState(() {
            _enableComment = status;
          });
        });
      });
    }
  }
}
