import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class MyProfile extends StatefulWidget {
  @override
  _MyProfileState createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  List data;
  Map<String, dynamic> decodedToken;
  String token;

  @override
  void initState() {
    super.initState();
    getMyProfile();
  }

  Future getMyProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var response = await http
        .get(Uri.encodeFull("http://165.232.169.242:8080/profile"), headers: {
      "Accept": "application/json",
      "authorization": prefs.getString("token")
    });

    print("token : " + prefs.getString("token"));

    this.setState(() {
      data = jsonDecode(response.body);
      decodedToken = JwtDecoder.decode(prefs.getString("token"));
      token = prefs.getString("token");
    });
    print(data);
    print(decodedToken);
    print("getData on procress");

    return "Success!";
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Container(
          color: Color(0xff252736),
          child: Column(
            children: [
              Container(
                height: 160,
                child: Stack(
                  children: [
                    Positioned(
                      child: Container(height: 120, color: Colors.black),
                    ),
                    Positioned(
                      top: 30,
                      left: MediaQuery.of(context).size.width / 2 - 60,
                      child: Center(
                          child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                color: Color(0xff7549fd),
                              ),
                              width: 120,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Image.asset(data == null
                                    ? 'assets/images/avatars/monster.png'
                                    : data[0]["avatar"]),
                              ))),
                    )
                  ],
                ),
              ),
              Center(
                  child: Padding(
                padding: const EdgeInsets.only(bottom: 18.0),
                child: Text(
                  data[0]["username"],
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
              ))
            ],
          ),
        ),
      ],
    );
  }
}
