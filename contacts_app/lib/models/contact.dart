import 'dart:convert';

import 'package:flutter/material.dart';

class Contact{
  ValueNotifier<String>? name;
  ValueNotifier<String> phone;
  ValueNotifier<String>? email;
  String? id;

  Contact({String? name,required String phone, String? email, String? id})
    : phone = ValueNotifier(phone),
      name = ValueNotifier(name! != '' ? name : phone) ,
      email = ValueNotifier(email ?? ''),
      id = id ?? DateTime.now().toString()
  ;


  Map<String, dynamic> toMap(){
    return <String,dynamic>{
      'name': name!.value,
      'phone': phone.value ,
      'email': email?.value ,
      'id': id 
    };
  }

  factory Contact.fromMap(Map<String, dynamic> map){
    return Contact(
      name: map['name'] as String,
      phone: map['phone'] as String,
      email: map['email'] as String,
      id: map['id'] as String
      );
  }

  String toJson()=> jsonEncode(toMap());


  factory Contact.fromJson(String jsonStr) => Contact.fromMap(jsonDecode(jsonStr) as Map<String,dynamic>);
}