import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:untitled/ScheduleMain/CommentVO.dart';

class CommentService {
  static final CommentService _CommentService = CommentService._internal();
  factory CommentService () => _CommentService;
  CommentService._internal ();
  // Create
  Future createNew(Map<String, dynamic> json,String start,String day,String nick) async {

    DocumentReference<Map<String, dynamic>> documentReference =
    FirebaseFirestore.instance.collection("Schedule").doc(nick+start).collection(day).doc(json["number"]);

    final DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
    await documentReference.get();

    if (!documentSnapshot.exists) {
      await documentReference.set(json);
    }
  }



//READ 각각의 데이터를 콕 집어서 가져올때
  Future<List<Comment>> getFireModel(String start,String day,String nick) async {
    CollectionReference<Map<String, dynamic>> documentSnapshot =
    FirebaseFirestore.instance.collection("Schedule").doc(nick+start).collection(day);
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await documentSnapshot.get();
    List<Comment> comments = [];
    for (var doc in querySnapshot.docs) {
      Comment cmodel = Comment.fronQuerySnapshot(doc) ;
      comments.add(cmodel);
    }

    return comments;
  }
//READ 컬렉션 내 모든 데이터를 가져올때
//   Future<List<Comment>> getFireModels (String day,String start) async {
//     CollectionReference<Map<String, dynamic>> collectionReference =
//     FirebaseFirestore.instance.collection("Schedule");
//     QuerySnapshot<Map<String, dynamic>> querySnapshot = await collectionReference.get();
//     List<Comment> comments = [];
//     for (var doc in querySnapshot.docs) {
//       Comment cmodel = Comment.fronQuerySnapshot(doc) ;
//       comments.add(cmodel);
//     }
//     return comments;
//   }
  //Delete
  Future<void> delComment (DocumentReference reference) async {
    await reference.delete();
  }
}



