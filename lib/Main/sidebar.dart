import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled/ScheduleMain/ScheduleView.dart';


Widget SS(String nick){
  return Drawer(
    child: ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        DrawerHeader(
          child: Column(
            children:[
              Padding(
                padding:  const EdgeInsets.all(0),
                child: CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.purple[100],),
              ),
              Text('${nick}님',
                style: const TextStyle(
                  fontSize: 50,
                  fontFamily: 'Dongle',
                  fontWeight: FontWeight.bold,
                )),
            ],
          ),
          decoration: BoxDecoration(
            color : Colors.purple[100],

            borderRadius: const BorderRadius.only(
              bottomRight: Radius.circular(30.0),
              bottomLeft: Radius.circular(30.0),

            ),

          ),

        ),
        ListTile(
          leading:
          const Icon(Icons.calendar_today,
              color: Colors.red),
          title: const Text('내 여행일정',
              style: TextStyle(
                fontSize: 40,
                fontFamily: 'Dongle',
                fontWeight: FontWeight.bold,
              )),
          enabled: true,
          contentPadding: const EdgeInsets.fromLTRB(20, 20, 0, 0),
          onTap: (){
            print('내 여행일정 click');
            Get.toNamed("/ScheduleView");
          },
        ),

        ListTile(
          leading:
          const Icon(Icons.star,
              color: Colors.yellow),
          title: const Text('찜한 여행지',
              style: TextStyle(
                fontSize: 40,
                fontFamily: 'Dongle',
                fontWeight: FontWeight.bold,
              )),
          contentPadding: const EdgeInsets.fromLTRB(20, 20, 0, 0),
          onTap: (){
            print('2 button clicked');
          },
        ),


        ListTile(
          leading:
          const Icon(Icons.support_agent,
              color: Colors.black),
          title: const Text('고객센터',
              style: TextStyle(
                fontSize: 40,
                fontFamily: 'Dongle',
                fontWeight: FontWeight.bold,
              )),
          contentPadding: const EdgeInsets.fromLTRB(20, 20, 0, 0),
          onTap: (){
            if(nick == "admin"){
              Get.toNamed("/AdminService");
            }else{
              Get.toNamed("/ServiceMain");
            }
          },

        ),


        ListTile(
          leading:
          const Icon(Icons.person_add,
              color: Colors.purple),
          title: const Text('초대내역',
            style: TextStyle(
              fontSize: 40,
              fontFamily: 'Dongle',
              fontWeight: FontWeight.bold,
            )),
          contentPadding: const EdgeInsets.fromLTRB(20, 20, 0, 0),

          onTap: (){
            print('1 button clicked');
          },
        ),

        Padding(
          padding: const EdgeInsets.fromLTRB(200, 150, 0, 0),
          child: FlatButton(
            onPressed: (){
              //  Get.to(Delmem());
            },
            child:const Text('회원탈퇴',
                style: TextStyle(
                  fontSize: 25,
                  fontFamily: 'Dongle',
                  color: Colors.red
                )),
          ),
        ),


      ],
    ),
  );
}