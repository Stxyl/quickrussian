import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Russian Vocabulary App',
      home: VocabularyList(),
    );
  }
}

class VocabularyList extends StatefulWidget {
  @override
  _VocabularyListState createState() => _VocabularyListState();
}

class _VocabularyListState extends State<VocabularyList> {
  final List<String> allWords = [
    'Привет', // hello
    'Спасибо', // thank you
    'Кошка', // cat
    'Дерево', // tree
    'Автобус', // bus
    // add more words here
  ];

  List<String> filteredWords = [];

  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredWords.addAll(allWords);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Russian Vocabulary List'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(context: context, delegate: WordSearch(filteredWords));
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: filteredWords.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Text(filteredWords[index]),
            onTap: () {
              // add code to play audio file here
            },
          );
        },
      ),
    );
  }
}

class WordSearch extends SearchDelegate<String> {
  final List<String> words;

  WordSearch(this.words);

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
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final List<String> results = words.where((word) => word.toLowerCase().contains(query.toLowerCase())).toList();
    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          title: Text(results[index]),
          onTap: () {
            close(context, results[index]);
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final List<String> suggestionList = query.isEmpty
        ? words
        : words.where((word) => word.toLowerCase().contains(query.toLowerCase())).toList();
    return ListView.builder(
      itemCount: suggestionList.length,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          title: Text(suggestionList[index]),
          onTap: () {
            close(context, suggestionList[index]);
          },
        );
      },
    );
  }
}
