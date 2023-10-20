import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluxter/models/user.dart';

class AuthService {

  FirebaseAuth auth = FirebaseAuth.instance;

  //Este método convierte un objeto de tipo User de Firebase Authentication 
  //en un objeto UserModel personalizado. 
  //Si user es nulo, devuelve null.

  //UserModel userFromFirebaseUser(User user){
  //  return user != null ? UserModel(id: user.uid) : null;
  //}

  UserModel userFromFirebaseUser(User? user){
    return user != null ? UserModel(id: user.uid, bannerImageUrl: '', profileImageUrl: '',email: '',username: '') : UserModel(id: 'null', bannerImageUrl: '', profileImageUrl: '',email: '',username: '');
  }

  //Propiedad que retorna un Stream que se usa para
  //"escuchar" los cambios en el estado de autentif
  //Cuando el usuario inicie sesion o se registre, emite un objeto UserModel actualizado
  Stream<UserModel> get user{
    return auth.authStateChanges().map(userFromFirebaseUser);
  }

  //No sé en que momento se va a llamar por eso -Future-
  Future registrarse(email, password) async {
      try {
    UserCredential user = (await auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    ));

    await FirebaseFirestore.instance
    .collection('users')
    .doc(user.user?.uid)
    .set({'username': email, 'email': email});

    //Se llama al metodo para obtener un UserModel con ese user
    userFromFirebaseUser(user.user);

  } on FirebaseAuthException catch (e) {
    if (e.code == 'weak-password') {
      print('The password provided is too weak.');
    } else if (e.code == 'email-already-in-use') {
      print('The account already exists for that email.');
    }
  } catch (e) {
    print(e);
  }
}

  Future iniciarSesion(email, password) async {
      try {
    User user = (await auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    )) as User;

    userFromFirebaseUser(user);

  } on FirebaseAuthException catch (e) {
    print(e);
  } catch (e) {
    print(e);
  }
}


//Cuando se llama a este metodo. Stream<UserModel> se va a activar
//haciendo que el metodo userModelFromFireBase detecte que el usuario sea null
//lo cual lo llevaria a registrarse (logica en wrapper)
Future cerrarSesion() async {
  try{
    return await auth.signOut();
  }catch(e){
    print(e.toString());
    return null;
  }
}

}