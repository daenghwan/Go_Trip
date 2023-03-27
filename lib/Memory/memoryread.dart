import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class MemoryRead extends StatefulWidget {


  late String number;
  late String nick = "";

  MemoryRead({required this.number, required this.nick});

  @override
  State<MemoryRead> createState() => _MemoryReadState();
}

class _MemoryReadState extends State<MemoryRead> {
  late String number;
  late String nick = "";

  @override
  void initState() {
    super.initState();
    nick = widget.nick;
    number = widget.number;
  }


  final Stream<QuerySnapshot> memoryStream =
  FirebaseFirestore.instance.collection('Memory').snapshots();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: memoryStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            print('Something went Wrong');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final List storedocs = [];
          late String today;
          List<String> image=[];
          snapshot.data!.docs.map((DocumentSnapshot document) {
            Map a = document.data() as Map<String, dynamic>;
            if(a['number'] == number){
              storedocs.add(a);
              Timestamp ss = a['date'];
              today = DateFormat('yyyy/MM/dd/kk:mm').format(ss.toDate());
              String img = storedocs[0]["image"]??null;
              if(img != null){
                image =  img.split(',');
              }

            }

          }).toList();

          return Scaffold(
            appBar: AppBar(
              title: Text('GO TRIP',
                  style: TextStyle(
                      fontSize: 40,
                      fontFamily: 'Righteous',
                      color: Colors.black
                  )),
              centerTitle: true,
              foregroundColor: Colors.black,
              backgroundColor: Colors.purple[100],
            ),
            body: GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(children: <Widget>[
                  Center(
                    child: Container(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text('나만의 추억',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 40,
                            fontFamily: 'Dongle',
                            fontWeight: FontWeight.bold
                          )),
                    ),
                  ),
                  Container(
                      width: 380,
                      child: Divider(color: Colors.grey, thickness: 1.0)),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Column(
                      children: [
                        Padding(
                            padding: const EdgeInsets.only(top: 10, left: 10),
                            child: Row(
                              children: [
                                Container(
                                  child: Text(
                                    '제목: ${storedocs[0]['memoryTitle']}',
                                    style: TextStyle(
                                      fontSize: 26,
                                      fontFamily: 'Dongle',
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              ],
                            )
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Container(
                                child: Text('작성자: ${storedocs[0]['nick']}',
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontFamily: 'Dongle',
                                      fontWeight: FontWeight.normal,
                                    )),
                              ),
                            )

                          ],
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Container(
                                child: Text('작성날짜: $today',
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontFamily: 'Dongle',
                                      fontWeight: FontWeight.normal,
                                    )),
                              ),
                            )
                          ],
                        ),
                        Padding(
                            padding: const EdgeInsets.only(top: 10, left: 100),
                            child: Center(
                              child: Container(
                                  width: 300,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Flexible(
                                          child: RichText(
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 5,
                                            strutStyle: StrutStyle(fontSize: 16.0),
                                            text: TextSpan(
                                                text:storedocs[0]['memoryCon'],
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    height: 1.4,
                                                    fontSize: 18.0,
                                                    fontFamily: 'KirangHaerang')),
                                          )),
                                    ],
                                  )),
                            )
                        ),
                        if(image.length >=0)...[
                          Padding(
                            padding: EdgeInsets.only(top: 10),
                            child: Center(
                              child: Column(
                                children: [
                                  for(int a=0; a<image.length-1;a++)...[
                                    Image.network(image[a])
                                  ]
                                ],
                              ),
                            ),
                          )
                        ]
                      ],
                    ),
                  ),

                  Container(
                      width: 380,
                      child: Divider(color: Colors.grey, thickness: 1.0)),
                ]),
              ),
            ),
          );


        });
  }
}
