import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddPost extends StatefulWidget {
  String feel;
  AddPost({Key key, @required this.feel}) : super(key: key);

  @override
  _AddPostState createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff17171f),
      appBar: AppBar(
          brightness: Brightness.dark, // status bar brightness
          backgroundColor: Color(0xff1e1e2a),
          centerTitle: true,
          title: Text(
            "Lullaby",
            style: TextStyle(color: Colors.white),
          ),
          elevation: 0,
          actions: [
            // action button
            IconButton(
              icon: Icon(CupertinoIcons.bag),
              onPressed: () {},
            ),
          ]),
      body: Text(widget.feel),
    );
  }
}