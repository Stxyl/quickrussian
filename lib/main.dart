import 'dart:io';

import 'package:flutter/material.dart';

import 'package:flutter/services.dart' show rootBundle;
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';

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
  // add code to initialize audio player here
  AudioPlayer audioPlayer = AudioPlayer();

  // List of words (With audio linked)
  final List<Map<String, String>> allWords = [
    {'russian': 'и', 'english': 'and', 'audio': '1.mp3'},
    {'russian': 'в', 'english': 'in, at', 'audio': '2.mp3'},
    {'russian': 'не', 'english': 'not', 'audio': '3.mp3'},
    {'russian': 'он', 'english': 'he', 'audio': '4.mp3'},
    {'russian': 'на', 'english': 'on, it, at, to', 'audio': '5.mp3'},
    {'russian': 'я', 'english': 'I', 'audio': '6.mp3'},
    {'russian': 'что', 'english': 'that, why', 'audio': '7.mp3'},
    {'russian': 'тот', 'english': 'that', 'audio': '8.mp3'},
    {'russian': 'быть', 'english': 'to be', 'audio': '9.mp3'},
    {'russian': 'с', 'english': 'with', 'audio': '10.mp3'},
    {'russian': 'а', 'english': 'while, and, but', 'audio': '11.mp3'},
    {'russian': 'весь', 'english': 'all, everything', 'audio': '12.mp3'},
    {'russian': 'э́то', 'english': 'that, this, it', 'audio': '13.mp3'},
    {'russian': 'как', 'english': 'how, what, as, like', 'audio': '14.mp3'},
    {'russian': 'она', 'english': 'she', 'audio': '15.mp3'},
    {'russian': 'по', 'english': 'on, along, by', 'audio': '16.mp3'},
    {'russian': 'но', 'english': 'but', 'audio': '17.mp3'},
    {'russian': 'они', 'english': 'they', 'audio': '18.mp3'},
    {'russian': 'к', 'english': 'to, for, by', 'audio': '19.mp3'},
    {'russian': 'у', 'english': 'by, with, of', 'audio': '20.mp3'},
    // add more words here
  ];

  List<Map<String, String>> filteredWords = [];

  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    audioPlayer = AudioPlayer();
    filteredWords.addAll(allWords);
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
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
            onTap: () async {
              // add code to play audio file here
              final audioFile = await rootBundle
                  .load('assets/audio/${filteredWords[index]['audio']}');
              final audioPath =
                  '${(await getTemporaryDirectory()).path}/${filteredWords[index]['audio']}';
              File(audioPath).writeAsBytesSync(audioFile.buffer.asUint8List());

              await audioPlayer.setFilePath(audioPath);

              // Play Audio here
              audioPlayer.play();
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
    final List<Map<String, String>> results = words
        .where((word) =>
            word['russian']!.toLowerCase().contains(query.toLowerCase()) ||
            word['english']!.toLowerCase().contains(query.toLowerCase()))
        .toList();
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
        : words
            .where((word) =>
                word['russian']!.toLowerCase().contains(query.toLowerCase()) ||
                word['english']!.toLowerCase().contains(query.toLowerCase()))
            .toList();
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
