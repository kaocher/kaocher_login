import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kaocher_firebase/screen/home_page.dart';
import 'package:kaocher_firebase/screen/user_profile.dart';

class VerifyEmailPage extends StatefulWidget {
  const VerifyEmailPage({Key? key}) : super(key: key);

  @override
  _VerifyEmailPageState createState() => _VerifyEmailPageState();
}
final _auth= FirebaseAuth.instance;
User? user;
Timer? timer;
class _VerifyEmailPageState extends State<VerifyEmailPage> {
  @override
  void initState() {
    super.initState();
    user= _auth.currentUser;
    user!.sendEmailVerification();
    timer= Timer.periodic(Duration(seconds: 5),
            (timer) {
      checkEmailVerification();
    });
  }
  @override
  void dispose() {
    timer!.cancel();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: 50,
          ),
          Text("Please verify your email")
        ],
      ),
    );
  }

  Future<void> checkEmailVerification() async{
    User? user= FirebaseAuth.instance.currentUser;
    await user!.reload();
    if(user!.emailVerified){
      timer!.cancel();
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context)=>UserProfile()));
    }
  }
}
