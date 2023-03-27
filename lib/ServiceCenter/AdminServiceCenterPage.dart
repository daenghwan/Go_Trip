import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled/Main/sidebar.dart';
import 'package:untitled/ServiceCenter/Admin_ServiceMain.dart';


class AdminService extends StatefulWidget  {
  late String nick;
  AdminService(this.nick);

  @override
  State<AdminService> createState() => _AdminServiceState();
}

class _AdminServiceState extends State<AdminService> {
  late String nick = "";
  @override
  void initState() {
    super.initState();
    nick = widget.nick;
  }



  final Stream<QuerySnapshot> cstableStream =
  FirebaseFirestore.instance.collection('Posts').snapshots();

  @override
  Widget build(BuildContext context) {

    return StreamBuilder<QuerySnapshot>(
        stream: cstableStream,
        builder:
            (BuildContext context, AsyncSnapshot<QuerySnapshot>
        snapshot) {
          if(snapshot.hasError){
            print('Something went Wrong');
          }
          if(snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final List storedocs = [];
          List result = [];
          snapshot.data!.docs.map((DocumentSnapshot document) {
            Map a = document.data() as Map<String, dynamic>;
            if(a["nick"] != "admin"){
                storedocs.add(a["nick"]);
                result = storedocs.toSet().toList();
            }
          }).toList();
          return Scaffold(
            appBar: AppBar(
              title: const Text('Go Trip'),
              foregroundColor: Colors.black,
              centerTitle: true,
              backgroundColor: Colors.purple[100],
              leading:  IconButton(
                  onPressed: () {
                    Navigator.pop(context); //뒤로가기
                  },
                  color: Colors.black,
                  icon: Icon(Icons.arrow_back)),
            ),
            endDrawer: SS(nick),
            body: Center(
              child: Column(
                children: [
                  const Padding(
                      padding: EdgeInsets.only(top: 12)
                  ),const Text("관리자 고객센터",
                    style: TextStyle(
                      fontSize: 20
                    ),
                  ),
              for(int a=0; a<result.length;a++)...[
                  TextButton(
                    onPressed: () {
                      Get.to(AdminServiceMain(result[a]));
                    },
                    child: Text("회원:${result[a]}",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  )
                ]
                ],
                  // child:((){
                  //   for(int a=0; a<result.length;a++)...[
                  //     TextButton(
                  //       onPressed: () {
                  //         Get.to(AdminServiceMain(result[a]));
                  //       },
                  //       child: Text(result[a]),
                  //     );
                  //   ]
                  // })(),

                )
            ),
          );
        });

  }
}
