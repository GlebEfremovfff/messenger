import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class AudioBox extends StatefulWidget {
  String url;
  AudioBox({this.url, Key key}) : super(key: key);

  @override
  _AudioBoxState createState() => _AudioBoxState();
}

class _AudioBoxState extends State<AudioBox> {
  bool playing = false;
  IconData playBtn = Icons.play_arrow;
  AudioPlayer _player;
  AudioCache cashe;
  int position = 0;
  int musicLength = 0;

  Widget MusicSlider() {
    return Container(
      width: 50,
      child: Slider.adaptive(
        activeColor: Colors.blue[800],
        inactiveColor: Colors.blue[350],
        value: position.toDouble(),
        onChanged: (value) {
          seekToSec(value.toInt());
        },
      ),
    );
  }

  void seekToSec(int sec) {
    Duration newPos = Duration(seconds: sec);
    _player.seek(newPos);
  }

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();
    cashe = AudioCache(fixedPlayer: _player);
    _player.getDuration().then((value) {
      setState(() {
        musicLength = value;
      });
    });
    _player.getCurrentPosition().then((value) {
      setState(() {
        position = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[850],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "${position ~/ 60}:${position % 60}",
                  style: TextStyle(fontSize: 10),
                ),
                MusicSlider(),
                Text(
                  "${musicLength ~/ 60}:${musicLength % 60}",
                  style: TextStyle(fontSize: 10),
                ),
              ],
            ),
          ),
          Center(
            child: IconButton(
              icon: Icon(playBtn),
              iconSize: 3,
              color: Colors.blue[800],
              onPressed: () {
                if (!playing) {
                  cashe.play(widget.url);
                  setState(() {
                    playBtn = Icons.pause;
                    playing = true;
                  });
                } else {
                  _player.pause();
                  setState(() {
                    playBtn = Icons.play_arrow;
                    playing = false;
                  });
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
