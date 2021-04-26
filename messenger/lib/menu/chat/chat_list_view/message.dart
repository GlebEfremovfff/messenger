class Message {
  int _id;
  int _from_bot;
  int _is_button;
  String _text;
  String _photoUrl;
  String _videoUrl;
  String _audioUrl;

  Message(this._text, this._from_bot, this._is_button, this._photoUrl,
      this._videoUrl, this._audioUrl);
  Message.withId(this._id, this._text, this._from_bot, this._is_button,
      this._photoUrl, this._videoUrl, this._audioUrl);

  int get id => _id;
  int get from_bot => _from_bot;
  int get is_button => _is_button;
  String get text => _text;
  String get photoUrl => _photoUrl;
  String get videoUrl => _videoUrl;
  String get audioUrl => _audioUrl;

  set setText(String new_text) {
    this._text = new_text;
  }

  set setPhotoUrl(String new_photoUrl) {
    this._photoUrl = new_photoUrl;
  }

  set setVideoUrl(String new_videoUrl) {
    this._videoUrl = new_videoUrl;
  }

  set setAudioUrl(String new_audioUrl) {
    this._audioUrl = new_audioUrl;
  }

  set setFromBot(int new_from_bot) {
    this._from_bot = new_from_bot;
  }

  set setIsButton(int new_is_button) {
    this._is_button = new_is_button;
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (id != null) {
      map['id'] = _id;
    }
    map['message'] = _text;
    map['fromBot'] = _from_bot;
    map['isButton'] = _is_button;
    map['photoUrl'] = _photoUrl;
    map['videoUrl'] = _videoUrl;
    map['audioUrl'] = _audioUrl;
    return map;
  }

  Message.fromMapObject(Map<String, dynamic> map) {
    this._id = map['id'];
    this._text = map['message'];
    this._from_bot = map['fromBot'];
    this._is_button = map['isButton'];
    this._photoUrl = map['photoUrl'];
    this._videoUrl = map['videoUrl'];
    this._audioUrl = map['audioUrl'];
  }

  Message.fromJsonObject(Map<String, dynamic> map) {
    if (map['text'] != null) {
      this._text = map['text'];
    } else {
      this._text = "";
    }
    if (map['fromBot'] == false) {
      this._from_bot = 0;
    } else {
      this._from_bot = 1;
    }
    this._is_button = 0;
    if (map['photo'] != null) {
      this._photoUrl = map['photo'];
    } else {
      this._photoUrl = "";
    }
    if (map['video'] != null) {
      this._videoUrl = map['video'];
    } else {
      this._videoUrl = "";
    }
    if (map['audio'] != null) {
      this._audioUrl = map['audio'];
    } else {
      this._audioUrl = "";
    }
  }

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message.fromJsonObject(json);
  }
}
