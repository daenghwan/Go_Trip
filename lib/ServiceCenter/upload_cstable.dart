import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

class CsUpload extends StatefulWidget {
  late String nick;

  CsUpload(this.nick);

  @override
  State<CsUpload> createState() => _CsUploadState();
}

class _CsUploadState extends State<CsUpload> {

  late String nick = "";
  @override
  void initState() {
    super.initState();
    nick = widget.nick;
  }
  final formKey = GlobalKey<FormState>();

  FirebaseFirestore fire = FirebaseFirestore.instance;

  final titleController = TextEditingController();

  final contentController = TextEditingController();

  var postTitle="";

  var content="";

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    super.dispose();
  }

  clearText() {
    titleController.clear();
    contentController.clear();
  }

  CollectionReference Posts = FirebaseFirestore.instance.collection('Posts');

  Future<void> addTitle() {
    return Posts
        .add({'postTitle':postTitle, 'content':content, "nick":nick})
        .then((value) => print('Title Added'))
        .catchError((error) => print('Failed to Add Title:$error'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Go Trip'),
        foregroundColor: Colors.black,
        centerTitle: true,
        backgroundColor: Colors.purple[100],
      ),
      body: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
          child: ListView(
            children: [
              Container(
                padding: const EdgeInsets.only(top:10),
                child: const Text(
                    '고객센터',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 25)
                ),
              ),
              Container(
                padding: const EdgeInsets.only(top:10),
                margin: const EdgeInsets.symmetric(vertical: 10.0),
                child: TextFormField(
                  autofocus: false,
                  decoration: const InputDecoration(
                    labelText: '제목',
                    hintText: "내용을 입력해주세요",
                    labelStyle: TextStyle(fontSize: 20.0),
                    border: OutlineInputBorder(),
                    errorStyle:
                      TextStyle(color: Colors.redAccent, fontSize: 15),
                  ),
                  controller: titleController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '제목을 입력해주세요';
                    } else {
                      Get.toNamed('/');
                    }
                    return null;
                  },
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10.0),
                child: TextFormField(
                  autofocus: false,
                  decoration: const InputDecoration(
                    labelText: '글내용',
                    hintText: "내용을 입력해주세요",
                    labelStyle: TextStyle(fontSize: 20.0),
                    border: OutlineInputBorder(),
                    errorStyle:
                      TextStyle(color: Colors.redAccent, fontSize: 15),
                  ),
                  controller: contentController,
                  keyboardType: TextInputType.multiline,
                  maxLines: 4,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '글내용을 입력해주세요';
                    } else {
                      Get.toNamed('/');
                    }
                    return null;
                  },
                ),
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          setState(() {
                            postTitle = titleController.text;
                            content = contentController.text;
                            addTitle();
                            clearText();
                          });
                        }
                        // else {
                        //   Get.toNamed('/');
                        // }
                      },
                      child: const Text(
                        '등록',
                        style: TextStyle(fontSize: 18.0),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Get.toNamed('/');
                      },
                      child: const Text(
                        '취소',
                        style: TextStyle(fontSize: 18.0),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );

  }
}









