import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddPost extends StatefulWidget {
  String feel;
  int color;
  AddPost({Key key, @required this.feel, this.color}) : super(key: key);

  @override
  _AddPostState createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  TextEditingController postController = new TextEditingController();

  Future postAdd() async{
    if(postController.text.isEmpty){
      print("empty");
    }else{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      Map<String, dynamic> decodedToken = JwtDecoder.decode(prefs.getString("token"));
      String token = prefs.getString("token");
      final response = await http.post(
          'http://192.168.33.105:3000/post',
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            "authorization": token
          },
          body: jsonEncode(<String, dynamic>{
            'title': postController.text,
            'feel': widget.feel,
            'feelColor': widget.color
          }),
        );
        postController.clear();
        if (response.statusCode == 200) {
          Navigator.of(context).pop();
        } else {
          print(response.body);
        }
    }
  }

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
              icon: Icon(Icons.send_outlined),
              onPressed: () {
                postAdd();
              },
            ),
          ]),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: Container(
                width: MediaQuery.of(context).size.width,
                color: Color(0xff252736),
                child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text.rich(
                      TextSpan(
                        style: TextStyle(color: Colors.white, fontSize: 16),
                        children: [
                          TextSpan(
                            text: 'Your feel is : ',
                          ),
                          TextSpan(
                              text: widget.feel,
                              style: TextStyle(color: Color(widget.color)))
                        ],
                      ),
                    ))),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8),
            child: TextField(
              controller: postController,
              maxLines: null,
              keyboardType: TextInputType.multiline,
              style: TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                border: InputBorder.none,
                fillColor: Colors.white,
                hintText: 'Describe your feelings',
                hintStyle: TextStyle(color: Color(0xffBEBEBE)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}