import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled/Main/mainpage.dart';

import 'package:untitled/Schedule/mapM.dart';

import 'Caledarmodel.dart';

class CalendarP1 extends StatefulWidget {
  late final String nick;
  late String startP;
  late String endP;
  late String city;
  CalendarP1({required this.nick});

  @override
  _CalendarP createState() => _CalendarP();
}

class _CalendarP extends State<CalendarP1> {
  late String nick;
  late String alert = "날짜를 선택해주세요";
  String result = "";
  late String startP;
  late String endP;
  FirebaseFirestore fire = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    nick = widget.nick;
  }

  final List<DateTime> _rangeDatePickerWithActionButtonsWithValue = [
    DateUtils.dateOnly(DateTime.now()),
    DateUtils.dateOnly(DateTime.now().add(const Duration(days: 5))),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("여행일정 등록",
        style: TextStyle(
          fontFamily: 'Dongle',
              fontSize: 50,
          fontWeight: FontWeight.bold
        )),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: Center(
        child: SizedBox(
          width: 375,
          child: ListView(
            children: <Widget>[
              _buildCalendarWithActionButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCalendarWithActionButtons() {
    final config = CalendarDatePicker2WithActionButtonsConfig(
      calendarType: CalendarDatePicker2Type.range,
      selectedDayHighlightColor: Colors.purple[800],
      cancelButton: FlatButton(
        child: Text(
          "cancle",
          style: TextStyle(
              color: Colors.purple[800],
              fontWeight: FontWeight.bold,
              fontSize: 15),
        ),
        onPressed: () {
          Get.to(MainPage(nick: nick));
        },
      ),
      disableYearPicker: true,
    );
    return Column(mainAxisSize: MainAxisSize.min, children: [
      SizedBox(height: 10),
      CalendarDatePicker2WithActionButtons(
          config: config,
          initialValue: _rangeDatePickerWithActionButtonsWithValue,
          onValueChanged: (values) => setState(() {
                result = TestStart(values);
                if (result == "false") {
                  setState(() {
                    alert = "오늘 보다 이전날짜는 선택하실수 없습니다";
                  });
                } else if (result == "success") {
                      Future<List<CModel>> cc = getC();
                      List<CModel> cc2 = <CModel>[];
                      cc.then((value){
                        setState(() {
                          if(value.isNotEmpty){
                            alert = "이미 만들어진 일정입니다";
                          }else{
                            alert = "날짜를 선택해주세요";
                            Get.toNamed("/Map/value?st=$startP&end=$endP");
                          }
                        });
                      });
                } else if (result == "error") {
                  print("as");
                }
              })),
      if (alert == "오늘 보다 이전날짜는 선택하실수 없습니다") ...[
        Text(alert, style: const TextStyle(color: Colors.red, fontSize: 20))
      ]else if(alert == "이미 만들어진 일정입니다") ...[
        Text(alert, style: const TextStyle(color: Colors.red, fontSize: 20))
      ]
      else...[
        Text(alert, style: TextStyle(fontSize: 20))
      ]
    ]);
  }

  String TestStart(List<DateTime?> values) {
    if (values.isNotEmpty) {
      DateTime startDate = DateUtils.dateOnly(values[0]!);
      DateTime ds = DateUtils.dateOnly(DateTime.now());
      Duration diff = startDate.difference(ds);
      int ss = diff.inHours;
      if (ss < 0) {
        return "false";
      } else {
        startP = startDate.toString().replaceAll('00:00:00.000', '');
        DateTime end = DateUtils.dateOnly(values[1]!);
        endP = end.toString().replaceAll('00:00:00.000', '');
          return "success";
      }
    }
    return "error";
  }

Future<List<CModel>> getC() async{
  QuerySnapshot<Map<String, dynamic>> doc1 = await fire.collection("Schedule")
      .where("nick", isEqualTo: nick)
      .where("startdate", isEqualTo: startP)
      .get();
  List<CModel> ca = [];
  for(var doc in doc1.docs){
    CModel calendarR = CModel.fromQuerySnapshot(doc);
    ca.add(calendarR);
  }
  return ca;
}

}
