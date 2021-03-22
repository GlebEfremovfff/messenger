class Message {
  int _id;
  int _from_bot;
  String _text;

  Message(this._text, this._from_bot);
  Message.withId(this._id, this._text, this._from_bot);

  int get id => _id;
  int get from_bot => _from_bot;
  String get text => _text;

  set setText(String new_text) {
    this._text = new_text;
  }

  set setFromBot(int new_from_bot) {
    this._from_bot = new_from_bot;
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (id != null) {
      map['id'] = _id;
    }
    map['message'] = _text;
    map['fromBot'] = _from_bot;

    return map;
  }

  Message.fromMapObject(Map<String, dynamic> map) {
    this._id = map['id'];
    this._text = map['message'];
    this._from_bot = map['fromBot'];
  }
}
