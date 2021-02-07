import 'package:Lullaby/auth/login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  TextEditingController usernameController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  TextEditingController conpasswordController = new TextEditingController();
  @override
  Widget build(BuildContext context) {

    Future register() async {
      if(passwordController.text != conpasswordController.text){
        return showDialog<void>(
          context: context,
          barrierDismissible: false, // user must tap button!
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Alert'),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    Text('Password not match'),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: Text('Approve'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }else if(usernameController.text.isEmpty || passwordController.text.isEmpty || conpasswordController.text.isEmpty){
        return showDialog<void>(
          context: context,
          barrierDismissible: false, // user must tap button!
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Alert'),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    Text('Please enter username and password'),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: Text('Approve'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }else{
        final response = await http.post(
          'http://192.168.33.105:3000/auth/register',
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            'username': usernameController.text,
            'password': passwordController.text,
            'conpassword': conpasswordController.text
          }),
        );
        if (response.statusCode == 200) {
          if(response.body == "username already exit"){
            return showDialog<void>(
          context: context,
          barrierDismissible: false, // user must tap button!
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Alert'),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    Text('Username already exists'),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: Text('Approve'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
          }else{
            Navigator.of(context).pop();
            Navigator.push(
                      context,
                      CupertinoPageRoute(builder: (context) => Login()),
                    );
          }

          print(response.body);
          print("end");
        } else {
          throw Exception('Failed to load album');
        }
      }

      // final response =
      //     await http.get('https://jsonplaceholder.typicode.com/albums/1');

      // if (response.statusCode == 200) {

      // } else {
      //   throw Exception('Failed to load album');
      // }
    }
    final node = FocusScope.of(context);
    return Scaffold(
      backgroundColor: Color(0xff1e1e2a),
      appBar: AppBar(
        brightness: Brightness.dark, // status bar brightness
        backgroundColor: Color(0xff1e1e2a),
        centerTitle: true,
        // title: Text(widget.title,style: TextStyle(color: Colors.white),),
        elevation: 0,
      ),
      body: Container(
          child: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(30),
        children: [
          Text(
            "Create Account",
            textAlign: TextAlign.left,
            style: TextStyle(color: Colors.white, fontSize: 30),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 18.0),
            child: Text(
              "to get start you connect to a fun, uplifting, positive, and understanding community, making it easy to share your feelings with people around the world",
              style: TextStyle(color: Color(0xff999999)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 50.0),
            child: Container(
              decoration: new BoxDecoration(
                color: Color(0xff17171f),
                border: Border.all(color: Color(0xff373746)),
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 15.0, top: 5, bottom: 5),
                child: TextFormField(
                  controller: usernameController,
                  onEditingComplete: () => node.nextFocus(),
                  style: TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    fillColor: Colors.white,
                    hintText: 'Enter your username',
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
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Container(
              decoration: new BoxDecoration(
                color: Color(0xff17171f),
                border: Border.all(color: Color(0xff373746)),
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 15.0, top: 5, bottom: 5),
                child: TextFormField(
                  controller: passwordController,
                  onEditingComplete: () => node.nextFocus(),
                  enableSuggestions: false,
                  autocorrect: false,
                  obscureText: true,
                  style: TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    fillColor: Colors.white,
                    hintText: 'Password',
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
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Container(
              decoration: new BoxDecoration(
                color: Color(0xff17171f),
                border: Border.all(color: Color(0xff373746)),
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 15.0, top: 5, bottom: 5),
                child: TextFormField(
                  controller: conpasswordController,
                  enableSuggestions: false,
                  autocorrect: false,
                  obscureText: true,
                  style: TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    fillColor: Colors.white,
                    hintText: 'Confirm Password',
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
        ],
      )),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(30.0),
        child: GestureDetector(
          onTap: () {
            register();
          },
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.width * 0.15,
            decoration: new BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Center(
                  child: Text(
                "Create account",
                style: TextStyle(color: Colors.black),
              )),
            ),
          ),
        ),
      ),
    );
  }
}
