
import 'package:cloud_firestore/cloud_firestore.dart';

class ReviewComment {

   //String? startdate;
   String? comment;
   String? date;
   String? nick;
   String? number;
   DocumentReference? reference;

  // 생성자
   ReviewComment({
    //this.startdate,
    this.comment,
     this.nick,
     this.date,
     this.number,
     this.reference,
  });


   ReviewComment.fromJson (dynamic json,this.reference) {
     nick = json['nick'];
     date = json['date'];
     comment = json ['comment'];
     number = json ['number'];
   }
   ReviewComment.fromSnapShot (DocumentSnapshot<Map<String, dynamic>> snapshot)
         : this.fromJson(snapshot.data() ,snapshot.reference);

   ReviewComment.fronQuerySnapshot(
     QueryDocumentSnapshot<Map<String, dynamic>> snapshot) : this.fromJson(snapshot.data () ,snapshot .reference);

      //파이어 베이스로 저장 할때 쓴다.
     Map<String, dynamic> toJson () {
     final map = <String, dynamic> {};
     map ['nick'] = nick;
     map ['date'] = date;
     map['comment'] = comment;
     map['number'] = number;
     return map;
     }


}

