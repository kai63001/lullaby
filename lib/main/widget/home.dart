import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WidgetMain extends StatelessWidget {
  const WidgetMain({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const BouncingScrollPhysics(),
      children: [
        for (var item in [1, 2, 3, 4, 5,7,8,9])
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Container(
                padding:
                    EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 20),
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
                                    "SadBoy SomeTime",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 18),
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        "10 hours ago",
                                        style: TextStyle(
                                            color: Colors.white54,
                                            fontSize: 12),
                                      ),
                                      Text(
                                        " · ",
                                        style: TextStyle(
                                            color: Colors.white54,
                                            fontSize: 12),
                                      ),
                                      Text(
                                        "Sad",
                                        style: TextStyle(
                                            color: Colors.redAccent,
                                            fontSize: 12),
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
                        "Fuck my life",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ))),
          ),
      ],
    );
  }
}
