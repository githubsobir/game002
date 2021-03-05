import 'dart:math';
import 'dart:ui';

import 'package:audioplayers/audio_cache.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final Map<String, bool> score = {};
  final Map<String, Color> choices = {
    "🍎": Colors.red,
    "🥒": Colors.green,
    "🍆": Colors.blue,
    "🍋": Colors.yellow,
    "🍊": Colors.orange,
    "🍇": Colors.purple,
    "🥝": Colors.brown,

  };

  int index = 0;
  var play = AudioCache();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Simple game"),
        centerTitle: true,
      ),
      body: Row(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: choices.keys.map((element) {
              return Expanded(
                child: Draggable<String>(
                  data: element,
                  child: Movable(
                    emoji: element,
                  ),
                  feedback: Movable(
                    emoji: element,
                  ),
                  childWhenDragging: Movable(
                    emoji: '😊',
                  ),
                ),
              );
            }).toList(),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: choices.keys.map((element) {
              return buildTarget(element);
            }).toList()
              ..shuffle(Random(index)),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(onPressed:(){

        setState(() {
          score.clear();
          index++;

        });

      },
      child: Icon(Icons.refresh),
      ),
    );
  }

  Widget buildTarget(emoji) {
    return DragTarget<String>(builder: (context, incoming, rejects) {
      if (score[emoji] == true) {
        return Container(
          color: Colors.white,
          child: Text("congratulations !"),
          alignment: Alignment.center,
          height: 80,
          width: 200,
        );
      } else {
        return Container(
          color: choices[emoji],
          height: 80,
          width: 200,
        );
      }
    },
      onWillAccept: (data) => data == emoji,
      onAccept: (data) {
        setState(() {
          score[emoji] = true;
          play.play("sound.mp3");
        });
      },

      onLeave: (data){

      },
    );
  }
}

class Movable extends StatelessWidget {
  final String emoji;

  Movable({this.emoji});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        alignment: Alignment.center,
        height: 101,
        padding: EdgeInsets.all(10),
        child: Text(
          emoji,
          style: TextStyle(color: Colors.black, fontSize: 60),
        ),
      ),
    );
  }
}
