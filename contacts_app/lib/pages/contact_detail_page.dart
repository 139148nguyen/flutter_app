import 'package:final_project/models/contact.dart';
import 'package:final_project/pages/contact_update_page.dart';
import 'package:flutter/material.dart';

class ContactDetailPage extends StatefulWidget {
  const ContactDetailPage({super.key,required this.contact});
  final Contact contact;

  @override
  State<ContactDetailPage> createState() => _ContactDetailPageState();
}

class _ContactDetailPageState extends State<ContactDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
                  onPressed: (){
                    showDialog(
                      context: context, 
                      builder: (context){
                        return AlertDialog(
                          title: const Text("Xác nhận xóa"),
                          content: const Text("Bạn có chắc muốn xóa mục này"),
                          actions: [
                            TextButton(
                              onPressed: (){
                                Navigator.of(context).pop(false);
                              }, 
                              child:const Text("Bỏ qua")),
                            TextButton(
                              onPressed: ()=> Navigator.of(context).pop(true), 
                              child: const Text('Xóa'))
                          ],

                        );
                      }).then((comfirmed) {
                        if(comfirmed ?? false){
                          Navigator.of(context).pop(true);
                        }
                      });
                  
                  }, 
                  icon:const Icon(Icons.delete)),
        ],
        // title: Text(widget.contact.name!.value),
      ),
      body:

          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              
              children: [
                const CircleAvatar(
                  radius: 100,
                  foregroundImage: AssetImage('assets/images/avatar.png')
                  ),
                const SizedBox(height: 20,),
                ValueListenableBuilder(valueListenable: widget.contact.name!, builder: (_,name,__){
                  return    Text(widget.contact.name!.value);
                }),
            
                const SizedBox(height: 20,),
                ValueListenableBuilder(valueListenable: widget.contact.phone, builder: (_,phone,__) =>  Text(widget.contact.phone.value != '' ? "Mobile: ${widget.contact.phone.value}" : '', style: const TextStyle( fontSize: 20), )),
               
                const SizedBox(height: 20,),
                ValueListenableBuilder(valueListenable: widget.contact.email!, builder: (_,email,__)=> Text(widget.contact.email?.value != '' ? "Email: ${widget.contact.email?.value}" : '', style: const TextStyle( fontSize: 20), )),
                TextButton(
                  onPressed: (){
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => ContactUpdatePage(contact: widget.contact,))
                    );
                  }, 
                  child:const Text("Edit")),
                

              ],
            ),
          ),
        
    
    );
  }
}