import 'package:flutter/material.dart';
import 'package:flutter_todo/helpers/database_helper.dart';
import 'package:flutter_todo/models/note_model.dart';

import 'add_note_screen.dart';

class NoteListScreen extends StatefulWidget {
  @override
  _NoteListScreenState createState() => _NoteListScreenState();
}

class _NoteListScreenState extends State<NoteListScreen> {
  Future<List<Note>> _noteList;

  @override
  void initState() {
    super.initState();
    _updateNoteList();
  }

  _updateNoteList() {
    setState(() {
      _noteList = DatabaseHelper.instance.getNoteList();
    });
  }

  Widget _buildNote(Note note) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        child: ListTile(
          title: Padding(
            padding: const EdgeInsets.only(bottom: 5.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 5.0),
                  child: Text(note.title,
                      style: TextStyle(
                        fontSize: 26.0,
                      )),
                ),
                Text(note.title)
              ],
            ),
          ),
          subtitle: Text(note.note),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: Text(
                  note.timeline,
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              Expanded(
                child: IconButton(
                  onPressed: () {
                    note.starred = note.starred == 0 ? 1 : 0;
                    DatabaseHelper.instance.updateNote(note);
                    _updateNoteList();
                  },
                  color: Theme.of(context).accentColor,
                  icon: note.starred == 1
                      ? Icon(Icons.star)
                      : Icon(Icons.star_border),
                ),
              ),
            ],
          ),
          onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => AddNoteScreen(
                      updateNoteList: _updateNoteList, note: note))),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notes'),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        child: Icon(Icons.add),
        onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => AddNoteScreen(
                      updateNoteList: _updateNoteList,
                    ))),
      ),
      body: FutureBuilder(
        future: _noteList,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          return ListView.separated(
            scrollDirection: Axis.vertical,
            padding: EdgeInsets.symmetric(vertical: 10.0),
            itemCount: snapshot.data.length,
            itemBuilder: (BuildContext context, int index) {
              return _buildNote(snapshot.data[index]);
            },
            separatorBuilder: (context, index) {
              return Divider();
            },
          );
        },
      ),
    );
  }
}
