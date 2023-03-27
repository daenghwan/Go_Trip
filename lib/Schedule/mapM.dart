import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled/Schedule/caledarM.dart';
import 'package:untitled/ScheduleMain/ScheduleMain.dart';
import 'package:untitled/Schedule/mapControl.dart';
import 'package:untitled/Schedule/mapgexcontrol.dart';

// void main() async {
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return GetMaterialApp(
//       debugShowCheckedModeBanner: false,
//       // initialBinding: Binding(),
//       home: MapMainpage(),
//     );
//   }
// }

class MapMainpage extends StatefulWidget {
  //late final List<DateTime?> calendar;
  late final String nick;

  String? start = Get.parameters["st"];
  String? end = Get.parameters["end"];

  MapMainpage({required this.nick});

  @override
  State<MapMainpage> createState() => _MapMainpageState();
}

class _MapMainpageState extends State<MapMainpage> {
  late String nick;
  late String start;
  late String end;
  String result = "";
  FirebaseFirestore fire = FirebaseFirestore.instance;

  final mapController = Get.put(MapControl());

  final cityController = Get.put(CityController());


  bool finalcheck = false;


  @override
  void initState() {
    super.initState();
    nick = widget.nick;
    start = widget.start!;
    end = widget.end!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("도시 등록"),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        // leading: IconButton(
        //     onPressed: () {
        //       Get.off(() => CalendarP1(nick: nick));
        //     },
        //     icon: Icon(Icons.arrow_back)),
      ),
      body: SafeArea(
          child: Column(
        children: [
          const Padding(padding: EdgeInsets.only(top: 12)),
          Expanded(
            child: GetX<MapControl>(
              builder: (controller) {
                return ListView.builder(
                    itemCount: controller.citys.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            const Padding(padding: EdgeInsets.only(top: 62)),
                            SizedBox(
                              child: Text(
                                "${controller.citys[index].cityname}",
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              width: 260,
                            ),
                            if ("${controller.citys[index].choose}" ==
                                "선택") ...[
                              SizedBox(
                                child: ButtonTheme(
                                  minWidth: 80,
                                  height: 35,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30)),
                                  child: RaisedButton(
                                    onPressed: () {
                                      setState(() {
                                        cityController.In(
                                            controller.citys[index]);
                                        if(cityController.count >=1 ){
                                          finalcheck = true;
                                        }
                                      });
                                      //Get.toNamed("/final/value?st=$start&end=$end&city=${city[index]}");
                                    },
                                    child: Text(
                                        "${controller.citys[index].choose}"),
                                  ),
                                  buttonColor: controller.citys[index].color,
                                ),
                                width: 80,
                              ),
                            ] else ...[
                              SizedBox(
                                child: ButtonTheme(
                                  minWidth: 80,
                                  height: 35,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30)),
                                  child: RaisedButton(
                                    onPressed: () {
                                      setState(() {
                                        cityController.Out(
                                            controller.citys[index]);
                                        if(cityController.count ==0 ){
                                          finalcheck = false;
                                        }
                                      });
                                      //Get.toNamed("/final/value?st=$start&end=$end&city=${city[index]}");
                                    },
                                    child: Text(
                                        "${controller.citys[index].choose}"),
                                  ),
                                  buttonColor: controller.citys[index].color,
                                ),
                                width: 80,
                              ),
                            ]
                          ],
                        ),
                      );
                    });
              },
            ),
          ),
        ],
      )),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 12,right: 10,left: 10),
        child: ElevatedButton(
          onPressed: finalcheck==false? null:() {
            if(cityController.count==1){
              fire.collection("Schedule").doc().set({
                "nick":nick,
                "startdate":start,
                "enddate": end,
                "map": cityController.choosecity[0].cityname
              });
              Get.off(ScheduleMain(nick: nick, start: start,end: end,city: cityController.choosecity[0].cityname,));
            }else{
              String finalmap = "";
              for(int a= 0 ;a<cityController.count;a++){
                finalmap += cityController.choosecity[a].cityname+" ";
              }
              fire.collection("Schedule").doc().set({
                "nick":nick,
                "startdate":start,
                "enddate": end,
                "map": finalmap
              });
              Get.off(ScheduleMain(nick: nick, start: start,end: end,city: finalmap));
            }

          },
            child:GetX<CityController>(
              builder: (controller) {
                if(controller.count>1){
                  int a = controller.count-1;
                  return Text(
                   "${controller.choosecity[0].cityname} 외 $a개 선택완료"
                  );
                } else if(controller.count == 1){
                  return Text(
                      "${controller.choosecity[0].cityname} 선택완료"
                  );
                }else{
                    return Text(
                        "최소 1개이상의 도시를 선택해주세요"
                    );
                }
              },
            ),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(43),
            )),
      )
    );
  }
}
