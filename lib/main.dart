import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';

Map<WordPair, bool> wordPairs;

void main() {
  initWordPairs();
  runApp(MyApp());
}

void initWordPairs() {
  final generatedWordPairs = generateWordPairs().take(20);
  wordPairs =
      Map.fromIterable(generatedWordPairs, key: (e) => e, value: (e) => null);
}

///App baseado no tutorial do Flutter disponível em:
///https://codelabs.developers.google.com/codelabs/first-flutter-app-pt1
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App de Listagem - DSI/BSI/UFRPE',
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int pageIndex = 0;
  List<Widget> _pages = [
    RandomWordsListPage(null),
    RandomWordsListPage(true),
    RandomWordsListPage(false)
  ];

  void _changePage(int value) {
    setState(() {
      pageIndex = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('App de Listagem - DSI/BSI/UFRPE'),
      ),
      body: _pages[pageIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: _changePage,
        currentIndex: pageIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.thumb_up_outlined),
            label: 'Liked',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.thumb_down_outlined),
            label: 'Disliked',
          ),
        ],
      ),
    );
  }
}

class RandomWordsListPage extends StatefulWidget {
  final bool _filter;

  RandomWordsListPage(this._filter);

  @override
  _RandomWordsListPageState createState() => _RandomWordsListPageState();
}

///Esta classe é o estado da classe que lista os pares de palavra
///
class _RandomWordsListPageState extends State<RandomWordsListPage> {
  final _icons = {
    null: Icon(Icons.thumbs_up_down_outlined),
    true: Icon(Icons.thumb_up, color: Colors.blue),
    false: Icon(Icons.thumb_down, color: Colors.red),
  };

  Iterable<WordPair> get items {
    if (widget._filter == null) {
      return wordPairs.keys;
    } else {
      //a linha abaixo retorna os pares filtrados pelo filtro
      return wordPairs.entries
          .where((element) => element.value == widget._filter)
          .map((e) => e.key);
    }
  }

  _toggle(WordPair wordPair) {
    bool like = wordPairs[wordPair];
    if (widget._filter != null) {
      wordPairs[wordPair] = null;
    } else if (like == null) {
      wordPairs[wordPair] = true;
    } else if (like == true) {
      wordPairs[wordPair] = false;
    } else {
      wordPairs[wordPair] = null;
    }
    setState(() {});
  }

  String capitalize(String s) {
    return '${s[0].toUpperCase()}${s.substring(1)}';
  }

  String asString(WordPair wordPair) {
    return '${capitalize(wordPair.first)} ${capitalize(wordPair.second)}';
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: items.length * 2,
        itemBuilder: (BuildContext _context, int i) {
          if (i.isOdd) {
            return Divider();
          }
          final int index = i ~/ 2;
          return _buildRow(index + 1, items.elementAt(index));
        });
  }

  Widget refreshBg() {
    return Container(
      alignment: Alignment.centerRight,
      padding: EdgeInsets.only(right: 20.0),
      color: Colors.red,
      child: const Icon(
        Icons.delete,
        color: Colors.white,
      ),
    );
  }

  Widget _buildRow(int index, WordPair wordPair) {
    return Dismissible(
        key: Key(wordPair.toString()),
        direction: DismissDirection.endToStart,
        onDismissed: (direction) {
          Scaffold.of(context).showSnackBar(SnackBar(
            content: Text('${asString(wordPair).toUpperCase()} deletado'),
          ));
          setState(() {
            wordPairs.remove(wordPair);
          });
        },
        background: refreshBg(),
          child: ListTile(
            title: Text('$index. ${asString(wordPair)}'),
            trailing: new Column(
              children: <Widget>[
                new Container(
                  child: new IconButton(
                    icon: _icons[wordPairs[wordPair]],
                    onPressed: () {
                      _toggle(wordPair);
                    },
                  ),
                )
              ],
            ),
          ),
        );
  }
}
