import 'package:cloud_firestore/cloud_firestore.dart';

class CModel{

  String? startdate;
  String? nick;
  DocumentReference? re;

  CModel({
    this.nick,
    this.startdate,
    this.re
  });

  CModel.fromQuerySnapshot(QueryDocumentSnapshot<Map<String,dynamic>> snapshot)
  : this.fromJson(snapshot.data(),snapshot.reference);

  CModel.fromJson(dynamic j,this.re){
    startdate = j['startdate'];
    nick = j['nick'];
  }

}