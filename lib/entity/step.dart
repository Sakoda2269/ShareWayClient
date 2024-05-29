

import 'dart:typed_data';

class Step{
  int stepNum = 0;
  String title = "";
  String detail = "";
  Uint8List? image;

  Step.fromJson(Map<String, dynamic> json){
    stepNum = json["stepNum"]!;
    title = json["title"]!;
    detail = json["detail"]!;
    image = json["picture"];
  }

}