import 'dart:async';
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:nonutnovember/db.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'No Nut November',
      theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      home: NoNutNov(),
    );
  }
}

class NoNutNov extends StatefulWidget {
  @override
  _NoNutNovState createState() => _NoNutNovState();
}

class _NoNutNovState extends State<NoNutNov> with WidgetsBindingObserver {

  Timer _timer;
  int seconds = 0;
  int minutes = 0;
  int hours = 0;
  int days = 0;
  int secmod;
  int minmod;
  int hourmod;

  var DetachedTime;
  var BackTime;

  final dbHelper = DatabaseHelper.instance;

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
          (Timer timer) => setState(
            () {
          if (seconds < 0) {
            timer.cancel();
          } else {
            seconds = seconds + 1;
            if (seconds > 59) {

              secmod = seconds % 60;
              seconds = (seconds / 60) as int;
              minutes += secmod;

              if (minutes > 59) {
                minmod = minutes % 60;
                minutes = (minutes / 60) as int;
                hours += minmod;

                if(hours > 23)  {
                  hourmod = hours % 60;
                  hours = (hours / 60) as int;
                  days += hourmod;
                  if(days == 30)  {
                    timer.cancel();
                  }
                }
              }
            }
          }
        },
      ),
    );
  }

  Expanded nnn_title({Widget widget , int flex}){
    return Expanded(
      flex: flex,
      child: widget,
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    startTimer();

    WidgetsBinding.instance.addObserver(this);
    DateTime initTime = DateTime.now();
    print("initTime:");
    print(initTime);

    insert(initTime.toString(), initTime.toString());


    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose

    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // TODO: implement didChangeAppLifecycleState
    super.didChangeAppLifecycleState(state);

    if(state == AppLifecycleState.resumed)
    {
        DateTime now = DateTime.now();
        DateTime resumedTime = new DateTime(now.year, now.month, now.day, now.hour, now.minute);
        BackTime = resumedTime;

        var difference = BackTime(DetachedTime).inSeconds();
        print("Difference is " + difference);
        seconds += difference;
        print("Resumed");
    }
    else if(state == AppLifecycleState.inactive)
    {
      print("Inactive");
    }
    else if(state == AppLifecycleState.detached)
    {
      DateTime now = DateTime.now();
      print("curr:");
      print(now);

      DateTime currentTime = new DateTime(now.year, now.month, now.day, now.hour, now.minute);
      DetachedTime = currentTime;

      print("Detached");
    }
    else if(state == AppLifecycleState.paused)
    {

      print("Paused");
    }
  }

  void insert(String Dtime, String Rtime) async
  {
    Map<String, dynamic> row = {
      DatabaseHelper.columnExit : Dtime,
      DatabaseHelper.columnInit  : Rtime,
    };
    final id = await dbHelper.insert(row);
    print('inserted row id: $id');
  }

  void update() async
  {
    Map<String, dynamic> row = {
      DatabaseHelper.columnID   : 1,
      DatabaseHelper.columnExit : 'Mary',
      DatabaseHelper.columnInit  : 32
    };
    final rowsAffected = await dbHelper.update(row);
    print('updated $rowsAffected row(s)');
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/nnn.jpg'),
                fit: BoxFit.cover,
              )
          ),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: <Widget>[
                    nnn_title(
                      flex: 7,
                      widget: Text(
                        "No Nut November",
                        style: TextStyle(
                          fontSize: 20.0,
                        ),
                      ),
                    ),

                    nnn_title(
                      flex: 1,
                      widget: Icon(
                        Icons.image,
                      ),
                    ),

                    nnn_title(
                      flex: 1,
                      widget: Icon(
                        Icons.more_vert,
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(
                  120,
                  30,
                  120,
                  40,
                ),
                child: RaisedButton(
                  color: Colors.blueGrey[300],
                  onPressed: () {},
                  child: Container(
                    margin: EdgeInsets.all(15.0),
                    child: Text(
                      "Apprentice",
                    ),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
              ),

              Stack(
                children: <Widget>[
                  Opacity(
                    opacity: 0.7,
                    child: Container(
                      height: 350.0,
                      decoration: BoxDecoration(
                        color: Colors.blueGrey[500],
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),

                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 35.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[

                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Text(
                              "It has been",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 25.0,
                              ),
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.only(bottom: 20.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[

                                Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Text(
                                    days.toString(),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 50.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),

                                Padding(
                                  padding: const EdgeInsets.only(right: 22.0),
                                  child: Text(
                                    "days",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 40.0,
                                    ),
                                  ),
                                ),

                              ],
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[

                                Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                    10.0,
                                    0.0,
                                    30.0,
                                    0.0,
                                  ),
                                  child: Text(
                                    hours.toString(),
                                    style: TextStyle(
                                      fontSize: 25.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),

                                Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                    6.0,
                                    0.0,
                                    40.0,
                                    0.0,
                                  ),
                                  child: Text(
                                    minutes.toString(),
                                    style: TextStyle(
                                      fontSize: 25.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),

                                Padding(
                                  padding: const EdgeInsets.fromLTRB(6.0, 0.0, 20.0, 0.0),
                                  child: Text(
                                    seconds.toString(),
                                    style: TextStyle(
                                      fontSize: 25.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),

                              ],
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[

                                Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                    0.0,
                                    0.0,
                                    25.0,
                                    0.0,
                                  ),
                                  child: Text(
                                    "Hours",
                                    style: TextStyle(
                                      fontSize: 13.0,
                                    ),
                                  ),
                                ),

                                Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                    0.0,
                                    0.0,
                                    25.0,
                                    0.0,
                                  ),
                                  child: Text(
                                    "Minutes",
                                    style: TextStyle(
                                      fontSize: 13.0,
                                    ),
                                  ),
                                ),

                                Text(
                                  "Seconds",
                                  style: TextStyle(
                                    fontSize: 13.0,
                                  ),
                                ),

                              ],
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.only(left: 280.0),
                            child: Container(
                              height: 60.0,
                              child: RaisedButton(
                                onPressed: () {},
                                child: Icon(
                                  Icons.replay_outlined,
                                  size: 30.0,
                                ),
                                shape: CircleBorder(side: BorderSide.none),
                                color: Colors.blueGrey[800],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}