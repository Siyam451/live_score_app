import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:live_score_app/sign_in.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController _emailTEController = TextEditingController();
  TextEditingController _passwordTEController = TextEditingController();
  TextEditingController _confirmpasswordTEController = TextEditingController();
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  bool _signupInprogress = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text('Sign up'),
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
                      hintText: 'Email',
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
                      hintText: ' set Password',
                      suffixIcon: Icon(Icons.remove_red_eye),
                    ),
                    validator: (String? value){
                      if(value?.trim().isEmpty ?? true){
                        return 'Enter valid password';
                      }
                      return null;
                    }
                ),
                SizedBox(height: 10,),

                TextFormField(
                    controller: _confirmpasswordTEController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      hintText: 'Confirm Password',
                      suffixIcon: Icon(Icons.remove_red_eye),
                    ),
                    validator: (String? value){
                      if(value?.trim().isEmpty ?? true){
                        return 'Enter valid confirm password';
                      }else if(value! != _passwordTEController.text){
                        return 'Confirm password does not match';
                      }
                      return null;
                    }
                ),

                SizedBox(height: 20,),

                Visibility(
                  visible: _signupInprogress== false,
                  replacement: Center(child: CircularProgressIndicator(),),
                  child: FilledButton(onPressed: _onTapSubmitButton, child: Text('Submit')),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onTapSubmitButton(){
    if(_formkey.currentState!.validate()){
      _createNewUser();
    }
  }

  Future<void> _createNewUser() async {
    _signupInprogress = true;
    setState(() {});

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailTEController.text.trim(),
        password: _passwordTEController.text,
      );
      showSnackbar('User register successfull');
      Navigator.push(context, MaterialPageRoute(builder: (context)=> SignIn()));

    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        showSnackbar('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        showSnackbar('The account already exists for that email.');
      } else if (e.code == 'invalid-email') {
        showSnackbar('The email address is invalid.');
      } else {
        showSnackbar(e.message ?? 'Authentication error');
      }
    } catch (e) {
      showSnackbar(e.toString());
    }

    _signupInprogress = false;
    setState(() {});
  }

  void showSnackbar(String massage){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(massage)));
  }
}
