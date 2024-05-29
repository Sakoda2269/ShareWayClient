

import 'dart:convert';
import 'dart:typed_data';

import 'package:share_way/entity/step.dart';

class Manual{

  String manualId;
  String title;
  String accountId;
  String accountName;
  List<Step> steps = [];
  Uint8List? thumbnail;

  Manual(this.manualId, this.title, this.accountId, this.accountName);

  Manual.fromJson(this.manualId, Map<String, dynamic> jsonMap):title = "", accountId = "", accountName = ""
  {
    String? titleJson = jsonMap["title"];
    String? accountIdJson = jsonMap["accountId"];
    String? accountNameJson = jsonMap["accountName"];
    String? thumbnailJson = jsonMap["thumbnail"];
    if(titleJson != null){
      title = titleJson;
    }
    if(accountIdJson != null){
      accountId = accountIdJson;
    }
    if(accountNameJson != null){
      accountName = accountNameJson;
    }
    if(thumbnailJson != null){
      thumbnail = base64Decode(thumbnailJson);
    }
    List<dynamic> a = jsonMap["steps"];
    for(Map<String, dynamic> item in a){
      steps.add(Step.fromJson(item));
    }
  }

}