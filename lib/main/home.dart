import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

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
        child: Text("fuck")
      ),
      
    );
  }
}
