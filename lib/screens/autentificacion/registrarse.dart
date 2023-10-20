import 'package:flutter/material.dart';
 import 'package:fluxter/services/auth.dart';

class Registrarse extends StatefulWidget{
  //Constructor
  // Con key? se indica que puede ser null
  const Registrarse({Key? key}) : super(key: key);

  //Método
  //Se crea una instancia de _registrarseState
  @override
  _RegistrarseState createState() => _RegistrarseState();

}

//Esta clase maneja el estado de Registrarse
class _RegistrarseState extends State<Registrarse>{

  //Se crea una instancia de AuthService para la autenticación
  final AuthService _authService = AuthService();

  String email = '';
  String password= '';

  //Aca iria todo lo rel a la UI de registro
  @override 
    Widget build(BuildContext context){
      return Scaffold(
        //Propiedad-es AppBar
        appBar: AppBar(
          backgroundColor: Colors.blue,
          elevation: 8, // sombreado
          title: const Text("Registrarse")
        ),

        //Propiedad-es Body
        body: Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 50),
          child: Form(
            child: Column(
              children: [
                TextFormField(
                  decoration: const InputDecoration(
                    hintText: 'Ingresa tu email',
                    border: OutlineInputBorder(),
                    // <-- Aquí se agrega el sombreado
                    hintStyle: TextStyle(color: Colors.black),
                  ),
                  onChanged: (val) => setState(() {
                    email = val;
                  }),
                ),


                TextFormField(
                  decoration: const InputDecoration(
                    hintText: 'Ingresa tu contraseña',
                    border: OutlineInputBorder(),
                    // <-- Aquí se agrega el sombreado
                    hintStyle: TextStyle(color: Colors.black),
                  ),
                  onChanged: (val) => setState(() {
                    password = val;
                  }),
                ),
                //Cuando se precionan los botones, se llaman a los metodos de authService
                ElevatedButton(onPressed: () async => {_authService.registrarse(email, password)}, child: const Text("Registrarse")),
                ElevatedButton(onPressed: () async => {_authService.iniciarSesion(email, password)}, child: const Text("Iniciar Sesion")),
              ],
            )),
        ),
      );
    }
}