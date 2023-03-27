import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/material/icons.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:untitled/Main/sidebar.dart';
import 'package:untitled/Memory/memoryMain.dart';
import 'package:untitled/Review/reviewMain.dart';
import 'package:untitled/Schedule/caledarM.dart';
import 'package:untitled/Main/firstpage.dart';


class MainPage extends StatefulWidget {

  late final String nick;

  MainPage({required this.nick});

  @override
  _MainPage createState() => _MainPage();

}

class _MainPage extends State<MainPage> {

  static final storage = const FlutterSecureStorage();
  late String nick;

  @override
  void initState() {
    super.initState();
    nick = widget.nick;
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Go Trip",
            style: TextStyle(
                fontSize: 60,
                fontFamily: 'Righteous',
                color: Colors.purpleAccent
            )),
          iconTheme: const IconThemeData(
            color: Colors.black
          ),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        ),
        endDrawer: SS(nick),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(top: 50),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text('${nick}', style: const TextStyle(
                            fontSize: 48,
                            color: Colors.purpleAccent,
                            fontFamily: 'Dongle',
                            fontWeight: FontWeight.bold,
                          )),
                          const Text('님!', style: TextStyle(
                            fontSize: 38,
                            color: Colors.deepPurpleAccent,
                            fontFamily: 'Dongle',
                            fontWeight: FontWeight.bold,
                          )),
                        ],
                      ),
                      const Text("같이 여행을 준비해볼까요?",
                          style: TextStyle(
                              fontSize: 38,
                              color: Colors.deepPurpleAccent,
                              fontFamily: 'Dongle',
                              fontWeight: FontWeight.bold,
                          )),
                      Padding(
                        padding: const EdgeInsets.only(top: 1),
                        child: Row(
                          children: [
                            ClipOval(
                              child: Material(
                                color: Colors.purple[100], // button color
                                child: InkWell(
                                  splashColor: Colors.purple[700], // inkwell color
                                  child: const SizedBox(width: 60, height: 60, child: Icon(Icons.add, size: 60,),),
                                  onTap: () {Get.toNamed("/Calendar");},
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: (){Get.to(CalendarP1(nick: nick));},
                              child: const Text("나만의 일정 만들기",
                                  style: TextStyle(
                                    fontSize: 50,
                                    fontFamily: 'Dongle',
                                    fontWeight: FontWeight.bold,
                                  )),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: TextButton(
                          onPressed: (){Get.to(ReviewMain(nick: nick,));},
                          child: const Text("사람들이 추천하는 한번쯤은 가볼만한곳",
                              style: TextStyle(
                                fontSize: 30,
                                fontFamily: 'Dongle',
                                fontWeight: FontWeight.bold,
                              )),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 40),
                        child: Container(
                          height: 200,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: [
                              SizedBox(
                                width: 250,
                                child: (Image.asset("assets/images/busan.jpg",fit: BoxFit.fitHeight)),
                              ),
                              const SizedBox(width: 200,),
                            ],
                          ),
                        ),
                      ),
                      ListTile(
                        leading:
                        const Icon(Icons.photo_album_outlined, color: Colors.black),
                        title: const Text('나의 추억 기록하기',
                            style:
                            TextStyle(
                              fontSize: 30,
                              fontFamily: 'Dongle',
                              fontWeight: FontWeight.bold,
                              color: Colors.deepPurpleAccent
                            )),
                        enabled: true,
                        contentPadding: const EdgeInsets.fromLTRB(20, 20, 0, 0),
                        onTap: (){
                          // print('1 button clicked');
                          Get.to(MemoryMain(nick: nick));
                        },
                      ),
                      Center(
                        child: RaisedButton(
                          onPressed: () {
                            //delete 함수를 통하여 key 이름이 login인것을 완전히 폐기 시켜 버린다.
                            //이를 통하여 다음 로그인시에는 로그인 정보가 없어 정보를 불러 올 수가 없게 된다.
                            storage.delete(key: "nick");
                            Navigator.pushReplacement(
                              context,
                              CupertinoPageRoute(
                                  builder: (context) => MyHomePage()),
                            );
                          },
                          child: const Text("Logout",
                          style: TextStyle(
                            fontSize: 30,
                            fontFamily: 'Dongle',
                            fontWeight: FontWeight.bold,
                            color: Colors.red
                          )),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}


