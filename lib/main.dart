import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Russian Vocabulary App',
      home: VocabularyList(),
    );
  }
}

class VocabularyList extends StatefulWidget {
  const VocabularyList({Key? key});

  @override
  _VocabularyListState createState() => _VocabularyListState();
}

class _VocabularyListState extends State<VocabularyList> {
  final List<Map<String, String>> allWords = [
    {'russian': 'Привет', 'english': 'hello'},
    {'russian': 'Спасибо', 'english': 'thank you'},
    {'russian': 'Кошка', 'english': 'cat'},
    {'russian': 'Дерево', 'english': 'tree'},
    {'russian': 'Автобус', 'english': 'bus'},
    // add more words here
  ];

  List<Map<String, String>> filteredWords = [];

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
        title: const Text('Russian Vocabulary List'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.search),
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
            title: Text(filteredWords[index]['russian']!),
            subtitle: Text(filteredWords[index]['english']!),
            onTap: () {
              // add code to play audio file here
            },
          );
        },
      ),
    );
  }
}

class WordSearch extends SearchDelegate<dynamic> {
  final List<Map<String, String>> words;

  WordSearch(this.words);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, {});
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final List<Map<String, String>> results = words.where((word) => word['russian']!.toLowerCase().contains(query.toLowerCase()) || word['english']!.toLowerCase().contains(query.toLowerCase())).toList();
    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          title: Text(results[index]['russian']!),
          subtitle: Text(results[index]['english']!),
          onTap: () {
            close(context, results[index]);
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final List<Map<String, String>> suggestionList = query.isEmpty
        ? words
        : words.where((word) => word['russian']!.toLowerCase().contains(query.toLowerCase()) || word['english']!.toLowerCase().contains(query.toLowerCase())).toList();
    return ListView.builder(
      itemCount: suggestionList.length,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          title: Text(suggestionList[index]['russian']!),
          subtitle: Text(suggestionList[index]['english']!),
          onTap: () {
            close(context, suggestionList[index]);
          },
        );
      },
    );
  }
}

