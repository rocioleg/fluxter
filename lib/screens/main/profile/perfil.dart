import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluxter/models/user.dart';
import 'package:fluxter/screens/main/posts/listposts.dart';
import 'package:fluxter/services/posts.dart';
import 'package:fluxter/services/user.dart';
import 'package:provider/provider.dart';

class Perfil extends StatefulWidget{
  const Perfil({super.key});

  @override
  _PerfilState createState() => _PerfilState();

}

class _PerfilState extends State<Perfil>{
  final PostService _postService = PostService();
  final UserService userService = UserService();

  @override
  Widget build(BuildContext context) {
    
    return MultiProvider(
      providers: [
        StreamProvider.value(
        value: _postService.getPostsByUser(FirebaseAuth.instance.currentUser?.uid),
        initialData: ''
        ),
        StreamProvider.value(
        value: userService.getUserInfo(FirebaseAuth.instance.currentUser?.uid),
        initialData: ''
        )
      ],
      
      child: Scaffold(
        body: DefaultTabController(
          length: 2,
          child: NestedScrollView(headerSliverBuilder: (context,_){
            return[
              SliverAppBar(
                
                floating: false,
                pinned: true,
                expandedHeight: 130,
                flexibleSpace: FlexibleSpaceBar(

                  //IMAGEN DEL BANNER
                  background: CachedNetworkImage(
                    imageUrl: Provider.of<UserModel>(context).bannerImageUrl,
                    fit: BoxFit.cover,
                  )
                  
                  /*Image.network(
                        Provider.of<UserModel>(context).bannerImageUrl,
                        fit: BoxFit.cover,
                  )*/


                 ),
                ),
              SliverList(delegate: SliverChildListDelegate(
                [
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),

                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CachedNetworkImage(
                              imageUrl: Provider.of<UserModel>(context).profileImageUrl,
                              width: 60,
                              height: 60,),
                            //IMAGEN DE PERFIL
                            //Image.network(Provider.of<UserModel>(context).profileImageUrl, height: 60)                            ,                         
                              
                              //Boton para editar perfil
                              TextButton(onPressed: () { 
                                Navigator.pushNamed(context, '/edit');
                              },
                        child: const Text('Editar Perfil'))
                        ],),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                          ),
                        )
                      ],
                    ),
                  )
                ]
              ))
            ];
          }, body: const ListPosts(),
        )
      )
     )
    );


  }

}