import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluxter/services/user.dart';
import 'package:image_picker/image_picker.dart';

class Edit extends StatefulWidget {
  const Edit({ Key? key }) : super(key: key);

  @override
  _EditState createState() => _EditState();
}

class _EditState extends State<Edit> {

  UserService _userService = UserService();

  File? _profileImage;
  File? _bannerImage;
  final picker = ImagePicker();

  String username = '';

  Future getImage(int type) async{
    
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);

    setState(() {
      if(pickedFile != null && type == 0){
        //foto de perfil
        _profileImage = File(pickedFile.path);
      }

      if(pickedFile != null && type == 1){
        //foto de perfil
        _bannerImage = File(pickedFile.path);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
        TextButton(
          onPressed: () async {
          await _userService.updateProfile(_bannerImage!, _profileImage!, username);
          // ignore: use_build_context_synchronously
          Navigator.pop(context);
        },
        style: TextButton.styleFrom(
        foregroundColor: Colors.black,
      ),
      child: const Text('Guardar'))
      ]),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical:20, horizontal: 50),
        child: Form(
          child: Column(
            children:[
              TextButton(
              onPressed: () => getImage(0),
              child: _profileImage == null ? const Icon(Icons.person) :
              Image.file(
                _profileImage!,
                height: 100,)),
              TextButton(
              onPressed: () => getImage(1),
              child: _bannerImage == null ? const Icon(Icons.person) :
              Image.file(
                _bannerImage!,
                height: 100,)),
              TextFormField(
              onChanged: (val) => setState((){
                username = val;
              }),
            )],
          )),
      ),
    );
  }
}