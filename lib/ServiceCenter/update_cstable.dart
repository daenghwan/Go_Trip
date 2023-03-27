import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UpdatePage extends StatefulWidget {
  final String id;
  const UpdatePage({Key? key, required this.id}) : super(key: key);

  @override
  State<UpdatePage> createState() => _UpdatePageState();
}

class _UpdatePageState extends State<UpdatePage> {

  final formKey = GlobalKey<FormState>();

  CollectionReference Posts = FirebaseFirestore.instance.collection('Posts');

  Future<void>updateTitle(id, postTitle, content) {
    return Posts
        .doc(id)
        .update({'postTitle':postTitle, 'content':content})
        .then((value) => print('Title Updated'))
        .catchError((error) => print('Failed to update Title:$error'));
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
        child: FutureBuilder<DocumentSnapshot <Map <String, dynamic>>>(
          future: FirebaseFirestore.instance
          .collection('Posts')
          .doc(widget.id)
          .get(),
          builder: (_, snapshot){
            if(snapshot.hasError){
              print('Something went Wrong');
            }
            if(snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            var data = snapshot.data!.data();
            var postTitle = data?['postTitle'];
            var content = data?['content'];

            return Padding(
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
                      initialValue: postTitle,
                      autofocus: false,
                      onChanged: (value) => postTitle = value,
                      decoration: const InputDecoration(
                        labelText: '제목',
                        hintText: "내용을 입력해주세요",
                        labelStyle: TextStyle(fontSize: 20.0),
                        border: OutlineInputBorder(),
                        errorStyle:
                        TextStyle(color: Colors.redAccent, fontSize: 15),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '제목을 입력해주세요';
                        }
                        return null;
                      },
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 10.0),
                    child: TextFormField(
                      initialValue: content,
                      autofocus: false,
                      onChanged: (value) => content = value,
                      decoration: const InputDecoration(
                        labelText: '글내용',
                        hintText: "내용을 입력해주세요",
                        labelStyle: TextStyle(fontSize: 20.0),
                        border: OutlineInputBorder(),
                        errorStyle:
                        TextStyle(color: Colors.redAccent, fontSize: 15),
                      ),
                      keyboardType: TextInputType.multiline,
                      maxLines: 4,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '글내용을 입력해주세요';
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
                              updateTitle(widget.id, postTitle, content);
                              Navigator.pop(context);
                            }
                          },
                          child: const Text(
                            '수정',
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
                        )
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        )

      ),
    );
  }
}
