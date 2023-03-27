
import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {

   //String? startdate;
   String? comment;
   String? number;
   DocumentReference? reference;

  // 생성자
   Comment({
    //this.startdate,
    this.comment,
     this.number,
     this.reference,
  });


   Comment.fromJson (dynamic json,this.reference) {
     number = json['number'];
     comment = json ['comment'];
   }
   Comment.fromSnapShot (DocumentSnapshot<Map<String, dynamic>> snapshot)
         : this.fromJson(snapshot.data() ,snapshot.reference);

   Comment.fronQuerySnapshot(
     QueryDocumentSnapshot<Map<String, dynamic>> snapshot) : this.fromJson(snapshot.data () ,snapshot .reference);

      //파이어 베이스로 저장 할때 쓴다.
     Map<String, dynamic> toJson () {
     final map = <String, dynamic> {};
     map ['number'] = number;
     map[ 'comment'] = comment;
     return map;
     }


}

