import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WidgetAdd extends StatefulWidget {
  const WidgetAdd({
    Key key,
  }) : super(key: key);

  @override
  _WidgetAddState createState() => _WidgetAddState();
}

class _WidgetAddState extends State<WidgetAdd> {
  List feel = [{
    "feel": "sad",
    "color": 0xfff82929
  }];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: [
        Center(child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("How do you feel?",style: TextStyle(color: Colors.white,fontSize: 23)),
        )),
        GridView(
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
            ),
            children: [
              for (var i in feel)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: (){
                    
                  },
                  child: Container(
                      decoration: BoxDecoration(
                          // color: Color,
                          border: Border.all(color: Color(i["color"])),
                          borderRadius: BorderRadius.all(Radius.circular(3))),
                      child: Center(child: Text(i["feel"].toUpperCase(),style: TextStyle(color:Color(i["color"])),))),
                ),
              )
            ])
      ],
    );
  }
}
