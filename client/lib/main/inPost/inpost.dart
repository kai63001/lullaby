import 'dart:convert';

import 'package:Lullaby/components/alert.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_moment/simple_moment.dart';
import 'package:http/http.dart' as http;

class InPost extends StatefulWidget {
  final Map<String, dynamic> data;

  InPost({Key key, @required this.data}) : super(key: key);

  @override
  _InPostState createState() => _InPostState();
}

class _InPostState extends State<InPost> {
  var moment = Moment.now();
  String myUserId;
  String token;
  TextEditingController commentText = new TextEditingController();
  Map<String, dynamic> decodedToken = {
    "id": "asdasd",
    "username": "test",
    "iat": 1612890450921
  };
  bool showGift = false;
  List commentAll = [];
  bool containsComment(Object element, String userId) {
    for (var item in element) {
      if (item["userId"] == userId) return true;
    }
    return false;
  }

  _showPopupMenuComment(Offset offset, i) async {
    double left = offset.dx;
    double top = offset.dy;
    String commentId = i["_id"];
    String selected = await showMenu(
      context: context,
      position: RelativeRect.fromLTRB(left, top, 0, 0),
      items: [
        i["userId"] == decodedToken["id"]
            ? PopupMenuItem<String>(child: Text('Delete'), value: 'Delete')
            : PopupMenuItem<String>(child: Text('Report'), value: 'Report'),
        // PopupMenuItem<String>(child: const Text('Lion'), value: 'Lion'),
      ],
      elevation: 8.0,
    );

    if (selected == "Delete") {
      showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Delete Comment'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('Are you sure you want to delete this comment?'),
                  // Text('Would you like to approve of this message?'),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('Sure'),
                onPressed: () async {
                  // setState(() {
                  //   data.removeAt(index);
                  // });
                  await http.delete(
                      Uri.encodeFull(
                          "http://192.168.33.105:3000/post/$commentId/comment/delete"),
                      headers: {
                        "Accept": "application/json",
                        "authorization": token
                      });
                  this.getCommentData();
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  _showPopupMenu(Offset offset) async {
    print(decodedToken["id"]);
    double left = offset.dx;
    double top = offset.dy;
    String postId = widget.data["_id"];

    String selected = await showMenu(
      context: context,
      position: RelativeRect.fromLTRB(left, top, 0, 0),
      items: [
        widget.data["userId"] == decodedToken["id"]
            ? PopupMenuItem<String>(child: Text('Delete'), value: 'Delete')
            : PopupMenuItem<String>(child: Text('Report'), value: 'Report'),
        // PopupMenuItem<String>(child: const Text('Lion'), value: 'Lion'),
      ],
      elevation: 8.0,
    );
    if (selected == "Delete") {
      showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Delete Post'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('Are you sure you want to delete this post?'),
                  // Text('Would you like to approve of this message?'),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('Sure'),
                onPressed: () async {
                  // setState(() {
                  //   data.removeAt(index);
                  // });
                  await http.delete(
                      Uri.encodeFull("http://192.168.33.105:3000/post/$postId"),
                      headers: {
                        "Accept": "application/json",
                        "authorization": token
                      });

                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  Future<String> getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    this.setState(() {
      decodedToken = JwtDecoder.decode(prefs.getString("token"));
      token = prefs.getString("token");
    });
    print(decodedToken);
    print("getData on procress");
    print(widget.data);
    return "Success!";
  }

  Future likeSystem() async {
    String postId = widget.data["_id"];
    if (widget.data["likes"].length == 0) {
      setState(() {
        widget.data["likes"].add({"users": []});
        widget.data["likes"][0]["users"].add(decodedToken["id"]);
      });
      await http.get(
          Uri.encodeFull("http://192.168.33.105:3000/post/like/$postId"),
          headers: {"Accept": "application/json", "authorization": token});
    } else if (widget.data["likes"][0]["users"].contains(decodedToken["id"])) {
      setState(() {
        widget.data["likes"][0]["users"].removeAt(
            widget.data["likes"][0]["users"].indexOf(decodedToken["id"]));
      });
      await http.get(
          Uri.encodeFull("http://192.168.33.105:3000/post/unlike/$postId"),
          headers: {"Accept": "application/json", "authorization": token});
    } else {
      setState(() {
        widget.data["likes"][0]["users"].add(decodedToken["id"]);
      });
      await http.get(
          Uri.encodeFull("http://192.168.33.105:3000/post/like/$postId/update"),
          headers: {"Accept": "application/json", "authorization": token});
    }

    print(widget.data["likes"][0]["users"]);
    print(widget.data["likes"][0]["users"].contains(decodedToken["id"]));
  }

  Future getCommentData() async {
    String idPost = widget.data["_id"];
    print("idPost : $idPost");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var response = await http.get(
        Uri.encodeFull("http://192.168.33.105:3000/post/$idPost/comment"),
        headers: {
          "Accept": "application/json",
          "authorization": prefs.getString("token")
        });

    print("token : " + prefs.getString("token"));

    this.setState(() {
      commentAll = jsonDecode(response.body);
    });
    print(commentAll);
  }

  Future sendComment() async {
      String postId = widget.data["_id"];
      print(postId);
      if(commentText.text.isEmpty){
        return buildShowDialog(context, 'Please enter comment');
      }else{
        final response = await http.post(
          'http://192.168.33.105:3000/post/$postId/comment',
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            "authorization": token
          },
          body: jsonEncode(<String, String>{
            'comment': commentText.text,
            
          }),
        );
        if (response.statusCode == 200) {
          this.getCommentData();
          commentText.clear();
        } else {
          print(response.body);
        }
      }
  }

  @override
  void initState() {
    super.initState();
    print("test");
    this.getData();
    this.getCommentData();
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
              icon: Icon(CupertinoIcons.bag),
              onPressed: () {},
            ),
          ]),
      // body: _widgetOptions.elementAt(_selectedIndex),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Container(
                padding:
                    EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 10),
                color: Color(0xff252736),
                child: Container(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  color: Color(0xff7549fd),
                                ),
                                width: 50,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Image.asset(
                                      widget.data["users"][0]["avatar"] == null
                                          ? 'assets/images/avatars/monster.png'
                                          : widget.data["users"][0]["avatar"]),
                                )),
                            Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.data["users"][0]["username"],
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 18),
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        moment.from(new DateTime
                                                .fromMillisecondsSinceEpoch(
                                            widget.data["date"])),
                                        style: TextStyle(
                                            color: Colors.white54,
                                            fontSize: 12),
                                      ),
                                      Text(
                                        " · ",
                                        style: TextStyle(
                                            color: Colors.white54,
                                            fontSize: 12),
                                      ),
                                      Text(
                                        widget.data["feel"] == null
                                            ? 'sad'
                                            : widget.data["feel"],
                                        style: TextStyle(
                                            color: widget.data["feelColor"] == null ? Colors.redAccent : Color(widget.data["feelColor"]),
                                            fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTapDown: (TapDownDetails details) {
                            print("showOpp");
                            _showPopupMenu(details.globalPosition);
                          },
                          child: Container(
                            color: Color(0xff252736),
                            height: 50,
                            width: 50,
                            child: Icon(
                              CupertinoIcons.ellipsis_vertical,
                              color: Colors.white,
                            ),
                          ),
                        )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Text(
                        widget.data["title"],
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Row(
                        children: [
                          Expanded(
                              child: GestureDetector(
                            onTap: () {
                              likeSystem();
                            },
                            child: Container(
                              // color: Color(0xff252736),
                              height: 50,
                              color: Color(0xff252736),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Icon(
                                    widget.data["likes"].length > 0
                                        ? (widget.data["likes"][0]["users"]
                                                .contains(decodedToken["id"])
                                            ? CupertinoIcons.heart_fill
                                            : CupertinoIcons.heart)
                                        : CupertinoIcons.heart,
                                    color: widget.data["likes"].length > 0
                                        ? (widget.data["likes"][0]["users"]
                                                .contains(decodedToken["id"])
                                            ? Color(0xfff73f71)
                                            : Colors.white30)
                                        : Colors.white30,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 5.0),
                                    child: Text(
                                      ' ' +
                                          (widget.data["likes"].length > 0
                                                  ? (widget
                                                              .data["likes"][0]
                                                                  ["users"]
                                                              .length ==
                                                          0
                                                      ? ""
                                                      : widget
                                                          .data["likes"][0]
                                                              ["users"]
                                                          .length)
                                                  : "")
                                              .toString(),
                                      style: TextStyle(color: Colors.white30),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          )),
                          Expanded(
                              child: Row(
                            children: [
                              Icon(
                                widget.data["comments"].length > 0
                                    ? (containsComment(widget.data["comments"],
                                            decodedToken["id"])
                                        ? CupertinoIcons.chat_bubble_fill
                                        : CupertinoIcons.chat_bubble)
                                    : CupertinoIcons.chat_bubble,
                                color: widget.data["comments"].length > 0
                                    ? (containsComment(widget.data["comments"],
                                            decodedToken["id"])
                                        ? Color(0xff7246ff)
                                        : Colors.white30)
                                    : Colors.white30,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 5.0),
                                child: Text(
                                  " " +
                                      (widget.data["comments"].length > 0
                                              ? widget.data["comments"].length
                                              : "")
                                          .toString(),
                                  style: TextStyle(color: Colors.white30),
                                ),
                              )
                            ],
                          )),
                          Expanded(
                              child: Container(
                            child: Center(
                                child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  CupertinoIcons.rocket,
                                  color: Colors.white30,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 5.0),
                                  child: Text(
                                    " Boots",
                                    style: TextStyle(color: Colors.white30),
                                  ),
                                )
                              ],
                            )),
                          )),
                          Expanded(
                              child: GestureDetector(
                            onTap: () {
                              setState(() {
                                showGift = !showGift;
                              });
                              print("show gif");
                            },
                            child: Container(
                              color: Color(0xff252736),
                              height: 50,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Icon(
                                    CupertinoIcons.gift,
                                    color: Colors.white30,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 5.0),
                                    child: Text(
                                      " Gift",
                                      style: TextStyle(color: Colors.white30),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          )),
                        ],
                      ),
                    )
                  ],
                ))),
          ),
          // comment
          for (var i in commentAll)
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Container(
                decoration: new BoxDecoration(color: Color(0xff252736)),
                child: Padding(
                  padding:
                      EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    color: Color(0xff7549fd),
                                  ),
                                  width: 50,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Image.asset(i["users"][0]
                                                ["avatar"] ==
                                            null
                                        ? 'assets/images/avatars/monster.png'
                                        : i["users"][0]["avatar"]),
                                  )),
                              Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      i["users"][0]["username"],
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 18),
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          moment.from(new DateTime
                                                  .fromMillisecondsSinceEpoch(
                                              i["date"])),
                                          style: TextStyle(
                                              color: Colors.white54,
                                              fontSize: 12),
                                        ),
                                        // Text(
                                        //   " · ",
                                        //   style: TextStyle(
                                        //       color: Colors.white54,
                                        //       fontSize: 12),
                                        // ),
                                        // Text(
                                        //   widget.data["feel"] == null
                                        //       ? 'sad'
                                        //       : widget.data["feel"],
                                        //   style: TextStyle(
                                        //       color: Colors.redAccent,
                                        //       fontSize: 12),
                                        // ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          GestureDetector(
                            onTapDown: (TapDownDetails details) {
                              print("showOpp");
                              _showPopupMenuComment(details.globalPosition, i);
                            },
                            child: Container(
                              color: Color(0xff252736),
                              height: 50,
                              width: 50,
                              child: Icon(
                                CupertinoIcons.ellipsis_vertical,
                                color: Colors.white,
                              ),
                            ),
                          )
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 15.0, bottom: 15),
                        child: Text(
                          i["comment"],
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
      bottomSheet: Container(
        decoration: BoxDecoration(color: Color(0xff1e1e2a)),
        child: Padding(
          padding: const EdgeInsets.only(top:8.0,bottom: 8),
          child: Row(
            children: [
              // Expanded(
              //   flex: 1,
              //   child: Padding(
              //     padding: const EdgeInsets.all(10.0),
              //     child: Container(
              //         height: 40,
              //         decoration: BoxDecoration(
              //           borderRadius: BorderRadius.circular(100),
              //           color: Color(0xff7549fd),
              //         ),
              //         width: 50,
              //         child: Padding(
              //           padding: const EdgeInsets.all(8.0),
              //           child: Image.asset(
              //               widget.data["users"][0]["avatar"] == null
              //                   ? 'assets/images/avatars/monster.png'
              //                   : widget.data["users"][0]["avatar"]),
              //         )),
              //   ),
              // ),
              Expanded(
                flex: 5,
                child: Padding(
                  padding: const EdgeInsets.only(left:8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Color(0xff3F3F52),
                    ),
                    padding: const EdgeInsets.only(left: 10),
                    child: TextFormField(
                      controller: commentText,
                      // onEditingComplete: () => node.nextFocus()
                      style: TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        fillColor: Colors.white,
                        hintText: 'Add Comment',
                        // prefixIcon: Icon(
                        //   CupertinoIcons.lock_fill,
                        //   color: Color(0xffBEBEBE),
                        // ),
                        hintStyle: TextStyle(color: Color(0xffBEBEBE)),
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
              ),
              Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.only(left:8.0,right: 8),
                    child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Color(0xff111120),
                        ),
                        child: FlatButton(
                          onPressed: () {
                            sendComment();
                          },
                          child: Icon(
                            Icons.send,
                            color: Colors.white,
                          ),
                        )),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
