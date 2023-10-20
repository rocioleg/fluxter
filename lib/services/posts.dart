import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluxter/models/post.dart';
import 'package:fluxter/services/user.dart';
//import 'package:firebase_core/firebase_core.dart';

class PostService{

  //Por parametro le llega un conj de documentos obtenidos por 
  //una consulta a la BD 
  List<PostModel> postListFromSnapsShot(QuerySnapshot snapshot){
    //Acá mapea cada documento que hay dentro del snapshot a un tipo de objeto PostModel
    //y esto va a devolver una lista de objetos PostModel que representan los
    //posts encontrados en snapshot
    return snapshot.docs.map((doc){
      //Para solucionar el error de que no se sabe qué tipo de dato espera doc.data()
      // Convierte a Map<String, dynamic>
      final data = doc.data() as Map<String, dynamic>; 
      
      return PostModel(
        id: doc.id,
        text: data['text'] ?? '',
        img: data['img'] ?? '',
        creator: data['creator'] ?? '',
        timestamp: data['timestamp'] ?? 0,
      );
    }).toList();
  }

  //Agrega un nuevo documento a la coleccion -posts- de la BD 
  //agregando el texto q se pasa por parametro, el uid y la fecha determinada
  Future guardarPost(text, img) async{
    await FirebaseFirestore.instance.collection("posts").add({
      'text': text,
      'img': img,
      'creator': FirebaseAuth.instance.currentUser?.uid,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  Future likePost(PostModel post, bool current) async{
    if(current){
      await FirebaseFirestore.instance
      .collection('posts')
      .doc(post.id)
      .collection('likes')
      .doc(FirebaseAuth.instance.currentUser?.uid)
      .delete();
    }

    if(!current){
      await FirebaseFirestore.instance
      .collection('posts')
      .doc(post.id)
      .collection('likes')
      .doc(FirebaseAuth.instance.currentUser?.uid)
      .set({});
    }
  }

  Stream<bool> getCurrentUserLike(PostModel post){
    return FirebaseFirestore.instance
      .collection('posts')
      .doc(post.id)
      .collection('likes')
      .doc(FirebaseAuth.instance.currentUser?.uid)
      .snapshots()
      .map((snapshot) {return snapshot.exists;});
  }


  //Hace una consulta a la coleccion -posts- de la BD
  //donde coincida el uid con -creator-
  Stream<List<PostModel>> getPostsByUser(uid){
    return FirebaseFirestore.instance
    .collection("posts")
    .where('creator', isEqualTo: uid)
    //Con esta funcion se "escuchan" los cambios que se van realizando en la BD
    .snapshots()
    //Se transforma el QuerySnapShot en una lista de objetos PostModel
    .map(postListFromSnapsShot);
  }

/*
Future<List<PostModel>> getFeed() async {
  List<String> usersFollowing = await UserService().getUserFollowing(FirebaseAuth.instance.currentUser?.uid);
  QuerySnapshot querySnapshot = await FirebaseFirestore.instance
      .collection('posts')
      .where('creator', whereIn: usersFollowing)
      .orderBy('timestamp', descending: true)
      .get();
  return postListFromSnapsShot(querySnapshot);
}
*/

Stream<List<PostModel>> getFeed() {
  // Primero, obtén la lista de usuarios que estás siguiendo de manera asíncrona
  return Stream.fromFuture(UserService().getUserFollowing(FirebaseAuth.instance.currentUser?.uid))
    .asyncMap((usersFollowing) async {
      // Ahora, obtén los posts de los usuarios que estás siguiendo
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('posts')
          .where('creator', whereIn: usersFollowing)
          .orderBy('timestamp', descending: true)
          .get();
      return postListFromSnapsShot(querySnapshot);
    });
}



}