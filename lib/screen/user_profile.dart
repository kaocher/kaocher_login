import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kaocher_firebase/model/user_model.dart';
import 'package:kaocher_firebase/screen/log_in.dart';
class UserProfile extends StatefulWidget {
  const UserProfile({Key? key}) : super(key: key);

  @override
  _UserProfileState createState() => _UserProfileState();
}
User? user=FirebaseAuth.instance.currentUser;

class _UserProfileState extends State<UserProfile> {
  UserModel userModel= UserModel();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value){
      this.userModel= UserModel.fromMap(value.data());
      setState(() {

      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("User Profile"),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
            CircleAvatar(
              radius: 60,
              backgroundColor: Colors.pink,
            ),

            Text("Name: ${userModel.name.toString()}",
            style: TextStyle(
              fontSize: 25
            ),),
            Text("Age: ${userModel.age.toString()}",
              style: TextStyle(
                  fontSize: 25
              ),),
            Text("Phone: ${userModel.phone.toString()}",
              style: TextStyle(
                  fontSize: 25
              ),),
            Text("Email: ${userModel.email.toString()}",
              style: TextStyle(
                  fontSize: 25
              ),),
            SizedBox(
              height: 30,
            ),
            ElevatedButton(
                onPressed: (){
                  FirebaseAuth.instance.signOut();
                  Navigator.pushReplacement(context, MaterialPageRoute
                    (builder: (context)=>LogIn()));
                },
                child: Text("Log Out"))
          ],
        ),
      ),
    );
  }
}