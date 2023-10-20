//import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluxter/screens/wrapper/wrapper.dart';
import 'package:fluxter/services/auth.dart';
import 'package:provider/provider.dart';
import 'package:fluxter/models/user.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamProvider<UserModel>.value(
      value: AuthService().user,
      initialData: UserModel(id: '', bannerImageUrl: '', profileImageUrl: '',email: '', username: ''),
      child: const MaterialApp(debugShowCheckedModeBanner: false,home: Wrapper()),
      );
      
  }
}
