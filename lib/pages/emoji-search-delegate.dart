import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EmojiSearchDelegate extends SearchDelegate<DocumentSnapshot> {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query.length < 3) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Text(
              "Search term must be longer than two letters.",
            ),
          )
        ],
      );
    }

    //Add the search term to the searchBloc.
    //The Bloc will then handle the searching and add the results to the searchResults stream.
    //This is the equivalent of submitting the search term to whatever search service you are using
    // InheritedBlocs.of(context).searchBloc.searchTerm.add(query);

    // return Column(
    //   children: <Widget>[
    //     //Build the results based on the searchResults stream in the searchBloc
    //     StreamBuilder(
    //       stream: InheritedBlocs.of(context).searchBloc.searchResults,
    //       builder: (context, AsyncSnapshot<List<Result>> snapshot) {
    //         if (!snapshot.hasData) {
    //           return Column(
    //             crossAxisAlignment: CrossAxisAlignment.center,
    //             mainAxisAlignment: MainAxisAlignment.center,
    //             children: <Widget>[
    //               Center(child: CircularProgressIndicator()),
    //             ],
    //           );
    //         } else if (snapshot.data.length == 0) {
    //           return Column(
    //             children: <Widget>[
    //               Text(
    //                 "No Results Found.",
    //               ),
    //             ],
    //           );
    //         } else {
    //           var results = snapshot.data;
    //           return ListView.builder(
    //             itemCount: results.length,
    //             itemBuilder: (context, index) {
    //               var result = results[index];
    //               return ListTile(
    //                 title: Text(result.title),
    //               );
    //             },
    //           );
    //         }
    //       },
    //     ),
    //   ],
    // );
    return Column();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('emojis').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return new Text('Loading...');

        final results = snapshot.data.documents.where(
            (DocumentSnapshot a) => a.data()['moji'].toString().contains(query) || a.data()['base'].toString().contains(query));

        
        return ListView(
          children: results
              .map<Widget>((a) => ListTile(
                leading: Text(a.data()['moji'].toString(), style: TextStyle(fontSize: 28),),
                title: Text(a.data()['code'].toString()),
                onTap: () {
                    print(a.data()['code'].toString());
                    //_getEmojiDetails(a);
                    this.close(context, a);
                  },
              )).toList(),
        );
      },
    );
  }

  @override
  ThemeData appBarTheme(BuildContext context) {
    assert(context != null);
    final ThemeData theme = Theme.of(context);
    assert(theme != null);
    return theme.copyWith(
        inputDecorationTheme: InputDecorationTheme(
            hintStyle: TextStyle(color: theme.primaryTextTheme.headline6.color)),
        primaryColor: theme.primaryColor,
        primaryIconTheme: theme.primaryIconTheme,
        primaryColorBrightness: theme.primaryColorBrightness,
        primaryTextTheme: theme.primaryTextTheme,
        textTheme: theme.textTheme.copyWith(
            headline6: theme.textTheme.headline6
                .copyWith(color: theme.primaryTextTheme.headline6.color)));
  }

  _getEmojiDetails(DocumentSnapshot a) {
    //FirebaseService().getEmojiDetails(a); I already have the object itself
    
  }
}
