import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:untitled/Main/mainpage.dart';
import 'package:untitled/ScheduleMain/CommentService.dart';
import 'package:untitled/ScheduleMain/CommentVO.dart';
import 'package:intl/intl.dart';


class ScheduleMain extends StatefulWidget {
  late final String nick;
  late final String start;
  late final String end;
  late final String city;

  //late final String memo;

  ScheduleMain({
    required this.nick,
    required this.start,
    required this.end,
    required this.city,
    //required this.memo,
  });

  @override
  _CheckState createState() => _CheckState();
}

class _CheckState extends State<ScheduleMain> {
  late final String nick;
  late final String start;
  late final String end;
  late final String city;
  late List<String> cityss = city.split(' ');
  Completer<GoogleMapController> _controller = Completer();
  late CameraPosition _currentPosition;
  late List<Marker> markers;
  late int difference = 0;
  TextEditingController content = TextEditingController();
  late String coment;
  FirebaseFirestore fire = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    nick = widget.nick;
    start = widget.start;
    end = widget.end;
    city = widget.city;
  }

  late Stream<QuerySnapshot> cstableStream = FirebaseFirestore.instance
      .collection('CityPosition')
      .where("city", isEqualTo: cityss[0])
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
          double lat = 0;
          double long = 0;

          snapshot.data!.docs.map((DocumentSnapshot document) {
            Map a = document.data() as Map<String, dynamic>;
            lat = double.parse(a["lat"]);
            long = double.parse(a["lon"]);
            markers = [
              (Marker(
                  position: LatLng(lat, long), markerId: MarkerId(cityss[0])))
            ];
            DateTime? starter = DateFormat('yyyy-MM-dd').parse(start);
            difference = int.parse(DateFormat('yyyy-MM-dd')
                    .parse(end)
                    .difference(starter)
                    .inDays
                    .toString()) +
                1;
          }).toList();

          return Scaffold(
              appBar: AppBar(
                title: const Text("Go Trip",
                    style: TextStyle(
                        fontSize: 40,
                        fontFamily: 'Righteous',
                        color: Colors.black)),
                centerTitle: true,
                backgroundColor: Colors.purple[200],
                leading: IconButton(
                    onPressed: () {
                      Get.off(() => MainPage(nick: nick));
                    },
                    icon: const Icon(Icons.arrow_back)),
              ),
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(0),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('여행지',
                              style: TextStyle(
                                  fontSize: 40,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: 'Dongle')),
                          Text('$city',
                              style: const TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: 'Dongle')),
                          const Text('여행날짜',
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.w700,
                                fontFamily: 'Dongle',
                              )),
                          Row(
                            children: [
                              Text(start,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Dongle',
                                  )),
                              const Text("~ ",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Dongle',
                                  )),
                              Text(end,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Dongle',
                                  )),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Padding(padding: EdgeInsets.only(top: 20)),
                  if (cityss[0] == "국내") ...[
                    Center(
                      child: Container(
                        width: 360,
                        height: 140,
                        child: GoogleMap(
                          zoomGesturesEnabled: true,
                          zoomControlsEnabled: false,
                          initialCameraPosition: CameraPosition(
                            target: LatLng(lat, long),
                            zoom: 6, //확대
                          ),
                          onMapCreated: (GoogleMapController controller) {
                            controller.animateCamera(
                                CameraUpdate.newLatLng(LatLng(lat, long)));
                            _controller.complete();
                          },
                        ),
                      ),
                    ),
                  ] else ...[
                    Center(
                      child: Container(
                        width: 360,
                        height: 140,
                        child: GoogleMap(
                          zoomGesturesEnabled: true,
                          zoomControlsEnabled: false,
                          initialCameraPosition: CameraPosition(
                            target: LatLng(lat, long),
                            zoom: 12, //확대
                          ),
                          markers: markers.toSet(),
                          onMapCreated: (GoogleMapController controller) {
                            controller.animateCamera(
                                CameraUpdate.newLatLng(LatLng(lat, long)));
                            _controller.complete();
                          },
                        ),
                      ),
                    ),
                  ],
                  const Padding(padding: const EdgeInsets.only(top: 20)),
                  const Padding(
                    padding: EdgeInsets.only(left: 132),
                    child: Text('세부일정 등록하기',
                        style: TextStyle(
                          fontSize: 30,
                          fontFamily: 'Dongle',
                          color: Colors.black,
                        )),
                  ),
                  Expanded(
                    child: detail(),
                  ),
                ],
              ));
        });
  }

  Widget detail() {
    return ListView.builder(
      itemCount: difference,
      itemBuilder: (BuildContext ctx, int idx) {
        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 5,
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: Text(
                    'Day ${idx + 1}',
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
                FutureBuilder<List<Comment>>(
                  future: CommentService()
                      .getFireModel(start, 'Day${idx + 1}', nick),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List<Comment> datas = snapshot.data!;
                      if (!datas.isEmpty) {
                        return Container(
                          height: 90,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10, right: 10),
                            child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: datas.length,
                                itemBuilder: (context, int index) {
                                  Comment data1 = datas[index];
                                  return Row(
                                    children: [
                                      const Padding(
                                          padding: EdgeInsets.only(left: 8)),
                                      const Icon(
                                        Icons.circle,
                                        size: 14,
                                        color: Colors.lightGreenAccent,
                                      ),
                                      Card(
                                          elevation: 10,
                                          child: Container(
                                              width: 320,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Flexible(
                                                      child: RichText(
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 4,
                                                    strutStyle:
                                                        const StrutStyle(
                                                            fontSize: 13.0),
                                                    text: TextSpan(
                                                        text:
                                                            '${data1.comment}',
                                                        style: const TextStyle(
                                                            color: Colors.black,
                                                            height: 1.4,
                                                            fontSize: 13.0,
                                                            fontFamily:
                                                                'NanumSquareRegular')),
                                                  )),
                                                  IconButton(
                                                      onPressed: () async {
                                                        await CommentService()
                                                            .delComment(fire
                                                                .collection(
                                                                    "Schedule")
                                                                .doc(nick +
                                                                    start)
                                                                .collection(
                                                                    'Day${idx + 1}')
                                                                .doc(data1
                                                                    .number));
                                                        setState(() {});
                                                        print("sss");
                                                      },
                                                      icon: const Icon(
                                                        Icons.delete_forever,
                                                        color: Colors.red,
                                                      ))
                                                ],
                                              ))),
                                    ],
                                  );
                                }),
                          ),
                        );
                      } else {
                        return Container();
                      }
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          minimumSize: Size(5, 5),
                        ),
                        onPressed: () {
                          setState(() {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text("메모작성"),
                                  content: TextField(
                                    controller: content,
                                    keyboardType: TextInputType.multiline,
                                    maxLines: 8,
                                    decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                        hintText: "내용을 입력해주세요",
                                        focusedBorder: const OutlineInputBorder(
                                            borderSide: BorderSide())),
                                    onChanged: (value) {
                                      setState(() {
                                        coment = value;
                                      });
                                    },
                                  ),
                                  actions: [
                                    FlatButton(
                                        onPressed: () async {
                                          Comment cmodel = Comment(
                                              comment: coment,
                                              number: DateTime.now()
                                                  .millisecondsSinceEpoch
                                                  .toString());
                                          content.clear();
                                          await CommentService().createNew(
                                              cmodel.toJson(),
                                              start,
                                              'Day${idx + 1}',
                                              nick);
                                          setState(() {});
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text("확인")),
                                    FlatButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text("취소"))
                                  ],
                                );
                              },
                            );
                          });
                        },
                        child: Row(
                          children: [
                            Icon(Icons.note_alt),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
