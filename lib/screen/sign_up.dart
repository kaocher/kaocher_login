import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kaocher_firebase/helper/custom_button.dart';
import 'package:kaocher_firebase/helper/custom_text_field.dart';
import 'package:kaocher_firebase/screen/log_in.dart';
import 'package:kaocher_firebase/utills/all_color.dart';
class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}
final _auth= FirebaseAuth.instance;
GlobalKey<FormState> _formKeySignUp=GlobalKey();
AllColor allColor= AllColor();
TextEditingController _emailController= TextEditingController();
TextEditingController _passController= TextEditingController();
TextEditingController _comfirmPassController= TextEditingController();

class _SignUpState extends State<SignUp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: _formKeySignUp,
          child: Column(
            children: [
              SizedBox(
                height: 80,
              ),
              Icon(Icons.star,
                size: 80,color: allColor.appColor,),
              SizedBox(
                height: 20,
              ),
              CustomTextField(
                hintText: "Enter your email",
                labelText: "Email",
                controller: _emailController,
                obsecueVal: false,
              ),
              SizedBox(
                height: 15,
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
                  _passController.text, context);
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
void signUp(String email, String password, context)async{
  if(_formKeySignUp.currentState!.validate()){
    await _auth.createUserWithEmailAndPassword
      (email: email, password: password).then((value) => {

        Fluttertoast.showToast(msg: "SignUp Successful! "),
      Navigator.push(context,
          MaterialPageRoute(builder: (context)=>LogIn()))
    }).catchError((e){
      Fluttertoast.showToast(msg:e.message);
    });
  }
}