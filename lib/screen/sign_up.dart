import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kaocher_firebase/helper/custom_button.dart';
import 'package:kaocher_firebase/helper/custom_text_field.dart';
import 'package:kaocher_firebase/model/user_model.dart';
import 'package:kaocher_firebase/screen/log_in.dart';
import 'package:kaocher_firebase/screen/verify_email.dart';
import 'package:kaocher_firebase/utills/all_color.dart';
class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}
final _auth= FirebaseAuth.instance;

AllColor allColor= AllColor();
TextEditingController _emailController= TextEditingController();
TextEditingController _passController= TextEditingController();
TextEditingController _comfirmPassController= TextEditingController();
TextEditingController _ageController= TextEditingController();
TextEditingController _phoneController= TextEditingController();
TextEditingController _nameController= TextEditingController();
File? image;

class _SignUpState extends State<SignUp> {
  final _formKeySignUp=GlobalKey<FormState>();


  Future pickImageFromGallery() async {
    final image2= await ImagePicker().pickImage(source: ImageSource.gallery);
    if(image2==null) return;
    final tempImage= File(image2.path);
    setState(() {
      image= tempImage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: _formKeySignUp,
          child: Column(
            children: [
              SizedBox(
                height: 40,
              ),
              InkWell(
                onTap: (){
                  pickImageFromGallery();
                },
                child: ClipOval(
                  child: image!=null?
                  Container(
                      height: 160,
                      width: 160,
                      child: Image.file(image!,
                        fit: BoxFit.cover,)):
                  Icon(Icons.camera_alt_outlined,
                    size: 25,),
                ),
              ),

              SizedBox(
                height: 20,
              ),
              CustomTextField(
                hintText: "Enter your full-name",
                labelText: "Name",
                controller: _nameController,
                obsecueVal: false,
              ),
              SizedBox(
                height: 20,
              ),
              CustomTextField(
                hintText: "Enter your phone number",
                labelText: "Phone",
                controller: _phoneController,
                obsecueVal: false,
              ),
              SizedBox(
                height: 20,
              ),
              CustomTextField(
                hintText: "Enter your age",
                labelText: "Age",
                controller: _ageController,
                obsecueVal: false,
              ),
              SizedBox(
                height: 15,
              ),
              CustomTextField(
                hintText: "Enter your email",
                labelText: "Email",
                controller: _emailController,
                obsecueVal: false,
              ),
              SizedBox(
                height: 20,
              ),


              CustomTextField(
                hintText: "Enter new password",
                labelText: "Password",
                controller: _passController,
                obsecueVal: true,
              ),
              SizedBox(
                height: 15,
              ),
              CustomTextField(
                hintText: "Re-enter your password",
                labelText: "Confirm Password",
                controller: _comfirmPassController,
                obsecueVal: true,
              ),
              SizedBox(
                height: 15,
              ),
              InkWell(
                onTap: (){
                  signUp(_emailController.text,
                      _passController.text,
                      context,
                      _formKeySignUp);
                },
                child: CustomButton(
                  height: 60,
                  width: 300,
                  btnText: "Sign Up",
                ),
              ),
              SizedBox(
                height: 15,
              ),

            ],
          ),
        ),
      ),
    );
  }
}
void signUp(String email, String password, context,_formKeySignUp)async{
  if(_formKeySignUp.currentState!.validate()){
    await _auth.createUserWithEmailAndPassword
      (email: email, password: password).then((value) => {
      saveUserDetails(),
      saveImage(),

      Fluttertoast.showToast(msg: "SignUp Successful! "),
      Navigator.push(context,
          MaterialPageRoute(builder: (context)=>VerifyEmailPage()))
    }).catchError((e){
      Fluttertoast.showToast(msg:e.message);
    });
  }
}
void saveImage()async{
  if(image==null) return;
  final destination= 'image/id1';
  final ref= FirebaseStorage.instance.
  ref(destination);
  ref.putFile(image!);
}
void saveUserDetails() async{
  FirebaseFirestore firestore1=
      FirebaseFirestore.instance;
  User? user= _auth.currentUser;

  UserModel userModel= UserModel();
  userModel.uid=user!.uid;
  userModel.email= _emailController.text;
  userModel.phone= _phoneController.text;
  userModel.age= _ageController.text;
  userModel.name= _nameController.text;

  await firestore1.collection("users")
      .doc(user.uid)
      .set(userModel.toMap());
  Fluttertoast.showToast(msg: "Data Saved Successfully");
}