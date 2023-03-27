import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/multipart/multipart_file.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:untitled/Review/reviewread.dart';
import 'package:untitled/Review/reviewupload.dart';

class ReviewMain extends StatefulWidget {
  late String nick = "";

  ReviewMain({required this.nick});

  @override
  State<ReviewMain> createState() => _ReviewMainState();
}

class _ReviewMainState extends State<ReviewMain> {
  late String nick = "";

  @override
  void initState() {
    super.initState();
    nick = widget.nick;
  }

  final Stream<QuerySnapshot> cstableStream =
  FirebaseFirestore.instance.collection('Review').orderBy(
      "date", descending: true).snapshots();


  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: cstableStream,
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
          List<String> image = [];
          List<String> image2 = [];
          snapshot.data!.docs.map((DocumentSnapshot document) {
            Map a = document.data() as Map<String, dynamic>;
            storedocs.add(a);
            String img = a["image"] ?? null;

            if (img != null) {
              image2 = img.split(',');
              image.add(image2[0]);
            } else {
              image.add("없음");
            }

          }).toList();

          return Scaffold(
            appBar: AppBar(
              title: const Text('Go Trip',
                  style: TextStyle(
                      fontSize: 40,
                      fontFamily: 'Righteous',
                      color: Colors.black)
              ),
              foregroundColor: Colors.black,
              centerTitle: true,
              backgroundColor: Colors.purple[100],
            ),
            floatingActionButton: FloatingActionButton(
              child: const Icon(Icons.add, color: Colors.black),
              backgroundColor: Colors.purple[200],
              onPressed: () {
                Get.to(ReviewUpload(nick: nick));
              },
            ),
            body: SafeArea(
                child: Column(
                  children: [
                    const Padding(padding: EdgeInsets.only(top: 12)),
                    const Center(
                      child: Text(
                        "사람들이 추천하는 가볼만한곳",
                        style: TextStyle(
                          fontSize: 50,
                          fontWeight: FontWeight.w200,
                          fontFamily: 'Dongle',
                        ),
                      ),
                    ),
                    const Padding(padding: EdgeInsets.only(top: 12)),
                    Expanded(
                      child: ListView.builder(
                          itemCount: storedocs.length,
                          itemBuilder: (context, index) {
                            //return Card(
                            //child:
                            return Container(
                              margin: const EdgeInsets.all(5.0),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.purple,
                                  style: BorderStyle.solid,
                                ),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Row(
                                //mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      top: 10, left: 10,),
                                    child: Center(
                                      child: Column(
                                        children: [
                                          if(image[index] != "없음")...[
                                            Image.network(
                                              image[index], height: 150,
                                              width: 150,)
                                          ],
                                          /////////
                                          if(image[index] == "없음")...[
                                            Image.asset(
                                              "assets/gotrip.jpg", height: 150,
                                              width: 150,)
                                          ]

                                        ],
                                      ),
                                    ),
                                  ),
                                  const Padding(
                                      padding: EdgeInsets.fromLTRB(
                                          30, 20,0, 0)),
                                  TextButton(
                                    onPressed: () {
                                      Get.to(ReviewRead(
                                        number: storedocs[index]['number'],
                                        nick: nick,));
                                    },
                                    child: Container(
                                        width: 170,
                                        child: Row(
                                          //mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Flexible(
                                                child: RichText(
                                                  overflow: TextOverflow.ellipsis,
                                                  maxLines: 4,
                                                  strutStyle: const StrutStyle(fontSize: 18.0),
                                                  text: TextSpan(
                                                      text: '${storedocs[index]['reviewTitle']}',
                                                      style: const TextStyle(
                                                          color: Colors.black,
                                                          height: 1.4,
                                                          fontSize: 18.0,
                                                          fontFamily: 'NanumSquareRegular')),
                                                )),
                                          ],
                                        ))

                                  ),
                                ],
                              ),
                            );
                            //);
                          }),
                    ),
                  ],
                )),
          );
        });
  }
}
