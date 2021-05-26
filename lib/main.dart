import 'dart:async';
import 'dart:convert';

import 'package:cowin_vaccine_alert/info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: "Cowin Alert"),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  var pincodeText = TextEditingController();
  DateTime now = DateTime.now();
  Map data;
  List listData = [];
  Widget future;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
     AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('ic_launcher');

     IOSInitializationSettings initializationSettingsIOS =
    IOSInitializationSettings();

    InitializationSettings initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
    
  }


  @override
  Widget build(BuildContext context) {

    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return  Scaffold  (
        resizeToAvoidBottomInset : false,
        appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body:   Column(
            // Column is also a layout widget. It takes a list of children and
            // arranges them vertically. By default, it sizes itself to fit its
            // children horizontally, and tries to be as tall as its parent.
            //
            // Invoke "debug painting" (press "p" in the console, choose the
            // "Toggle Debug Paint" action from the Flutter Inspector in Android
            // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
            // to see the wireframe for each widget.
            //
            // Column has various properties to control how it sizes itself and
            // how it positions its children. Here we use mainAxisAlignment to
            // center the children vertically; the main axis here is the vertical
            // axis because Columns are vertical (the cross axis would be
            // horizontal).

            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  decoration: InputDecoration(
                      hintText: 'Enter pincode'
                  ),
                  keyboardType: TextInputType.number,
                  controller: pincodeText,
                ),
              ),
              ElevatedButton(onPressed: () {

                setState(() {
                  future =   FutureBuilder (
                      builder: (context, projectSnap)  {
                        List listData = projectSnap.data;

                        if (projectSnap.connectionState == ConnectionState.none &&
                            projectSnap.hasData == null ) {
                          return Container();
                        }
                        if (projectSnap.hasData) {
                          if (listData.isEmpty){
                            return Container(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Center(child: Text('No Vaccine centers available',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 26,
                                  ),
                                )
                                ),
                              ),
                            );
                          }
                          else {
                            return Expanded(
                              flex: 2,
                              child: ListView.builder(
                                itemCount: listData.length,
                                itemBuilder: (context, index) {
                                  //_showNotification();
                                  List sessionList = listData[index]['sessions'];

                                  return GestureDetector(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Card(
                                        shadowColor: Colors.grey,
                                        elevation: 5,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: ListTile(
                                            leading: Text(
                                                "${sessionList.length} Day"),
                                            title: Column(
                                              crossAxisAlignment: CrossAxisAlignment
                                                  .start,
                                              children: [
                                                Text("${listData[index]['name']}"),
                                                Text("${listData[index]['address']}"),
                                              ],
                                            ),
                                            trailing: Text(
                                                "${listData[index]['fee_type']}"),
                                            subtitle: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: SizedBox(
                                                height:(sessionList.length)*17.toDouble(),
                                                child:
                                                  ListView.builder(
                                                      physics: BouncingScrollPhysics(),
                                                        itemCount:  sessionList.length,
                                                        itemBuilder: (context,index){
                                                          return Text('${sessionList[index]['date']}');
                                                        }),

                                              ),
                                            ),

                                          ),
                                        ),
                                      ),
                                    ),
                                    onTap: (){
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => info(index: index,dataList:listData)),
                                      );
                                    },
                                  );
                                },
                              ),
                            );
                          }

                        }

                        else{
                          return Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: CircularProgressIndicator(),
                          );
                        }
                      },
                      future: getData()
                  );

                });



              },
                  child: Text("CHECK")),
              future == null? Container(): future,

            ]
          ),


    );
  }

  Future getData()async{
    String date = now.day.toString() + '-' + now.month.toString() + '-' + now.year.toString();

    Response response = await get(Uri.parse('https://cdn-api.co-vin.in/api/v2/appointment/sessions/public/calendarByPin?pincode=${pincodeText.text}&date=$date'));
    data = jsonDecode(response.body);
    List listData = data['centers'];
    return listData;
  }

  Future _showNotification() async{
    AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
        'your channel id', 'your channel name', 'your channel description',
        importance: Importance.max,
        priority: Priority.high,);
    IOSNotificationDetails iosNotificationDetails = IOSNotificationDetails();
    NotificationDetails notificationDetails = NotificationDetails(android: androidPlatformChannelSpecifics,iOS:iosNotificationDetails);

    await flutterLocalNotificationsPlugin.show(
        0, 'Slot Available', 'Book the Slot', notificationDetails,
        payload: 'item x');
  }
  Future onSelectNotification(String payload) {
  }
}
