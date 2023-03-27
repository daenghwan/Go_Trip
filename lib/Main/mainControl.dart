import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:untitled/Main/mainpage.dart';
import 'package:untitled/Schedule/caledarM.dart';
import 'package:untitled/ScheduleMain/ScheduleMain.dart';
import 'package:untitled/Schedule/mapM.dart';
import 'package:untitled/ScheduleMain/ScheduleView.dart';
import 'package:untitled/ServiceCenter/AdminServiceCenterPage.dart';
import 'package:untitled/ServiceCenter/main_cstable.dart';

import '../ServiceCenter/upload_cstable.dart';

class MainPage1 extends StatefulWidget {
  final String nick;

  MainPage1({required this.nick});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MainPage1> {

  late String nick;

  @override
  void initState() {
    super.initState();
    nick = widget.nick;
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainPage(nick: nick),
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: ()=> MainPage(nick: nick)),
        GetPage(name: '/Calendar', page: ()=> CalendarP1(nick: nick)),
        GetPage(name: '/Map', page: ()=> MapMainpage(nick: nick)),
        GetPage(name: '/ServiceMain', page: () => CstableMain(nick)),
        GetPage(name: '/AdminService', page: () => AdminService(nick)),
        GetPage(name: '/insert', page: () => CsUpload(nick)),
        GetPage(name: '/ScheduleView', page: () => ScheduleView(nick: nick)),
      ],

    );
  }




}
