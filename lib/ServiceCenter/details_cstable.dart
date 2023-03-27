import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:untitled/ServiceCenter/commend_cstable.dart';

class CsDetails extends StatelessWidget {
  CsDetails(this.id, {Key? key}) : super(key: key) {
    _reference = FirebaseFirestore.instance.collection('Posts').doc(id);
    _futureData = _reference.get();
  }

  final String id;
  late DocumentReference _reference;
  late Future<DocumentSnapshot> _futureData;
  late Map data;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Go Trip",
            style: TextStyle(
                fontSize: 60, fontFamily: 'Righteous', color: Colors.black)),
        //foregroundColor: Colors.black,
        centerTitle: true,
        backgroundColor: Colors.purple[100],
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: _futureData,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Some error occurred ${snapshot.error}'));
          }
          if (snapshot.hasData) {
            DocumentSnapshot documentSnapshot = snapshot.data;
            data = documentSnapshot.data() as Map;

            return Column(
              children: <Widget>[
                Align(
                  child: Container(
                    alignment: Alignment.topCenter,
                    padding: const EdgeInsets.only(top: 30),
                    child: const Text('고객센터',
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        )),
                  ),
                ),
                Column(
                  children: [
                    Align(
                      child: Container(
                        alignment: Alignment.bottomLeft,
                        child: Column(
                          children: [
                            Row(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(top:30 , left: 20),
                                  child: Text('제목 : ',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 2.0)),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 30),
                                  child: Text('${data['postTitle']}',
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 18,
                                          fontWeight: FontWeight.normal,
                                          letterSpacing: 2.0)),
                                ),
                              ],
                            ),
                            Container(
                              height: 3,
                              width: 350,
                              color: Colors.black,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Align(
                      child: SizedBox(
                        child: Container(
                          color: Colors.white24,
                          alignment: Alignment.bottomLeft,
                          padding:
                              const EdgeInsets.only(top: 15, left: 20, right: 20),
                          child: Text(
                            '${data['content']}',
                            style: const TextStyle(
                                color: Colors.blueGrey,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 2.0),
                          ),
                        ),
                      ),
                    ),
                    Align(
                      child: Container(
                        alignment: Alignment.bottomLeft,
                        padding: const EdgeInsets.only(top:50),
                        child: ListTile(
                          title: Text('Comment', style: TextStyle(fontSize: 20)),
                          leading: IconButton(
                            icon: Icon(
                              Icons.message,
                              size: 28,
                              color: Colors.blue,
                            ),
                            onPressed: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) => CommentDetail(id)));
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
