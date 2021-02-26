import 'package:Lullaby/main/inPost/inpost.dart';
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

class _WidgetMainState extends State<WidgetMain>
    with SingleTickerProviderStateMixin {
  List data;
  String myUserId;
  String token;
  Map<String, dynamic> decodedToken;
  AnimationController controller;
  Duration duration = Duration(milliseconds: 500);
  Tween<Offset> tween = Tween(begin: Offset(0, 1), end: Offset(0, 0));
  bool showGift = false;
  var scrollController = ScrollController();
  bool containsComment(Object element, String userId) {
    for (var item in element) {
      if (item["userId"] == userId) return true;
    }
    return false;
  }

  _showPopupMenu(Offset offset, int index) async {
    print(data[index]["userId"]);
    print(decodedToken["id"]);
    double left = offset.dx;
    double top = offset.dy;
    String postId = data[index]["_id"];

    String selected = await showMenu(
      context: context,
      position: RelativeRect.fromLTRB(left, top, 0, 0),
      items: [
        data[index]["userId"] == decodedToken["id"]
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
                  setState(() {
                    data.removeAt(index);
                  });
                  await http.delete(
                      Uri.encodeFull("http://192.168.33.105:3000/post/$postId"),
                      headers: {
                        "Accept": "application/json",
                        "authorization": token
                      });

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
      token = prefs.getString("token");
    });
    print(decodedToken);
    print("getData on procress");

    return "Success!";
  }

  Future likeSystem(int index) async {
    String postId = data[index]["_id"];
    if (data[index]["likes"].length == 0) {
      setState(() {
        data[index]["likes"].add({"users": []});
        data[index]["likes"][0]["users"].add(decodedToken["id"]);
      });
      await http.get(
          Uri.encodeFull("http://192.168.33.105:3000/post/like/$postId"),
          headers: {"Accept": "application/json", "authorization": token});
    } else if (data[index]["likes"][0]["users"].contains(decodedToken["id"])) {
      setState(() {
        data[index]["likes"][0]["users"].removeAt(
            data[index]["likes"][0]["users"].indexOf(decodedToken["id"]));
      });
      await http.get(
          Uri.encodeFull("http://192.168.33.105:3000/post/unlike/$postId"),
          headers: {"Accept": "application/json", "authorization": token});
    } else {
      setState(() {
        data[index]["likes"][0]["users"].add(decodedToken["id"]);
      });
      await http.get(
          Uri.encodeFull("http://192.168.33.105:3000/post/like/$postId/update"),
          headers: {"Accept": "application/json", "authorization": token});
    }

    print(data[index]["likes"][0]["users"]);
    print(data[index]["likes"][0]["users"].contains(decodedToken["id"]));
  }

  Future<String> nextData() async {
    int page = data[data.length - 1]["date"];
    print("data 1 :${data.length}");
    var response = await http.get(
        Uri.encodeFull("http://192.168.33.105:3000/post?page=$page"),
        headers: {"Accept": "application/json", "authorization": token});

    this.setState(() {
      List data2 = jsonDecode(response.body);
      data.addAll(data2[0]["data"]);
      // data = [...data]
      
    });
    print("data 2 :${data.length}");
    print(page);
    print("mextData on procress");

    return "Success!";
  }

  @override
  void initState() {
    super.initState();
    print("test");
    this.getData();
    controller = AnimationController(duration: duration, vsync: this);
    scrollController.addListener(() {
      if (scrollController.position.atEdge) {
        if (scrollController.position.pixels == 0) {
          print("ontop");
        } else {
          nextData();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (data != null) {
      return RefreshIndicator(
        // ignore: missing_return
        onRefresh: getData,
        child: Stack(
          children: [
            new ListView.builder(
                controller: scrollController,
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
            if (showGift == true)
              Positioned.fill(
                child: GestureDetector(
                  onTap: () {
                    print(controller.status);
                    if (controller.isDismissed) {
                      controller.forward();
                      setState(() {
                        showGift = true;
                      });
                      print("show model");
                    } else if (controller.isCompleted) {
                      controller.reverse();
                      print("hide model");
                      setState(() {
                        showGift = false;
                      });
                    }
                  },
                  child: Container(
                    color: Color.fromRGBO(0, 0, 0, 0.5),
                  ),
                ),
              )
            else
              Container(),
            Container(
              child: SlideTransition(
                position: tween.animate(controller),
                child: DraggableScrollableSheet(
                  initialChildSize: 0.3,
                  minChildSize: 0.3,
                  maxChildSize: 0.8,
                  builder: (BuildContext context,
                      ScrollController scrollController) {
                    return Container(
                      decoration: BoxDecoration(
                          color: Color(0xff1e1e2a),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30),
                          )),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Color.fromRGBO(255, 255, 255, 0.2),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(100))),
                              width: 100,
                              height: 4,
                            ),
                          ),
                          Container(
                              child: Padding(
                            padding:
                                const EdgeInsets.only(left: 20.0, right: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Gifts",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20)),
                                Container(
                                  decoration: BoxDecoration(
                                      color: Color(0xff6B6B88),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(100))),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        Text.rich(
                                          TextSpan(
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16),
                                            children: [
                                              WidgetSpan(
                                                child: Icon(
                                                  CupertinoIcons
                                                      .bitcoin_circle_fill,
                                                  color: Color(0xffFFD700),
                                                ),
                                              ),
                                              TextSpan(
                                                text: ' Coin : 0 ',
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          )),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 20.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border(
                                      top: BorderSide(
                                          color: Color.fromRGBO(
                                              255, 255, 255, 0.05),
                                          width: 1)),
                                ),
                                child: GridView.builder(
                                    padding: const EdgeInsets.all(10),
                                    controller: scrollController,
                                    itemCount: 25,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                            decoration: BoxDecoration(
                                                color: Color(0xff6B6B88),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(100))),
                                            child: Center(
                                                child: Text('Item $index'))),
                                      );
                                    },
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 5,
                                    )),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      return Center(child: CircularProgressIndicator());
    }
  }

  Padding buildCard(data, i) {
    var moment = Moment.now();
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (context) => InPost(data: data),
            ),
          );
        },
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
                                        color: data["feelColor"] == null
                                            ? Colors.redAccent
                                            : Color(data["feelColor"]),
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
                        _showPopupMenu(details.globalPosition, i);
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
                    data["title"] == null ? "" : data["title"],
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
                          print(controller.status);
                          if (controller.isDismissed) {
                            controller.forward();
                            setState(() {
                              showGift = true;
                            });
                            print("show model");
                          } else if (controller.isCompleted) {
                            controller.reverse();
                            print("hide model");
                            setState(() {
                              showGift = false;
                            });
                          }
                        },
                        child: Container(
                          color: Color(0xff252736),
                          // color: Colors.red,
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
