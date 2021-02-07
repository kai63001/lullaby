import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
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
            "Let's sign you in",
            textAlign: TextAlign.left,
            style: TextStyle(color: Colors.white, fontSize: 30),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 18.0),
            child: Text(
              "Welcome back \nYou've been missed!!",
              style: TextStyle(color: Colors.white,fontSize: 25),
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
                  // controller: usernameController,
                  onEditingComplete: () => node.nextFocus(),
                  style: TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    fillColor: Colors.white,
                    hintText: 'Username',
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
                  // controller: passwordController,
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
          )
        ],
      )),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(30.0),
        child: GestureDetector(
          onTap: () {
            // register();
          },
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.height * 0.08,
            decoration: new BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Center(
                  child: Text(
                "Sign In",
                style: TextStyle(color: Colors.black),
              )),
            ),
          ),
        ),
      ),
    );;
  }
}