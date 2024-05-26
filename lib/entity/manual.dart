

import 'dart:convert';

import 'package:share_way/entity/step.dart';

class Manual{

  String manualId;
  String title;
  String accountId;
  String accountName;
  List<Step> steps = [];

  Manual(this.manualId, this.title, this.accountId, this.accountName);

  Manual.fromJson(this.manualId, Map<String, dynamic> jsonMap):title = "", accountId = "", accountName = ""
  {
    String? titleJson = jsonMap["title"];
    String? accountIdJson = jsonMap["accountId"];
    String? accountNameJson = jsonMap["accountName"];
    if(titleJson != null){
      title = titleJson;
    }
    if(accountIdJson != null){
      accountId = accountIdJson;
    }
    if(accountNameJson != null){
      accountName = accountNameJson;
    }
    List<dynamic> a = jsonMap["steps"];
    for(Map<String, dynamic> item in a){
      steps.add(Step.fromJson(item));
    }
  }

}