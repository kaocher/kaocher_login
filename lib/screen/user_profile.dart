import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kaocher_firebase/model/user_model.dart';
import 'package:kaocher_firebase/screen/log_in.dart';
class UserProfile extends StatefulWidget {
  const UserProfile({Key? key}) : super(key: key);

  @override
  _UserProfileState createState() => _UserProfileState();
}
String? url;
File? image;
User? user=FirebaseAuth.instance.currentUser;


class _UserProfileState extends State<UserProfile> {
  Future getImageFromStorage() async {
    final ref = FirebaseStorage.instance.ref().child('image/id1');
    url = await ref.getDownloadURL();
    setState(() {
      url;
    });
  }
    UserModel userModel = UserModel();


  @override
  void initState() {
    super.initState();
    getImageFromStorage();
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
            Container(
              height: 150,
              width: 150,
              child: ClipOval(
                child: url==null? Text("Image not found"):
                Image.network(url!,
                fit: BoxFit.cover,),
              ),
            ),
            ElevatedButton(onPressed: () async {
                final image2= await ImagePicker().pickImage(source: ImageSource.gallery);
                if(image2==null) return;
                final tempImage= File(image2.path);
                setState(() {
                  image= tempImage;
                });
                saveImage();
                getImageFromStorage();
                setState(() {
                  url;
                });
            },
                child: Text("Change Picture")),
            ElevatedButton(onPressed: (){

            },
                child: Text("Refresh")),

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
  void saveImage()async{
    if(image==null) return;
    final destination= 'image/id1';
    final ref= FirebaseStorage.instance.
    ref(destination);
    ref.putFile(image!);
  }
}
