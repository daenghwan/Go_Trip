import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:untitled/Main/mainControl.dart';



class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late TextEditingController _nameController; //이름객체
  String username = "";
  FirebaseFirestore fire = FirebaseFirestore.instance;
  var n = "사용하실 닉네임을 입력해주세요";
  static final storage =
      new FlutterSecureStorage(); // flutter_secure_storage사용을위한 초기화작업
  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();

    //비동기로 flutter secure storage 정보를 불러오는 작업.
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      _asyncMethod();
    });
  }

  _asyncMethod() async {
    //read 함수를 통하여 key값에 맞는 정보를 불러오게 됩니다. 이때 불러오는 결과의 타입은 String 타입임을 기억해야 합니다.
    //(데이터가 없을때는 null을 반환을 합니다.)
    username = (await storage.read(key: "nick"))!;


  //  user의 정보가 있다면 바로 로그아웃 페이지로 넝어가게 합니다.
    if (username != null) {
      Navigator.pushReplacement(
          context,
          CupertinoPageRoute(
          builder: (context) => MainPage1(
        nick: username,
      )),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: <Widget>[
            const Padding(padding: EdgeInsets.only(top: 80)),
            const Text(
              "Go Trip",
              style: TextStyle(
                fontSize: 80,
                fontFamily: 'Righteous',
              ),
            ),
            Container(child: Text(n), padding: const EdgeInsets.only(top: 80)),
            Container(
              child: TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), labelText: '닉네임 입력'),
              ),
              width: 300,
              padding: const EdgeInsets.only(top: 10),
            ),
            Padding(
                padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
                child: ElevatedButton(
                  onPressed: () async {
                    DocumentSnapshot doc = await fire
                        .collection("Signup")
                        .doc(_nameController.text.toString())
                        .get();
                    setState(() {
                      showDialog(
                          context: context,
                          builder: (BuildContext ct) {
                            try {
                              return AlertDialog(
                                content: Text("${doc["name"]}는 사용중인 닉네임입니다"),
                                actions: [
                                  FlatButton(
                                      onPressed: Navigator.of(context).pop,
                                      child: const Text("확인"))
                                ],
                              );
                            } catch (e) {
                              return AlertDialog(
                                content: const Text("가입되었습니다"),
                                actions: [
                                  FlatButton(
                                      onPressed: () async {
                                        await storage.write(
                                            key: "nick",
                                            value: _nameController.text.toString());
                                        fire.collection("Signup").doc(_nameController.text.toString())
                                        .set({
                                          "name":_nameController.text.toString()
                                        });
                                        Navigator.pushReplacement(
                                          context,
                                          CupertinoPageRoute(
                                              builder: (context) => MainPage1(
                                                nick: _nameController.text,
                                              )),
                                        );
                                        Navigator.of(context).pop;
                                      },
                                      child: const Text("확인"))
                                ],
                              );
                            }
                          });
                    });
                  },
                  child: const Text("확인"),
                ))
          ],
        ),
      ),
    );
  }
}
