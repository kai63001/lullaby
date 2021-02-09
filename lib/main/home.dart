import 'package:Lullaby/main/widget/home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
        splashColor: Colors.transparent,
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
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white);
  List<Widget> _widgetOptions = <Widget>[
    WidgetMain(),
    Text(
      'Index 1: Businessss',
      style: optionStyle,
    ),
    Text(
      'Index 2: School',
      style: optionStyle,
    ),
    Text(
      'Index 2: School',
      style: optionStyle,
    ),
    Text(
      'Index 2: School',
      style: optionStyle,
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  String token = 'asd';

  @override
  void initState() {
    super.initState();
    this._incrementCounter();
  }

  _incrementCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString('token');
    });
  }

  @override
  Widget build(BuildContext context) {
    // FlutterStatusbarcolor.setStatusBarColor(Colors.white);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Color(0xff1e1e2a),
        systemNavigationBarColor: Color(0xff1e1e2a),
        systemNavigationBarIconBrightness: Brightness.dark));
    return Scaffold(
      backgroundColor:
          _selectedIndex != 0 ? Color(0xff1e1e2a) : Color(0xff252736),
      appBar: AppBar(
          brightness: Brightness.dark, // status bar brightness
          backgroundColor: Color(0xff1e1e2a),
          centerTitle: true,
          title: Text(
            widget.title,
            style: TextStyle(color: Colors.white),
          ),
          elevation: 0,
          leading: IconButton(
            icon: Icon(CupertinoIcons.equal),
            onPressed: () {},
          ),
          actions: [
            // action button
            IconButton(
              icon: Icon(CupertinoIcons.bag),
              onPressed: () {},
            ),
          ]),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        currentIndex: _selectedIndex,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: _selectedIndex == 0
                ? Icon(CupertinoIcons.house_alt_fill)
                : Icon(CupertinoIcons.house_alt),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: _selectedIndex == 1
                ? Icon(CupertinoIcons.search)
                : Icon(CupertinoIcons.search),
            label: 'search',
          ),
          BottomNavigationBarItem(
            icon: _selectedIndex == 2
                ? Icon(CupertinoIcons.plus)
                : Icon(CupertinoIcons.plus),
            label: 'add',
          ),
          BottomNavigationBarItem(
            icon: _selectedIndex == 3
                ? Icon(CupertinoIcons.bell_fill)
                : Icon(CupertinoIcons.bell),
            label: 'notification',
          ),
          BottomNavigationBarItem(
            icon: _selectedIndex == 4
                ? Icon(CupertinoIcons.person_fill)
                : Icon(CupertinoIcons.person),
            label: 'profile',
          ),
        ],
        unselectedItemColor: Color(0xff4f4e5d),
        selectedItemColor: Colors.white,
        backgroundColor: Color(0xff1e1e2a),
        onTap: _onItemTapped,
      ),
    );
  }
}
