import 'dart:convert';

import 'package:flutter/material.dart';

import 'contact.dart';

class ContactViewModel extends ChangeNotifier{

  static final _instance = ContactViewModel._();
  factory ContactViewModel() => _instance;
  ContactViewModel._();
  final List<Contact> contacts = [];


  void addContact(String phone, String? name, String? email){
    contacts.add(Contact(phone: phone, name: name, email: email));
    notifyListeners();
  }

  void removeContact(String id){
    contacts.removeWhere((contact) => contact.id == id);
    notifyListeners();
  }
  

  void updateContact(String id, String newName, String newPhone, String newEmail){
    try{
      final contact = contacts.firstWhere((contact) => contact.id == id);
        contact.name!.value = newName;
        contact.phone.value = newPhone;
        contact.email!.value = newEmail;

      notifyListeners();
    } catch(e) {
      debugPrint("Not found!");
    }
  }

  String contactsToJson(){
    String jsonStr = '';
    for(int i=0 ; i < contacts.length ; i ++ ){
      if(i != contacts.length - 1){
        jsonStr = jsonStr + contacts[i].toJson() + ',';

      } else{
        jsonStr = jsonStr + contacts[i].toJson() ;

      }
    
    }
    jsonStr = '[' + jsonStr + ']';
    return jsonStr;
  }


}