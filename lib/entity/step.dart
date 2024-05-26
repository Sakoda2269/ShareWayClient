

class Step{
  int stepNum = 0;
  String title = "";
  String detail = "";

  Step.fromJson(Map<String, dynamic> json){
    stepNum = json["stepNum"]!;
    title = json["title"]!;
    detail = json["detail"]!;
  }

}