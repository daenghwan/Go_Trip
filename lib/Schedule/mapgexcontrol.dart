import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:untitled/Schedule/mapVO.dart';



class CityController extends GetxController{
  RxList<dynamic> choosecity = [].obs;
  int get count => choosecity.length;
  //int get tothap => scart.fold(0, (hap,aaa) => hap + aaa.iceprice as int);
  late final String choose2;
  late final dynamic color2;
  In(City city){
    city.choose = "취소";
    city.color = Colors.blue[200];
    choosecity.add(city);
  }

  Out(City city){
    city.choose = "선택";
    city.color = Colors.white12;
    choosecity.remove(city);
  }

}