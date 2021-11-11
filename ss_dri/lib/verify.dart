import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:formaciondelideres/Student.dart';

class Verify extends StatefulWidget {
  @override
  _VerifyState createState() => _VerifyState();
}

class _VerifyState extends State<Verify> {
  final auth = FirebaseAuth.instance;
  User user;
  Timer timer;

  @override
  void initState() {
    user = auth.currentUser;
    try{
      user.sendEmailVerification();
    }catch (e) {
        print("An error occured while trying to send email verification");
        print(e.message);
     }
    

    timer = Timer.periodic(Duration(seconds: 5), (timer) {
      checkEmailVerified();
    });
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Un correo se envió a ${user.email}, por favor verificalo'
        ),
      ),
    );
  }

  Future<void>  checkEmailVerified() async {
    user = auth.currentUser;
    await user.reload();
    if(user.emailVerified){
      timer.cancel();
      Navigator.of(context)
      .pushReplacement(MaterialPageRoute(builder: (context) => StudentHome()));
    }
  }
}