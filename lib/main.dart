import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

import 'myTask.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
      
        primarySwatch: Colors.lightBlue,
      ),
      home: MyHomePage(),
    );
  }
}
 
class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}


class _MyHomePageState extends State<MyHomePage> {

final FirebaseAuth firebaseauth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = new GoogleSignIn();

Future<FirebaseUser> _signIn() async {
    GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;
    
    AuthCredential credential = GoogleAuthProvider.getCredential(
    accessToken: googleSignInAuthentication .accessToken,
    idToken: googleSignInAuthentication .idToken,
  );

  final AuthResult authResult = await  firebaseauth.signInWithCredential(credential);
  FirebaseUser firebaseUser = authResult.user;
  print("signed in " + firebaseUser.displayName);
  

  

    Navigator.of(context).push(
    new MaterialPageRoute(
      builder: (BuildContext context)=> new MyTask(user:firebaseUser,googleSignIn:googleSignIn,)
       ),
       
  );
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/images/bluewhite.jpg"),
              fit: BoxFit.cover),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            
            new Image.asset("assets/images/image.png", width: 450, height: 450),
            
            new Padding(
              padding: const EdgeInsets.only(bottom: 30.0),
            ),
            InkWell(
              onTap: () {
                _signIn();
              },
              child: new Image.asset(
                "assets/images/google.png",
                width: 300.0,
              ),
            )
          ],
        ),
      ),
    );
  }
}
