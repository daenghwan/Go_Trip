
import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';

import 'package:get/get.dart';
import 'package:untitled/Schedule/mapVO.dart';

//나는 kajashop_getx.dart
class MapControl extends GetxController {
  RxList<dynamic> citys = [].obs;
  // set citynameedit(value) => this.citys.value = value;
  // set coloredit(value) => this.citys.value = value;
  @override
  void onInit(){
    super.onInit();
    viewCitys();
  }

  void viewCitys() async{
    await Future.delayed(const Duration(seconds: 0));
    var cityList = [
      City(
        cityname : "국내",
        choose:"선택",
        color:Colors.white12,
      ),
      City(
        cityname : "서울",
        choose:"선택",
        color:Colors.white12,
      ),
      City(
        cityname : "부산",
        choose:"선택",
        color:Colors.white12,
      ),
      City(
        cityname : "가평",
        choose:"선택",
        color:Colors.white12,
      ),
      City(
        cityname : "제주",
        choose:"선택",
        color:Colors.white12,
      ),
      City(
        cityname : "여수",
        choose:"선택",
        color:Colors.white12,
      ),
      City(
        cityname : "전주",
        choose:"선택",
        color:Colors.white12,
      ),
    ];
    citys.value = cityList;
  }

}


