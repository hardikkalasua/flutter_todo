import 'package:flutter/material.dart';
import 'package:flutter_todo/helpers/database_helper.dart';
import 'package:flutter_todo/models/note_model.dart';

class AddNoteScreen extends StatefulWidget {
  final Function updateNoteList;
  final Note note;

  const AddNoteScreen({this.updateNoteList, this.note});

  @override
  _AddNoteScreenState createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _note = '';
  String _timeline = '';

  @override
  void initState() {
    super.initState();

    if (widget.note != null) {
      _title = widget.note.title;
      _note = widget.note.note;
      _timeline = widget.note.timeline;
    }
  }

  _handleRecipientsPicker() async {}

  _submit() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      Note note = Note(title: _title, note: _note, timeline: _timeline);
      if (widget.note == null) {
        note.starred = 0;
        DatabaseHelper.instance.insertNote(note);
      } else {
        note.id = widget.note.id;
        note.starred = widget.note.starred;
        DatabaseHelper.instance.updateNote(note);
      }
      widget.updateNoteList();
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Icon(
              Icons.arrow_back,
            )),
        title: widget.note == null ? Text('New Note') : Text('Edit Note'),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 40.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 20.0),
                          child: TextFormField(
                            style: TextStyle(fontSize: 18.0),
                            decoration: InputDecoration(
                                labelText: 'Title',
                                labelStyle: TextStyle(fontSize: 18.0),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                )),
                            validator: (input) => input.trim().isEmpty
                                ? 'Please enter a task title'
                                : null,
                            onSaved: (input) => _title = input,
                            initialValue: _title,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 20.0),
                          child: TextFormField(
                            minLines: 5,
                            maxLines: 5,
                            style: TextStyle(fontSize: 18.0),
                            decoration: InputDecoration(
                                labelText: 'Add a note',
                                labelStyle: TextStyle(fontSize: 18.0),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                )),
                            onSaved: (input) => _note = input,
                            initialValue: _note,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 20.0),
                          child: Row(
                            children: [
                              Expanded(child: Text("Select Timeline")),
                              Expanded(
                                child: TextFormField(
                                  style: TextStyle(fontSize: 18.0),
                                  decoration: InputDecoration(
                                      labelText: '1 Year',
                                      labelStyle: TextStyle(fontSize: 18.0),
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      )),
                                  validator: (input) => input.trim().isEmpty
                                      ? 'Please enter timeline'
                                      : null,
                                  onSaved: (input) => _timeline = input,
                                  initialValue: _timeline,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ElevatedButton.icon(
                              icon: Icon(Icons.cancel_rounded),
                              onPressed: () => Navigator.pop(context),
                              label: Text('CLOSE'),
                              style: ElevatedButton.styleFrom(
                                primary: Colors.red,
                              ),
                            ),
                            ElevatedButton.icon(
                              icon: Icon(Icons.check_circle),
                              onPressed: _submit,
                              label: Text('SAVE'),
                              style: ElevatedButton.styleFrom(
                                primary: Colors.green,
                              ),
                            )
                          ],
                        )
                      ],
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
