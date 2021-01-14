import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods{

uploadUserInfo(userMap){
  Firestore.instance.collection("users")
    .add(userMap);
  }
}  