import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled/ScheduleMain/ScheduleMain.dart';

class ScheduleView extends StatefulWidget {
  late String nick = "";

  ScheduleView({Key? key, required this.nick}) : super(key: key);

  @override
  _ScheduleViewState createState() => _ScheduleViewState();
}

class _ScheduleViewState extends State<ScheduleView> {
  late String nick = "";

  @override
  void initState() {
    super.initState();
    nick = widget.nick;
  }

  late final Stream<QuerySnapshot> cstableStream = FirebaseFirestore.instance
      .collection('Schedule')
      .where("nick", isEqualTo: nick)
      .snapshots();

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
          List<String> listmap = [];
          List<String> listmap2 = [];
          String re = "";
          snapshot.data!.docs.map((DocumentSnapshot document) {
            Map a = document.data() as Map<String, dynamic>;
            a['id'] = document.id;
            storedocs.add(a);
            re = a["map"];
            listmap2 = re.split(" ");
            if (listmap2.isEmpty) {
              listmap.add(re);
            } else {
              listmap.add(listmap2[0]);
            }
            // print(storedocs[0]);
            // print(storedocs);
          }).toList();

          return Scaffold(
            appBar: AppBar(
              title: const Text('Go Trip',
                  style: TextStyle(
                      fontSize: 60,
                      fontFamily: 'Righteous',
                      color: Colors.black)),
              foregroundColor: Colors.black,
              centerTitle: true,
              backgroundColor: Colors.purple[100],
            ),
            body: SafeArea(
                child: Column(
              children: [
                const Padding(padding: EdgeInsets.only(top: 10)),
                const Center(
                  child: Text("나의 일정",
                      style: TextStyle(
                          fontSize: 40,
                          fontFamily: 'Dongle',
                          color: Colors.purpleAccent,
                          fontWeight: FontWeight.w700)),
                ),
                Container(
                  color: Colors.black,
                  height: 4,
                ),
                const Padding(padding: EdgeInsets.only(top: 10)),
                Expanded(
                  child: ListView.builder(
                      itemCount: storedocs.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(left: 120, right: 120,),
                          child: Card(
                            color: Colors.white70,
                            elevation: 7,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Container(
                              width: 100,
                              height: 120,
                              child: TextButton(
                                onPressed: () {
                                  Get.to(ScheduleMain(
                                      nick: nick,
                                      start: storedocs[index]['startdate'],
                                      end: storedocs[index]['enddate'],
                                      city: storedocs[index]['map'] + " "));
                                  print(storedocs[index]['id']);
                                },
                                child: Column(
                                  children: [
                                    Text(
                                        "시작 : ${storedocs[index]['startdate']}",
                                        style: const TextStyle(
                                          fontSize: 23,
                                          fontFamily: 'Dongle',
                                          fontWeight: FontWeight.bold,
                                        )),
                                    Text(
                                        "종료 : ${storedocs[index]['startdate']}",
                                        style: const TextStyle(
                                          fontSize: 23,
                                          fontFamily: 'Dongle',
                                          fontWeight: FontWeight.bold,
                                        )),
                                    Text(
                                      "지역 : ${listmap[index]}",
                                        style: const TextStyle(
                                          fontSize: 23,
                                          fontFamily: 'Dongle',
                                          fontWeight: FontWeight.bold,
                                        )),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                ),
              ],
            )),
          );
        });
  }
}
