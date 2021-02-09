class Note {
  int id;
  String title;
  String note;
  String timeline;
  int starred; // 0 - Unstarred, 1 - Starred

  Note({this.title, this.note, this.timeline, this.starred});
  Note.withId({this.id, this.title, this.note, this.timeline, this.starred});

  Map<String, dynamic> toMap() {
    final map = Map<String, dynamic>();
    map['id'] = id;
    map['title'] = title;
    map['note'] = note;
    map['timeline'] = timeline;
    map['starred'] = starred;
    return map;
  }

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note.withId(
        id: map['id'],
        title: map['title'],
        note: map['note'],
        timeline: map['timeline'],
        starred: map['starred']);
  }
}
