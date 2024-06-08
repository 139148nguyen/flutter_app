import 'dart:convert';

import 'package:final_project/models/contact.dart';
import 'package:final_project/models/contact_view_model.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';

import 'contact_detail_page.dart';
import 'contact_update_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ContactViewModel viewModel = ContactViewModel();

  

  Future<void> getDataInLocal() async{
    final List<dynamic>  dataLocal = jsonDecode(localStorage.getItem('contacts')as String);
    for (int i = 0 ; i< dataLocal.length ; i++){
      dynamic contact = dataLocal[i]; 
      viewModel.contacts.add(Contact(name: contact['name'], phone: contact['phone'], email: contact['email'], id: contact['id']),);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDataInLocal();
  }
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text("Phone"),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            onPressed: (){
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const ContactUpdatePage())

              );
            }, 
            icon: Icon(Icons.add))
        ],
      ),
      body: ListenableBuilder(
        listenable: viewModel, 
        builder: (context, _) {
          return ListView.builder(
            itemCount: viewModel.contacts.length,
            itemBuilder: ((context, index) {
              var contact = viewModel.contacts[index];
              return Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(24),),
                  color: Color.fromARGB(0, 75, 75, 222)
                  ),
                child: Column(
                  children: [
                    const SizedBox(height: 20,),
                    ContactTile(
                      key: ValueKey(contact.id),
                      contact: contact,
                      onTap: (){
                        Navigator.of(context).push<bool>(
                          MaterialPageRoute(builder: (context) => ContactDetailPage(contact: contact,))
                        ).then((deleted) {
                          if(deleted ?? false){
                            viewModel.removeContact(contact.id!);
                            localStorage.setItem('contacts',viewModel.contactsToJson());
                          }
                        });
                      },
                      ),
                  ],
                ),
              );
            }));
        }),
    );
  }
}

class ContactTile extends StatelessWidget {
  const ContactTile({
    super.key,
    required this.contact,
    this.onTap
  });

  final Contact contact;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String?>(
      valueListenable: contact.name!,
      builder: (context, name, child) {
        return ListTile(
        title: Text(name!),
        onTap: onTap,
        leading: const CircleAvatar(
          foregroundImage: AssetImage(
            'assets/images/avatar.png'
          ),
        ),
      );
      },  
    );
  }
}