import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluxter/services/posts.dart';
import 'package:image_picker/image_picker.dart';

class Add extends StatefulWidget{
  const Add({super.key});

  @override
  _AddState createState() => _AddState();
}

class _AddState extends State<Add>{
  String text = '';
  String imageUrl = '';
  final PostService _postService = PostService();

  @override
  Widget build(BuildContext context){
    return Scaffold(

      appBar: AppBar(
        title: const Text('Tweet'),
        actions: <Widget>[

          TextButton(
            onPressed: () async {
              _postService.guardarPost(text, imageUrl);
              //Vuelve a la screen anterior
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.white),
            child: const Text('Tweet'))
      ],
      ),


      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        child: Column( 
        children: [
          Form(
            child: TextFormField(
              onChanged: (val) {
                setState((){
                  text = val;
                });})
          ),
          TextButton(
            onPressed: () async {
              // logica para cargar la foto etc
              // 1 sacar foto
              ImagePicker imagePicker = ImagePicker();
              XFile? file = await imagePicker.pickImage(source: ImageSource.camera);
              //
              String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();
              // 2 Guardar file en la bd
              Reference referenceRoot = FirebaseStorage.instance.ref();
              Reference referenceDirImages = referenceRoot.child('postimg');

              Reference referenceImageToUpload = referenceDirImages.child(uniqueFileName);

              //
              try{
                //Subir archivo a Storage
                await referenceImageToUpload.putFile(File(file!.path));
                //Obtener el download URL 
                imageUrl = await referenceImageToUpload.getDownloadURL();

              }catch(error){
                //
              }
      
              //


            },
            child: const Text('Subir Imagen'))
        ],)
      )
    );
  }

}