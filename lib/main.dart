import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Text Editor App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TextEditorScreen(),
    );
  }
}

class TextEditorScreen extends StatefulWidget {
  @override
  _TextEditorScreenState createState() => _TextEditorScreenState();
}

class _TextEditorScreenState extends State<TextEditorScreen> {
  final TextEditingController _controller = TextEditingController();
  double _fontSize = 16.0;
  String _fontFamily = 'Lato';

  List<String> _textHistory = [];
  int _historyIndex = -1;

  void _addHistory(String text) {
    if (_historyIndex == -1 || _textHistory[_historyIndex] != text) {
      _textHistory = _textHistory.sublist(0, _historyIndex + 1);
      _textHistory.add(text);
      _historyIndex++;
    }
  }

  void _undo() {
    if (_historyIndex > 0) {
      _historyIndex--;
      _controller.text = _textHistory[_historyIndex];
      _controller.selection = TextSelection.fromPosition(
        TextPosition(offset: _controller.text.length),
      );
    }
  }

  void _redo() {
    if (_historyIndex < _textHistory.length - 1) {
      _historyIndex++;
      _controller.text = _textHistory[_historyIndex];
      _controller.selection = TextSelection.fromPosition(
        TextPosition(offset: _controller.text.length),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      _addHistory(_controller.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Text Editor App'),
        actions: [
          IconButton(
            icon: Icon(Icons.undo),
            onPressed: _undo,
          ),
          IconButton(
            icon: Icon(Icons.redo),
            onPressed: _redo,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Text('Font Size:'),
                Slider(
                  value: _fontSize,
                  min: 10,
                  max: 50,
                  divisions: 8,
                  label: _fontSize.round().toString(),
                  onChanged: (double value) {
                    setState(() {
                      _fontSize = value;
                    });
                  },
                ),
              ],
            ),
            Row(
              children: [
                Text('Font Family:'),
                SizedBox(width: 10),
                DropdownButton<String>(
                  value: _fontFamily,
                  onChanged: (String? newValue) {
                    setState(() {
                      _fontFamily = newValue!;
                    });
                  },
                  items: <String>[
                    'Lato',
                    'OPPOSans',
                    'Roboto'
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ],
            ),
            Expanded(
              child: TextField(
                controller: _controller,
                maxLines: null,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter your text here...',
                ),
                style: TextStyle(
                  fontFamily: _fontFamily,
                  fontSize: _fontSize,
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                print('Text: ${_controller.text}');
              },
              child: Text('Print Text'),
            ),
          ],
        ),
      ),
    );
  }
}
