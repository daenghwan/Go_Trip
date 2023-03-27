import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:untitled/Review/reviewMain.dart';

class ReviewUpload extends StatefulWidget {
  // const ReviewUpload2({Key? key}) : super(key: key);

  late String nick = "";

  ReviewUpload({required this.nick});

  @override
  State<ReviewUpload> createState() => _ReviewUploadState();
}

class _ReviewUploadState extends State<ReviewUpload> {

  late String nick = "";
  @override
  void initState() {
    super.initState();
    nick = widget.nick;
  }
  FirebaseFirestore fire = FirebaseFirestore.instance;

  TextEditingController titleController = TextEditingController();

  TextEditingController contentController = TextEditingController();

  String reviewTitle = "";
  String reviewCon = "";

  final ImagePicker _picker = ImagePicker();
  List<XFile> _pickedImgs = [];
  String imgUrl = "";

  DateTime today = DateTime.now();


  Future<void> _pickImg() async {
    final List<XFile>? images = await _picker.pickMultiImage();
    if (images != null) {
      setState(() {
        _pickedImgs += images;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isPadMode = MediaQuery.of(context).size.width > 700;
    List<Widget> _boxContents = [
      IconButton(
          onPressed: () {
            _pickImg();
          },
          icon: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.6), shape: BoxShape.circle),
              child: Icon(
                CupertinoIcons.camera,
                color: Theme.of(context).colorScheme.primary,
              ))),
      _pickedImgs.length <= 2
          ? Container()
          : FittedBox(
          child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.6),
                  shape: BoxShape.circle),
              child: Text(
                '+${(_pickedImgs.length - 2).toString()}',
                style: Theme.of(context)
                    .textTheme
                    .subtitle2
                    ?.copyWith(fontWeight: FontWeight.w800),
              ))),
    ];

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text('GO TRIP'),
        centerTitle: true,
        foregroundColor: Colors.black,
        backgroundColor: Colors.purple[100],
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: <Widget>[
              Container(
                padding: const EdgeInsets.only(top: 30),
                child: const Text('한번쯤은 가볼만한곳',
                    style: TextStyle(
                      fontSize: 20,
                    )),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
                child: TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: '제목',
                    hintText: '내용을 입력해주세요',
                  ),
                  onChanged: (value) {
                    setState(() {
                      reviewTitle = value;
                    });
                  },
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 30, right: 300),
                child: Text('글입력',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 15,
                    )),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
                child: Column(
                  children: [
                    TextField(
                      controller: contentController,
                      keyboardType: TextInputType.multiline,
                      maxLines: 4,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "내용을 입력해주세요",
                          focusedBorder:
                          OutlineInputBorder(borderSide: BorderSide())),

                      onChanged: (value) {
                        setState(() {
                          reviewCon = value;
                        });
                      },
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 30, right: 250),
                      child: Text('사진등록하기',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize: 15,
                          )),
                    ),
                    SizedBox(
                        width: 400,
                        height: 200,
                        child: GridView.count(
                          padding: const EdgeInsets.all(2),
                          crossAxisCount: 2,
                          mainAxisSpacing: 5,
                          crossAxisSpacing: 5,
                          children: List.generate(
                              2,
                                  (index) => DottedBorder(
                                // 미리보기 띄움 !!!!
                                child: Container(
                                  child: Center(child: _boxContents[index]),
                                  decoration:
                                  index <= _pickedImgs.length - 1
                                      ? BoxDecoration(
                                      borderRadius:
                                      BorderRadius.circular(4),
                                      image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: FileImage(File(
                                              _pickedImgs[index]
                                                  .path))))
                                      : null,
                                ),
                                color: Colors.grey,
                                dashPattern: [5, 3],
                                borderType: BorderType.RRect,
                                radius: const Radius.circular(10),
                              )).toList(),
                        )),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: Colors.purple,
                              minimumSize: const Size(200, 50),
                              textStyle: const TextStyle(fontSize: 20)),
                          onPressed: () async {

                            FirebaseAuth.instance.signInAnonymously();


                            List<String> uni = [];

                            Reference root = FirebaseStorage.instance.ref();
                            Reference dir = root.child('profile');
                            if(_pickedImgs.length > 0 ){
                              try {
                                for (int a = 0; a < _pickedImgs.length; a++) {
                                  uni.add(DateTime.now()
                                      .millisecondsSinceEpoch
                                      .toString());
                                  Reference RImgUp = dir.child(uni[a]);
                                  await RImgUp.putFile(File(_pickedImgs[a].path));
                                  //성공시 다운로드 URL get
                                  imgUrl += await RImgUp.getDownloadURL() + ",";
                                }
                              } catch (error) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(content: Text('에러')));
                              }
                            }else{
                              uni.add(DateTime.now()
                                  .millisecondsSinceEpoch
                                  .toString());
                            }

                            if(imgUrl.isEmpty){
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ReviewMain(nick: nick),
                                ),
                              );

                              fire.collection('Review').doc(uni[0]).set({
                                "nick": nick,
                                "reviewTitle": reviewTitle,
                                "reviewCon": reviewCon,
                                "number" : uni[0],
                                "date" : Timestamp.now()
                              });

                            }else{
                              Get.off(ReviewMain(nick: nick));
                              fire.collection('Review').doc(uni[0]).set({
                                "nick": nick,
                                "reviewTitle": reviewTitle,
                                "reviewCon": reviewCon,
                                "image": imgUrl,
                                "number" : uni[0],
                                "date" : Timestamp.now()
                              });
                            }

                          },
                          child: const Text('글등록')),
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
