import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:untitled/Review/ReviewVO.dart';


class ReviewService {
  static final ReviewService _CommentService = ReviewService._internal();
  factory ReviewService () => _CommentService;
  ReviewService._internal ();
  // Create
  Future createNew(Map<String, dynamic> json,String number,String number2) async {

    DocumentReference<Map<String, dynamic>> documentReference =
    FirebaseFirestore.instance.collection("Review").doc(number).collection(number).doc(number2);

    final DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
    await documentReference.get();
    if (!documentSnapshot.exists) {
      await documentReference.set(json);
    }
  }



//READ 각각의 데이터를 콕 집어서 가져올때
  Future<List<ReviewComment>> getFireModel(String number) async {
    CollectionReference<Map<String, dynamic>> documentSnapshot =
    FirebaseFirestore.instance.collection("Review").doc(number).collection(number);
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await documentSnapshot.get();
    List<ReviewComment> comments = [];
    for (var doc in querySnapshot.docs) {
      ReviewComment cmodel = ReviewComment.fronQuerySnapshot(doc) ;
      comments.add(cmodel);
    }
    return comments;
  }
//READ 컬렉션 내 모든 데이터를 가져올때
  Future<List<ReviewComment>> getFireModels (String day,String start) async {
    CollectionReference<Map<String, dynamic>> collectionReference =
    FirebaseFirestore.instance.collection("Schedule");
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await collectionReference.get();
    List<ReviewComment> comments = [];
    for (var doc in querySnapshot.docs) {
      ReviewComment cmodel = ReviewComment.fronQuerySnapshot(doc);
      comments.add(cmodel);
    }
    return comments;
  }
  //Delete
  Future<void> delComment (DocumentReference reference) async {
    await reference.delete ();
  }
}



