

import 'dart:typed_data';

class Account{
  String token="";
  String accountId="";
  String accountName="";
  String email="";
  String introduction="";
  Uint8List? icon;

  Account(this.token, this.accountId, this.accountName, this.email, this.introduction);

  Account.fromJson(Map<String, dynamic> json, this.token){
    accountName = json["accountName"].toString();
    accountId = json["accountId"].toString();
    email = json["email"].toString();
    introduction = json["introduction"].toString();
  }
}