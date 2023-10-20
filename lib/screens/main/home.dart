import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluxter/screens/home/feed.dart';
import 'package:fluxter/screens/home/search.dart';
import 'package:fluxter/services/auth.dart';

class Home extends StatefulWidget {
  const Home({ Key? key }) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  
  final AuthService authService = AuthService();
  int currentIndex = 0;
  final List<Widget> children =[
    const Feed(), const Search()
  ];

  void onTabPressed(int index){
    setState(() {
      currentIndex = index;
    }); 
  }
  
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/add');
          },
        child: const Icon(Icons.add)),
        drawer: Drawer(
         child: ListView(
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text('Fluxter', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),)
              ),
              ListTile(
                  title: const Text('Perfil'),
                  onTap: (){
                  Navigator.pushNamed(context, '/perfil', arguments: FirebaseAuth.instance.currentUser?.uid);
              },),
              ListTile(
                  title: const Text('Cerrar Sesión'),
                  onTap: (){
                  authService.cerrarSesion();
              },
            ),
          ],
         ), 
        ),
        bottomNavigationBar: 
        BottomNavigationBar(
          onTap: onTabPressed,
          currentIndex: currentIndex,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          items:const [
            BottomNavigationBarItem(icon: Icon(Icons.home),
            label: 'home'),
            BottomNavigationBarItem(icon: Icon(Icons.search),
            label: 'search') 
          ]),
          body: children[
            currentIndex
          ],
    );
  }
}
