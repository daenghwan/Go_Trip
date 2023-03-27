import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:untitled/Review/ReviewService.dart';
import 'package:untitled/Review/ReviewVO.dart';

class ReviewRead extends StatefulWidget {
  late String number;
  late String nick = "";

  ReviewRead({required this.number, required this.nick});

  @override
  State<ReviewRead> createState() => _ReviewReadState();
}

class _ReviewReadState extends State<ReviewRead> {
  late String number;
  late String nick = "";

  @override
  void initState() {
    super.initState();
    nick = widget.nick;
    number = widget.number;
  }

  FirebaseFirestore fire = FirebaseFirestore.instance;

  TextEditingController commentController = TextEditingController();

  String comment = "";

  final Stream<QuerySnapshot> cstableStream =
      FirebaseFirestore.instance.collection('Review').snapshots();

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
          late String today;
          late String today2;
          List<String> image = [];
          //String nick3="";
          snapshot.data!.docs.map((DocumentSnapshot document) {
            Map a = document.data() as Map<String, dynamic>;
            if (a['number'] == number) {
              a["id"] = document.id;
              storedocs.add(a);
              Timestamp ss = a['date'];
              Timestamp sss = a['date'];
              today = DateFormat('yyyy/MM/dd/kk:mm')
                  .format(ss.toDate())
                  .toString();
              //today2 = DateFormat('yyyy/MM/dd/kk:mm').format(sss.toDate().toLocal());
              String img = storedocs[0]["image"] ?? null;
              if (img != null) {
                image = img.split(',');
              }

            }
          }).toList();

          return Scaffold(
            appBar: AppBar(
              title: Text('GO TRIP'),
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
                      padding: const EdgeInsets.only(
                        top: 20,
                      ),
                      child: Text('한번쯤은 가볼만한곳',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20,
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
                                    '제목: ${storedocs[0]['reviewTitle']}',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            )),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Container(
                                child: Text('작성자: ${storedocs[0]['nick']}',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
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
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    )),
                              ),
                            )
                          ],
                        ),
                        Padding(
                            padding: const EdgeInsets.only(top: 10, left: 10),
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
                                            text: storedocs[0]['reviewCon'],
                                            style: TextStyle(
                                                color: Colors.black,
                                                height: 1.4,
                                                fontSize: 16.0,
                                                fontFamily:
                                                    'NanumSquareRegular')),
                                      )),
                                    ],
                                  )),
                            )),
                        if (image.length >= 0) ...[
                          Padding(
                            padding: EdgeInsets.only(top: 10),
                            child: Center(
                              child: Column(
                                children: [
                                  for (int a = 0;
                                      a < image.length - 1;
                                      a++) ...[Image.network(image[a])]
                                ],
                              ),
                            ),
                          )
                        ]
                      ],
                    ),
                  ),

                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10, left: 10),
                      child: Container(
                        child: Text('댓글작성',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            )),
                      ),
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.all(8.0),
                      //child: const SizedBox(
                      //width: 380,
                      child: TextField(
                        controller: commentController,
                        keyboardType: TextInputType.multiline,
                        decoration: InputDecoration(
                          hintText: "내용을 입력해주세요",
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(vertical: 20),
                        ),
                        onChanged: (value) {
                          setState(() {
                            comment = value;
                          });
                        },
                        style: TextStyle(fontSize: 10),
                      )),

                  Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: Colors.purple,
                              textStyle: const TextStyle(fontSize: 15)),
                          onPressed: () async {
                            String number2 = DateTime.now().millisecondsSinceEpoch.toString();
                            ReviewComment com = ReviewComment(
                                comment: comment,
                                date: DateFormat('yyyy/MM/dd/kk:mm')
                                    .format(
                                        DateTime.now())
                                    .toString(),
                                nick: nick,
                              number: number2
                            );
                            await ReviewService().createNew(com.toJson(), number, number2);
                            commentController.clear();

                            setState(() {});
                          },
                          child: Text('등록')),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Container(
                      padding: const EdgeInsets.only(top: 10, left: 10),
                      child: Text('댓글',
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold)),
                    ),
                  ),

                  Container(
                      width: 380,
                      child: Divider(color: Colors.grey, thickness: 1.0)),

                  Container(
                      child: FutureBuilder<List<ReviewComment>>(
                          future: ReviewService().getFireModel(number),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              List<ReviewComment> datas = snapshot.data!;
                              if (!datas.isEmpty) {
                                return Align(
                                  child: Column(
                                    children: [
                                      for (int a = 0;
                                          a < datas.length;
                                          a++) ...[
                                        Padding(
                                          padding: const EdgeInsets.only(),
                                        ),
                                        Container(
                                          padding: EdgeInsets.all(13),
                                          margin: EdgeInsets.all(5.0),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Colors.grey,
                                              style: BorderStyle.solid,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                          child: Column(
                                            children: [
                                              Row(
                                                children: [
                                                  Container(
                                                    child: Text(
                                                      '작성자: ${datas[a].nick}',
                                                      style: TextStyle(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(),
                                                    child: Container(
                                                        width: 300,
                                                        child: Row(
                                                          children: [
                                                            Flexible(
                                                                child: RichText(
                                                                  overflow: TextOverflow.ellipsis,
                                                                  maxLines: 4,
                                                                  strutStyle: StrutStyle(fontSize: 15.0),
                                                                  text: TextSpan(
                                                                      text: '${datas[a].comment}',
                                                                      style: const TextStyle(
                                                                          color: Colors.black,
                                                                          height: 1.4,
                                                                          fontSize: 15.0,
                                                                          fontWeight: FontWeight.bold,
                                                                          fontFamily: 'NanumSquareRegular')),
                                                                )),
                                                          ],
                                                        ))
                                                  )
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(),
                                                    child: Container(
                                                      child: Text(
                                                          '${datas[a].date}',
                                                          style: TextStyle(
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          )),
                                                    ),
                                                  ),
                                                  if(nick == datas[a].nick)...[
                                                    TextButton(
                                                        onPressed: () async{
                                                          await ReviewService().delComment(fire.collection("Review")
                                                              .doc(number).collection(number).doc(datas[a].number));
                                                          setState(() {});
                                                        },
                                                        child: Text("댓글삭제"))
                                                  ]
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                );
                              } else {
                                return Container();
                              }
                            } else {
                              return Container();
                            }
                          })),
                ]),
              ),
            ),
          );
        });
  }
}

