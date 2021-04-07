class Message {
  int _id;
  int _from_bot;
  int _is_button;
  int _is_visible;
  String _text;

  Message(this._text, this._from_bot, this._is_button, this._is_visible);
  Message.withId(
      this._id, this._text, this._from_bot, this._is_button, this._is_visible);

  int get id => _id;
  int get from_bot => _from_bot;
  int get is_button => _is_button;
  int get is_visible => _is_visible;
  String get text => _text;

  set setText(String new_text) {
    this._text = new_text;
  }

  set setFromBot(int new_from_bot) {
    this._from_bot = new_from_bot;
  }

  set setIsButton(int new_is_button) {
    this._is_button = new_is_button;
  }

  set setIsVisible(int new_is_visible) {
    this._is_visible = new_is_visible;
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (id != null) {
      map['id'] = _id;
    }
    map['message'] = _text;
    map['fromBot'] = _from_bot;
    map['isButton'] = _is_button;
    map['isVisible'] = _is_visible;
    return map;
  }

  Message.fromMapObject(Map<String, dynamic> map) {
    this._id = map['id'];
    this._text = map['message'];
    this._from_bot = map['fromBot'];
    this._is_button = map['isButton'];
    this._is_visible = map['isVisible'];
  }

  Message.fromJsonObject(Map<String, dynamic> map) {
    this._text = map['text'];
    if (map['fromBot'] == false) {
      this._from_bot = 0;
    } else {
      this._from_bot = 1;
    }

    this._is_button = 0;

    this._is_visible = 1;
  }

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message.fromJsonObject(json);
  }
}
