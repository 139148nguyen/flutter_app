import 'package:final_project/models/contact_view_model.dart';
import 'package:final_project/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';

import '../models/contact.dart';

class ContactUpdatePage extends StatefulWidget {
  final Contact? contact;
  const ContactUpdatePage({super.key, this.contact});

  @override
  State<ContactUpdatePage> createState() => _ContactUpdatePageState();
}

class _ContactUpdatePageState extends State<ContactUpdatePage> {
  final nameCtr = TextEditingController();
  final phoneCtr = TextEditingController();
  final emailCtr = TextEditingController();
  final viewModel = ContactViewModel();

  Future<void> saveDataInLocal() async{
    localStorage.setItem('contacts',viewModel.contactsToJson());
    // debugPrint(viewModel.itemsToJson());
  }

  @override
  Widget build(BuildContext context) {
    nameCtr.text =  widget.contact?.name!.value ?? '';
    phoneCtr.text = widget.contact?.phone.value ?? '';
    emailCtr.text = widget.contact?.email!.value ?? '';

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.contact != null ? 'Chỉnh sửa' : 'Thêm mới'),
        backgroundColor: Colors.blue,
      ),
      body: 
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextFormField(
              controller: nameCtr,
              keyboardType: TextInputType.text,
              decoration:const InputDecoration(
                label: Row(children: [ Icon(Icons.person), SizedBox(width: 10,), Text('Name')], )
              ),
            ),
            TextFormField(
              controller: phoneCtr,
              keyboardType: TextInputType.number,
              decoration:const InputDecoration(
                label: Row(children: [ Icon(Icons.phone), SizedBox(width: 10,), Text('Phone')], )
              ),
            ),
            TextFormField(
              controller: emailCtr,
              keyboardType: TextInputType.text,
              decoration:const InputDecoration(
                label: Row(children: [ Icon(Icons.email), SizedBox(width: 10,), Text('Email')], )
              ),
            ),
            
        const SizedBox(height: 20,),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextButton(
              onPressed: (){
                Navigator.of(context).pop();
              }, 
              child:const Text(
                'Cancel', 
                style: TextStyle( color: Colors.orange),
              )
            ),
            TextButton(
              onPressed: (){
                if(widget.contact == null ){
                  if( phoneCtr.text != '' || nameCtr.text != '' ){
                    viewModel.addContact(phoneCtr.text, nameCtr.text, emailCtr.text);
                  }
                } else {
                  viewModel.updateContact(widget.contact!.id!, nameCtr.text, phoneCtr.text, emailCtr.text);
                }
                setState(() {
                  saveDataInLocal();
                });
                Navigator.of(context).pop();
              }, 
              child:const Text(
                'Save', 
                style: TextStyle( color: Colors.orange),
              )
            ),
          ],)
          ],
        ),
      ),
    );
  }
}