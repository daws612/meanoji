import 'package:flutter/material.dart';
import 'emoji-search-delegate.dart';

class EmojiDetails extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new EmojiDetailsState();
}

class EmojiDetailsState extends State<EmojiDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              expandedHeight: 400.0,
              floating: false,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                  centerTitle: false,
                  title: Text("Collapsing Toolbar",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                      )),
                  background: Image(
                    image: new AssetImage('openmoji618/1F60A.png'),
                    fit: BoxFit.cover,
                  )),
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    showSearch(
                      context: context,
                      delegate: EmojiSearchDelegate(),
                    );
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
              padding: EdgeInsets.fromLTRB(15,0,15,15),
              child: TextFormField(
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
                onSaved: (value) {},
              ),
            ),
          ],
        )),
      ),
    );
  }

  Widget _commentsListView(BuildContext context) {
    return ListView.builder(
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
}
