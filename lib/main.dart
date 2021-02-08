import 'package:Lullaby/auth/login.dart';
import 'package:Lullaby/auth/regsiter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:flutter/services.dart';
import 'package:Lullaby/list/test.dart';

void main() {
  
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lullaby',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'FredokaOne',
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Lullaby'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // String _test = "test";
  // void _incrementCounter() {
  //   setState(() {
  //     _test = "fuck";
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    // FlutterStatusbarcolor.setStatusBarColor(Colors.white);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Color(0xff1e1e2a),
        systemNavigationBarColor: Color(0xff1e1e2a),
        systemNavigationBarIconBrightness: Brightness.dark));
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
            Center(
              child: Image.asset(
                'assets/images/sad.png',
                height: MediaQuery.of(context).size.height * 0.3,
                width: MediaQuery.of(context).size.width * 0.8,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 18.0),
              child: Center(
                  child: Text(
                "Express yourself freely",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 30),
              )),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 18.0),
              child: Text(
                "let me helps you connect to a fun, uplifting, positive, and understanding community, making it easy to share your feelings with people around the world and lift your mood!",
                textAlign: TextAlign.center,
                style: TextStyle(color: Color(0xff999999)),
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Container(
          decoration: new BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                    child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(builder: (context) => Register()),
                    );
                  },
                  child: Container(
                      decoration: new BoxDecoration(
                        color: Color(0xff1e1e2a),
                        borderRadius: BorderRadius.circular(18.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Text(
                          "Register",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white),
                        ),
                      )),
                )),
                Expanded(
                    child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(builder: (context) => Login()),
                    );
                  },
                  child: Container(
                      color: Colors.white,
                      child: Text(
                        "Sign in",
                        textAlign: TextAlign.center,
                      )),
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
