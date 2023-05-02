//Importing the required packages
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

// Importing the required packages (Third Party)
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';

// Starting the main function (App)
void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: '100 Russian Words',
      home: VocabularyList(),
    );
  }
}

// Creating a stateful widget
class VocabularyList extends StatefulWidget {
  const VocabularyList({Key? key});

  // Creating a state
  @override
  _VocabularyListState createState() => _VocabularyListState();
}

// Creating a state class
class _VocabularyListState extends State<VocabularyList> {
  // initialize audio player here
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
    {'russian': 'ты', 'english': 'you', 'audio': '21.mp3'},
    {'russian': 'из', 'english': 'from, of, in', 'audio': '22.mp3'},
    {'russian': 'мы', 'english': 'we', 'audio': '23.mp3'},
    {'russian': 'за', 'english': 'behind, over, at, after', 'audio': '24.mp3'},
    {'russian': 'вы', 'english': 'you', 'audio': '25.mp3'},
    {'russian': 'так', 'english': 'so, thus, then', 'audio': '26.mp3'},
    {'russian': 'же', 'english': 'and, as for, but, same', 'audio': '27.mp3'},
    {'russian': 'от', 'english': 'from, of, for', 'audio': '28.mp3'},
    {'russian': 'сказать', 'english': 'to say, to speak', 'audio': '29.mp3'},
    {'russian': 'э́тот', 'english': 'this', 'audio': '30.mp3'},
  ];

  // List of filtered words
  List<Map<String, String>> filteredWords = [];

  // Search controller
  TextEditingController searchController = TextEditingController();

  // Initializing the state
  // to allow the audio player to play
  @override
  void initState() {
    super.initState();
    audioPlayer = AudioPlayer();
    filteredWords.addAll(allWords);
  }

  // Disposing the state
  // to allow the audio player to dispose
  // (To prevent memory leaks)
  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  // Building the widget (UI)
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
              // Grabbing file from assets folder (Assigned to word)
                  .load('assets/audio/${filteredWords[index]['audio']}');
              final audioPath =
              // Grabbing file from dir then generate temporary dir when loaded to memory
                  '${(await getTemporaryDirectory()).path}/${filteredWords[index]['audio']}';
              // Writing the audio file to the temporary directory
              File(audioPath).writeAsBytesSync(audioFile.buffer.asUint8List());

              // Setting the file path to the audio player
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

// Creating a search delegate
class WordSearch extends SearchDelegate<dynamic> {
  final List<Map<String, String>> words;

  // Constructor
  WordSearch(this.words);

  // Building the search icon ability
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

  // Building the back button
  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, {});
      },
    );
  }

  // Building the results based on the query (Both Russian and English)
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

  // Building the suggestions based on the query (Both Russian and English)
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
