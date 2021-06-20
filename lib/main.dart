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
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: "Cowin Alert"),
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
    return  Scaffold  (
        resizeToAvoidBottomInset : false,
        appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
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
              ElevatedButton(onPressed: ()  {

                setState(()  {
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
                                            // leading: Text(''
                                            //     "${sessionList[index]['min_age_limit']}"
                                            // ),
                                            title: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text("${listData[index]['name']}"),
                                              ],
                                            ),
                                            trailing: Text(
                                                "${listData[index]['fee_type']}",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: listData[index]['fee_type'] == 'Free'?Colors.green:Colors.blue,
                                              ),
                                            ),
                                            subtitle: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: SizedBox(
                                                height:(sessionList.length)*17.toDouble(),
                                                child:
                                                  ListView.builder(
                                                      physics: BouncingScrollPhysics(),
                                                        itemCount:  sessionList.length,
                                                        itemBuilder: (context,index){
                                                          return Row(
                                                            children: [
                                                              Padding(
                                                                padding: const EdgeInsets.only(right:2.0),
                                                                child: Text('${sessionList[index]['date']}'),
                                                              ),
                                                              Text(sessionList[index]['available_capacity']==0?"Booked":"Available",
                                                                style:TextStyle(
                                                                  fontWeight: FontWeight.bold,
                                                                  color:sessionList[index]['available_capacity']==0?Colors.red:Colors.green

                                                                ),)
                                                            ],
                                                          );
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
