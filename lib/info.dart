
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

class info extends StatefulWidget {

  info({Key key, this.index,this.dataList}) : super(key: key);
   final int index;
   final List dataList;
  @override
  _infoState createState() => _infoState();
}

class _infoState extends State<info> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Info"),
      ),
      body: ListView.builder(
        itemCount: widget.dataList[widget.index]['sessions'].length,
        itemBuilder: (context, index) {
          List slotList = widget.dataList[widget.index]['sessions'][index]['slots'];

          return GestureDetector(
            onTap: (){
              showDialog<void>(
                context: context,
                barrierDismissible: true, // user must tap button!
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Time Slots'),
                    content: Container(
                      height: 100,
                      width: 50,
                      child:  ListView.builder(itemCount: slotList.length,
                            itemBuilder: (context, index){
                          return Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Text("${slotList[index]}"),
                          );

                            }
                        ),
                    ),
                  );
                },
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                shadowColor: Colors.grey,
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Text("${ widget.dataList[widget.index]['sessions'][index]['date']}",
                              style: TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 20
                              ),),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Text("${ widget.dataList[widget.index]['sessions'][index]['vaccine']}",
                              style: TextStyle(
                                  fontSize: 12
                              ),),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Text('Address: '+"${ widget.dataList[widget.index]['address']}",
                              style: TextStyle(
                                  fontSize: 10
                              ),),
                          ),


                        ],
                      ),
                    ),
                    trailing: Text("Age: ${ widget.dataList[widget.index]['sessions'][index]['min_age_limit']}"),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Text("Total Capacity: ${ widget.dataList[widget.index]['sessions'][index]['available_capacity']}"),
                        Text("Dose 1 Capacity: ${ widget.dataList[widget.index]['sessions'][index]['available_capacity_dose1']}"),
                        Text("Dose 2 Capacity: ${ widget.dataList[widget.index]['sessions'][index]['available_capacity_dose2']}"),

                      ],
                    ),
                    leading: Text("Slots :${slotList.length}"),
                  ),
                ),
              ),
            ),
          );
        }
        )
    );
  }
}
