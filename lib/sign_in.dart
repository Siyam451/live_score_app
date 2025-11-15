import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:live_score_app/home_screen.dart';
import 'package:live_score_app/sign_up.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  TextEditingController _emailTEController = TextEditingController();
  TextEditingController _passwordTEController = TextEditingController();
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  bool _signinInprogress = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text('Sign In'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
            key:  _formkey,
            child: Center(
              child: Column(
                children: [
                  TextFormField(
                      controller: _emailTEController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        hintText: ' Student Email',
                        suffixIcon: Icon(Icons.email),
                      ),
                      validator: (String? value){
                        if(value?.trim().isEmpty ?? true){
                          return 'Enter valid email';
                        }
                        return null;
                      }
                  ),

                  SizedBox(height: 10,),

                  TextFormField(
                      controller: _passwordTEController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        hintText: ' Student Password',
                        suffixIcon: Icon(Icons.remove_red_eye),
                      ),
                      validator: (String? value){
                        if(value?.trim().isEmpty ?? true){
                          return 'Enter valid password';
                        }
                        return null;
                      }
                  ),



                  SizedBox(height: 20,),

                  Visibility(
                    visible: _signinInprogress== false,
                    replacement: Center(child: CircularProgressIndicator(),),
                    child: FilledButton(onPressed:
                    _onTapSubmitButton, child: Text('Login')),
                  ),
                  SizedBox(height: 10,),
                  Visibility(
                    visible: _signinInprogress== false,
                    replacement: Center(child: CircularProgressIndicator(),),
                    child:FilledButton(onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (ctx)=>SignUp()));
                    }, child: Text('Sign up')),
                  ),




                ],
              ),
            )),
      ),
    );
  }
  void _onTapSubmitButton(){
    if(_formkey.currentState!.validate()){
      _loginNewuser();
    }
  }


  Future<void> _loginNewuser()async{
    _signinInprogress = true;
    setState(() {

    });
    try{
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailTEController.text.trim(),
          password: _passwordTEController.text
      );
      showSnackbar('Login successfull');
      Navigator.push(context, MaterialPageRoute(builder: (context)=> HomeScreen()));
    } on FirebaseAuthException catch(e){
      if(e.code =='user-not-found') {
        showSnackbar('No user found for that email.');
    } else if (e.code == 'wrong-password') {
        showSnackbar('Wrong password provided for that user.');
    }
    }
    _signinInprogress = false;
    setState(() {

    });
  }
  void showSnackbar(String massage){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(massage)));
  }
}


