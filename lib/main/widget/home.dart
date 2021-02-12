import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  Future<String> getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var response = await http
        .get(Uri.encodeFull("http://192.168.33.105:3000/post"), headers: {
      "Accept": "application/json",
      "authorization": prefs.getString("token")
    });

    print("token : "+prefs.getString("token"));

    this.setState(() {
      data = jsonDecode(response.body);
      
      decodedToken = JwtDecoder.decode(prefs.getString("token"));
    });
    // print(decodedToken);


    return "Success!";
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
    return new ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: data == null ? 0 : data.length,
        itemBuilder: (BuildContext context, int index){
          return buildCard(data[index]);
        }
    );
  }

  Padding buildCard(data) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Container(
          padding: EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 20),
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
                                'assets/images/avatars/monster.png'),
                          )),
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              data["users"][0]["username"],
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            ),
                            Row(
                              children: [
                                Text(
                                  "10 hours ago",
                                  style: TextStyle(
                                      color: Colors.white54, fontSize: 12),
                                ),
                                Text(
                                  " · ",
                                  style: TextStyle(
                                      color: Colors.white54, fontSize: 12),
                                ),
                                Text(
                                  "Sad",
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
                  Icon(
                    CupertinoIcons.ellipsis_vertical,
                    color: Colors.white,
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
                        child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(
                          data["likes"].length > 0?(data["likes"][0]["users"].contains(decodedToken["id"]) ? CupertinoIcons.heart_fill:CupertinoIcons.heart): CupertinoIcons.heart,
                          color: data["likes"].length > 0?(data["likes"][0]["users"].contains(decodedToken["id"]) ? Color(0xfff73f71):Colors.white30): Colors.white30,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 5.0),
                          child: Text(
                            ' '+(data["likes"].length > 0?data["likes"][0]["users"].length:"").toString(),
                            style: TextStyle(color: Colors.white30),
                          ),
                        )
                      ],
                    )),
                    Expanded(
                        child: Row(
                      children: [
                        Icon(
                          CupertinoIcons.chat_bubble,
                          color: Colors.white30,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 5.0),
                          child: Text(
                            " 24",
                            style: TextStyle(color: Colors.white30),
                          ),
                        )
                      ],
                    )),
                    Expanded(
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
                    ))),
                    Expanded(
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
                    )),
                  ],
                ),
              )
            ],
          ))),
    );
  }
}