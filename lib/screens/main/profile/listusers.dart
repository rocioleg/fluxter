//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluxter/models/user.dart';
import 'package:fluxter/services/user.dart';

class Listusers extends StatefulWidget {
  const Listusers({ Key? key }) : super(key: key);

  @override
  _ListusersState createState() => _ListusersState();
}

class _ListusersState extends State<Listusers> {
  late Stream<List<UserModel>> usersStream;
  late Stream<bool> isfollowing;
  
  @override
  void initState() {
    super.initState();
    // Crea una instancia de la clase UserService.
    final userService = UserService();
    // Inicializa el Stream de usuarios.
    usersStream = userService.queryByName();
  }

@override
Widget build(BuildContext context) {
  final Object? uid = ModalRoute.of(context)?.settings.arguments;
  final userService = UserService();
  isfollowing = userService.isFollowing(FirebaseAuth.instance.currentUser?.uid, uid);
  
  //print("EL ID MIO ES: " + (FirebaseAuth.instance.currentUser?.uid).toString());
  //print("EL ID OTRO ES: " + (uid).toString());

  return StreamBuilder<List<UserModel>>(
    stream: usersStream,
    builder: (context, snapshot) {
      if (snapshot.hasError) {
        // Maneja el error.
        return const Text('Ocurrió un error.');
      }
      if (!snapshot.hasData) {
        // Muestra un indicador de carga.
        return const CircularProgressIndicator();
      }

      final users = snapshot.data!;

      // Construye la lista de usuarios.
      return ListView.builder(
        //scroll true
        shrinkWrap: true,
        //cuantos elementos muestra
        itemCount: users.length,
        itemBuilder: (context, index) {
          final user = users[index];
          return InkWell(
            /* 
            onTap: () => Navigator.pushNamed(context, '/perfil', arguments: user.id),
            */
            child: Column(
              children: [
                //profile img e info del user
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    children: [
                      user.profileImageUrl != ''
                          ? CircleAvatar(
                              radius: 20,
                              backgroundImage: NetworkImage(user.profileImageUrl),
                            )
                          : const Icon(Icons.person, size: 40),
                          const SizedBox(width: 10,),
                          Text(user.username),
                          const SizedBox(width: 40,),

                          if(FirebaseAuth.instance.currentUser?.uid != uid)
                          TextButton(
                            onPressed: (){
                            },
                            child: const Text("Follow"))
                    ],
                  ),
                ),
                //
                const Divider(thickness: 1),
              ],
            ),
          );
        },
      );
    },
  );
}
}