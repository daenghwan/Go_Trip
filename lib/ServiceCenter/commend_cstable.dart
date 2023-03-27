import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CommentDetail extends StatefulWidget {
  late String nick;

  CommentDetail(this.nick);

  @override
  State<CommentDetail> createState() => _CommentDetailState();
}

class _CommentDetailState extends State<CommentDetail> {

  late String nick = "";
  @override
  void initState() {
    super.initState();
    nick = widget.nick;
  }

  Timestamp sendDate = Timestamp.now();

  final Stream<QuerySnapshot> commentStream =
  FirebaseFirestore.instance.collection('Comments').snapshots();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: commentStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if(snapshot.hasError){
          return const Center(
            child: CircularProgressIndicator(),
          );
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
            title: const Text('Comments'),
            foregroundColor: Colors.black,
            centerTitle: true,
            backgroundColor: Colors.purple[100],
          ),
          body: SafeArea(
            child: ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: CircleAvatar(
                    // backgroundColor: Colors.blue,
                    child: Icon(Icons.account_circle),
                  ),
                  title: Text(
                    snapshot.data!.docs[index]['nick'],
                    style: TextStyle(fontSize: 20)),
                  subtitle: Text(
                    snapshot.data!.docs[index]['comment'],
                    style: TextStyle(fontSize: 20)),
                );
              },
            ),
          ),
        );
    });
  }
}






