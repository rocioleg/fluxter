import 'package:flutter/material.dart';
import 'package:fluxter/screens/main/profile/listusers.dart';
import 'package:fluxter/services/user.dart';
import 'package:provider/provider.dart';

class Search extends StatefulWidget {
  const Search({ Key? key }) : super(key: key);

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  UserService userService = UserService();
  String search = '';
  
  get initialData => null;

  @override
  Widget build(BuildContext context) {
    return StreamProvider.value(value: userService.queryByName(),
    initialData: initialData,
    child: const Column(
      children: [
        Padding(
        padding:  EdgeInsets.all(10),
        /*
        child: TextField(
          onChanged: (text){
            setState(() {
              search = text;
            });
          },
          decoration: const InputDecoration(
            hintText: 'Buscar...'
          ),
        ),
        */
        ),
         Listusers()
      ],
    ),);
  }
}