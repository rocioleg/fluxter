import 'package:flutter/material.dart';
import 'package:fluxter/models/user.dart';
import 'package:fluxter/screens/autentificacion/registrarse.dart';
import 'package:fluxter/screens/main/home.dart';
import 'package:fluxter/screens/main/posts/add.dart';
import 'package:fluxter/screens/main/profile/edit.dart';
import 'package:fluxter/screens/main/profile/perfil.dart';
import 'package:provider/provider.dart';

//Aca usamos un plugin -provider- para simplificar el manejo de los estados del 
//usuario y obtener toda la informacion desde acá
class Wrapper extends StatelessWidget{
  const Wrapper ({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModel>(context);

    if(user.id == 'null'){
      return const Registrarse();
    }
    
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes:{
        '/' :(context) => const Home(),
        '/add':(context) => const Add(),
        '/perfil':(context) => const Perfil(),
        '/edit':(context) => const Edit(),
      }
    );
    
  }
}