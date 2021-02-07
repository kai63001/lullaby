import 'package:flutter/material.dart';

Future<void> buildShowDialog(BuildContext context, String text) {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(text,style: TextStyle(fontSize: 20),textAlign: TextAlign.center,),
              Center(
                child: Image.asset(
                  'assets/images/alert.png',
                  height: MediaQuery.of(context).size.height * 0.3,
                  width: MediaQuery.of(context).size.width * 0.8,
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Container(
                  decoration: new BoxDecoration(
                    color: Color(0xff1e1e2a),
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Center(child: Text("Close",style: TextStyle(color: Colors.white),)),
                  ),
                ),
              )
            ],
          ),
        ),
      );
    },
  );
}
