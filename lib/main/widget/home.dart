import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_moment/simple_moment.dart';

class WidgetMain extends StatefulWidget {
  const WidgetMain({
    Key key,
  }) : super(key: key);

  @override
  _WidgetMainState createState() => _WidgetMainState();
}

class _WidgetMainState extends State<WidgetMain> {
  List data;
  String myUserId;
  Map<String, dynamic> decodedToken;
  bool showGift = false;
  bool containsComment(Object element, String userId) {
    for (var item in element) {
      if (item["userId"] == userId) return true;
    }
    return false;
  }

  _showPopupMenu(Offset offset) async {
    double left = offset.dx;
    double top = offset.dy;
    String selected  = await showMenu(
      context: context,
      position: RelativeRect.fromLTRB(left, top, 0, 0),
      items: [
        PopupMenuItem<String>(child: Text('Delete'), value: 'Delete'),
        // PopupMenuItem<String>(child: const Text('Lion'), value: 'Lion'),
      ],
      elevation: 8.0,
    );
    if(selected == "Delete"){
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
                onPressed: () {
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
    var response = await http
        .get(Uri.encodeFull("http://192.168.33.105:3000/post"), headers: {
      "Accept": "application/json",
      "authorization": prefs.getString("token")
    });

    print("token : " + prefs.getString("token"));

    this.setState(() {
      data = jsonDecode(response.body);
      data = data[0]["data"];
      decodedToken = JwtDecoder.decode(prefs.getString("token"));
    });
    print(decodedToken);
    print("getData on procress");

    return "Success!";
  }

  Future likeSystem(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    decodedToken = JwtDecoder.decode(prefs.getString("token"));
    String postId = data[index]["_id"];
    if (data[index]["likes"].length == 0) {
      setState(() {
        data[index]["likes"].add({"users": []});
        data[index]["likes"][0]["users"].add(decodedToken["id"]);
      });
      await http.get(
          Uri.encodeFull("http://192.168.33.105:3000/post/like/$postId"),
          headers: {
            "Accept": "application/json",
            "authorization": prefs.getString("token")
          });
    } else if (data[index]["likes"][0]["users"].contains(decodedToken["id"])) {
      setState(() {
        data[index]["likes"][0]["users"].removeAt(
            data[index]["likes"][0]["users"].indexOf(decodedToken["id"]));
      });
      await http.get(
          Uri.encodeFull("http://192.168.33.105:3000/post/unlike/$postId"),
          headers: {
            "Accept": "application/json",
            "authorization": prefs.getString("token")
          });
    } else {
      setState(() {
        data[index]["likes"][0]["users"].add(decodedToken["id"]);
      });
      await http.get(
          Uri.encodeFull("http://192.168.33.105:3000/post/like/$postId/update"),
          headers: {
            "Accept": "application/json",
            "authorization": prefs.getString("token")
          });
    }

    print(data[index]["likes"][0]["users"]);
    print(data[index]["likes"][0]["users"].contains(decodedToken["id"]));
  }

  @override
  void initState() {
    super.initState();
    print("test");
    this.getData();
  }

  @override
  Widget build(BuildContext context) {
    // return ListView(
    //   physics: const BouncingScrollPhysics(),
    //   children: [
    //     for (var item in [1, 2, 3, 4, 5, 7, 8, 9]) buildCard(),
    //   ],
    // );
    return data != null
        ? RefreshIndicator(
            // ignore: missing_return
            onRefresh: getData,
            child: Stack(
              children: [
                new ListView.builder(
                    // physics: const BouncingScrollPhysics(),
                    itemCount: data == null ? 0 : data.length,
                    itemBuilder: (BuildContext context, int index) {
                      if (index == 0) {
                        return Column(
                          children: [
                            Container(
                                width: MediaQuery.of(context).size.width,
                                decoration:
                                    new BoxDecoration(color: Color(0xff0B0B0F)),
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      top: 12, left: 20, right: 15, bottom: 12),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.fiber_new_rounded,
                                            color: Colors.white,
                                          ),
                                          Text(" NEW POSTS ",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12)),
                                          Icon(
                                            Icons.keyboard_arrow_down_rounded,
                                            color: Colors.white,
                                          ),
                                        ],
                                      ),
                                      Icon(
                                        Icons.apps_sharp,
                                        color: Colors.white,
                                      ),
                                    ],
                                  ),
                                )),
                            Container(
                              child: buildCard(data[index], index),
                            ),
                          ],
                        );
                      } else {
                        return buildCard(data[index], index);
                      }
                    }),
                showGift
                    ? GestureDetector(
                        onTap: () {
                          print("exit");
                          setState(() {
                            showGift = false;
                          });
                        },
                        child: Container(
                          color: new Color.fromRGBO(0, 0, 0, 0.2),
                          child: GestureDetector(
                            onTap: () {},
                            child: DraggableScrollableSheet(
                              initialChildSize: 0.4,
                              minChildSize: 0.2,
                              maxChildSize: 0.6,
                              builder: (BuildContext context,
                                  ScrollController scrollController) {
                                return Container(
                                  decoration: BoxDecoration(
                                      color: Color(0xff17171f),
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(30),
                                        topRight: Radius.circular(30),
                                      )),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 20.0, left: 20, right: 20),
                                    child: GridView.builder(
                                      controller: scrollController,
                                      itemCount: 25,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return Padding(
                                          padding: const EdgeInsets.all(10),
                                          child: Container(
                                              color: Colors.white,
                                              child: Text('$index')),
                                        );
                                      },
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 5),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      )
                    : Text(''),
              ],
            ),
          )
        : Center(child: CircularProgressIndicator());
  }

  Padding buildCard(data, i) {
    var moment = Moment.now();
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: GestureDetector(
        onTap: () {},
        child: Container(
            padding: EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 10),
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
                                  data["users"][0]["avatar"] == null
                                      ? 'assets/images/avatars/monster.png'
                                      : data["users"][0]["avatar"]),
                            )),
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                data["users"][0]["username"],
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
                              ),
                              Row(
                                children: [
                                  Text(
                                    moment.from(
                                        new DateTime.fromMillisecondsSinceEpoch(
                                            data["date"])),
                                    style: TextStyle(
                                        color: Colors.white54, fontSize: 12),
                                  ),
                                  Text(
                                    " · ",
                                    style: TextStyle(
                                        color: Colors.white54, fontSize: 12),
                                  ),
                                  Text(
                                    data["feel"] == null ? 'sad' : data["feel"],
                                    style: TextStyle(
                                        color: Colors.redAccent, fontSize: 12),
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
                    data["title"],
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
                          likeSystem(i);
                        },
                        child: Container(
                          // color: Color(0xff252736),
                          height: 50,
                          color: Color(0xff252736),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(
                                data["likes"].length > 0
                                    ? (data["likes"][0]["users"]
                                            .contains(decodedToken["id"])
                                        ? CupertinoIcons.heart_fill
                                        : CupertinoIcons.heart)
                                    : CupertinoIcons.heart,
                                color: data["likes"].length > 0
                                    ? (data["likes"][0]["users"]
                                            .contains(decodedToken["id"])
                                        ? Color(0xfff73f71)
                                        : Colors.white30)
                                    : Colors.white30,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 5.0),
                                child: Text(
                                  ' ' +
                                      (data["likes"].length > 0
                                              ? (data["likes"][0]["users"]
                                                          .length ==
                                                      0
                                                  ? ""
                                                  : data["likes"][0]["users"]
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
                            data["comments"].length > 0
                                ? (containsComment(
                                        data["comments"], decodedToken["id"])
                                    ? CupertinoIcons.chat_bubble_fill
                                    : CupertinoIcons.chat_bubble)
                                : CupertinoIcons.chat_bubble,
                            color: data["comments"].length > 0
                                ? (containsComment(
                                        data["comments"], decodedToken["id"])
                                    ? Color(0xff7246ff)
                                    : Colors.white30)
                                : Colors.white30,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 5.0),
                            child: Text(
                              " " +
                                  (data["comments"].length > 0
                                          ? data["comments"].length
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
    );
  }
}
