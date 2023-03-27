import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled/ServiceCenter/details_cstable.dart';
import 'package:untitled/ServiceCenter/update_cstable.dart';


class CstableMain extends StatefulWidget {
  late String nick;

  CstableMain(this.nick);

  @override
  State<CstableMain> createState() => _CstableMainState();
}

class _CstableMainState extends State<CstableMain> {

  late String nick = "";
  @override
  void initState() {
    super.initState();
    nick = widget.nick;
  }



  final Stream<QuerySnapshot> cstableStream =
  FirebaseFirestore.instance.collection('Posts').snapshots();

  CollectionReference Posts = FirebaseFirestore.instance.collection('Posts');
  Future<void> deleteTitle(postTitle) {
    return Posts
        .doc(postTitle)
        .delete()
        .then((value) => print('Title Deleted'))
        .catchError((error) => print('Failed to Delete Title:$error'));
  }
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
          snapshot.data!.docs.map((DocumentSnapshot document) {
            Map a = document.data() as Map<String, dynamic>;
            if(a["nick"] == nick){
              storedocs.add(a);
              a['id'] = document.id;
            }
          }).toList();

          return Scaffold(
            appBar: AppBar(
              title: const Text('Go Trip',
                  style: TextStyle(
                      fontSize: 60,
                      fontFamily: 'Righteous',
                      color: Colors.black
                  )),
              foregroundColor: Colors.black,
              centerTitle: true,
              backgroundColor: Colors.purple[100],
            ),
            floatingActionButton: FloatingActionButton(
              child: const Icon(Icons.add),
              backgroundColor: Colors.purple[200],
              onPressed: () {
                Get.toNamed('/insert');
              },
            ),
            body: Column(
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.only(top:30),
                  child: const Text(
                      '고객센터',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold
                      )
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Table(
                      border: TableBorder.all(),
                      columnWidths: const <int, TableColumnWidth>{
                        1: FixedColumnWidth(140),
                      },
                      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                      children: [
                        TableRow(
                          children: [
                            TableCell(
                              child: Container(
                                color: Colors.grey[300],
                                child: const Center(
                                  child: Text(
                                    '제목',
                                    style: TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            // TableCell(
                            //   child: Container(
                            //     color: Colors.grey[300],
                            //     child: const Center(
                            //       child: Text(
                            //         '글내용',
                            //         style: TextStyle(
                            //           fontSize: 20.0,
                            //           fontWeight: FontWeight.bold,
                            //         ),
                            //       ),
                            //     ),
                            //   ),
                            // ),
                            TableCell(
                              child: Container(
                                color: Colors.grey[300],
                                child: const Center(
                                  child: Text(
                                    '수정 / 삭제',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        for (var i = 0; i < storedocs.length; i++) ...[
                        TableRow(
                          children: [
                            TableCell(
                              child: Center(
                                child: TextButton(
                                  style: TextButton.styleFrom(
                                    primary: Colors.blue,
                                  ),
                                  onPressed: () => {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            CsDetails(storedocs[i]['id']),
                                      ),
                                    )
                                  },
                                  child: Text(storedocs[i]['postTitle'],
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(fontSize: 18.0)),
                                ),
                              ),
                            ),
                            // TableCell(
                            //   child: Center(
                            //       child: Text(storedocs[i]['content'],
                            //           maxLines: 1,
                            //           overflow: TextOverflow.ellipsis,
                            //           style: const TextStyle(fontSize: 18.0))),
                            // ),
                            TableCell(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                    onPressed: () => {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              UpdatePage(
                                                id: storedocs[i]['id']),
                                        ),
                                      )
                                    },
                                    icon: const Icon(
                                      Icons.edit,
                                      color: Colors.orange,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () => {deleteTitle(storedocs[i]['id'])},
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        ]
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        });

  }
}

