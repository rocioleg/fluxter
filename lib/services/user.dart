import 'dart:collection';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluxter/models/user.dart';
import 'package:fluxter/services/utils.dart';

class UserService{
  UtilsService utilsService = UtilsService();
  
  List<UserModel> userListFromQuerySnapshot(QuerySnapshot snapshot){
    return snapshot.docs.map((doc){
      //Para solucionar el error de que no se sabe qué tipo de dato espera doc.data()
      // Convierte a Map<String, dynamic>
      final data = doc.data() as Map<String, dynamic>; 
      
      return UserModel(
        id: doc.id,
        profileImageUrl: data['profileImageUrl'] ?? '',
        bannerImageUrl: data['bannerImageUrl'] ?? '',
        email: data['email'] ?? '',
        username: data['username'] ?? ''
      );
    }).toList();
  }

  UserModel userFromFirebaseSnapshot(DocumentSnapshot snapshot){
    
    //Me da error si quiero retornar null...

    final data = snapshot.data() as Map<String, dynamic>;
    return 
    
      UserModel(
        id: data['id'],
        bannerImageUrl: data['bannerImageUrl'],
        profileImageUrl: data['profileImageUrl'],
        email: data['email'],
        username: data['username']
      );

  }

  Stream<UserModel> getUserInfo(uid){

    return FirebaseFirestore.instance
    .collection('users')
    .doc(uid)
    .snapshots()
    .map(userFromFirebaseSnapshot);
  }

  Stream<List<UserModel>> queryByName(){

    return FirebaseFirestore.instance
    .collection('users')
    .orderBy('username')
    .limit(10)
    .snapshots()
    .map(userListFromQuerySnapshot);
  }  


  Future<void> updateProfile(File bannerImage, File profileImage, String username) async{
    
    String bannerImageUrl = '';
    String profileImageUrl= '';

    if(bannerImage != null){
      //Guardar el banner en la BD
      bannerImageUrl = await utilsService.uploadFile(bannerImage,'user/profile/${FirebaseAuth.instance.currentUser?.uid}/banner');
    }
    if(profileImage != null){
      //Guardar la foto de perfil en la BD
      profileImageUrl = await utilsService.uploadFile(profileImage,'user/profile/${FirebaseAuth.instance.currentUser?.uid}/profilepic');

    }

    Map<String, Object> data = HashMap();

    if(username != '') data['username'] = username;
    if(bannerImageUrl != '') data['bannerImageUrl'] = bannerImageUrl;
    if(profileImageUrl != '') data['profileImageUrl'] = profileImageUrl;

    await FirebaseFirestore.instance.collection('users')
    .doc(FirebaseAuth.instance.currentUser?.uid)
    .update(data);

  }

  Stream<bool> isFollowing(uid, otherId){

    return FirebaseFirestore.instance
    .collection('users')
    .doc(uid)
    .collection('following')
    .doc(otherId)
    .snapshots()
    .map((snapshot){
      return snapshot.exists;
    });
  } 

  Future<void> followUser(uid) async{
    await FirebaseFirestore.instance
    .collection('users')
    .doc(FirebaseAuth.instance.currentUser?.uid)
    .collection('following')
    .doc(uid)
    .set({});

    await FirebaseFirestore.instance
    .collection('users')
    .doc(uid)
    .collection('followers')
    .doc(uid)
    .set({});
  }

    //Serian todos los users de la bd
Future<List<String>> getUserFollowing(uid) async{
    QuerySnapshot querySnapshot = (await FirebaseFirestore.instance
    .collection('users')
    .get());
    final users = querySnapshot.docs.map((doc) => doc.id).toList();
    return users;
}
}