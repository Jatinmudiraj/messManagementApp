import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project3/auth/firebase_auth_service.dart';
import 'package:project3/pages/home_screen.dart';
import 'package:project3/pages/login_screen.dart';
import 'package:project3/pages/signup_screen.dart';
import 'package:project3/widgets/customized_button.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
        decoration: const BoxDecoration(
            image: DecorationImage(image: AssetImage("assets/background.png"))),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const SizedBox(
                  height: 130,
                  width: 180,
                  child: Image(
                      image: AssetImage("assets/logo.png"), fit: BoxFit.fill),
                ),
                const SizedBox(height: 150),
                CustomizedButton(
                  buttonText: "Login",
                  buttonColour: Colors.black,
                  textColour: Colors.white,
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => const LoginScreen()));
                  },
                ),
                CustomizedButton(
                  buttonText: "Register",
                  buttonColour: Colors.white,
                  textColour: Colors.black,
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const SignUpScreen()));
                  },
                ),
                
                // CustomizedButton(
                //   buttonText: "Continue as Guest",
                //   buttonColour: Colors.green,
                //   textColour: Colors.white,
                //   onPressed: () async {
                //     //  The else part is not working in the video because we have
                //     //  enclosed it in the try catch block. Once we have error in
                //     // login the firebase exception is thrown and the codeblock after that
                //     // error is skiped and code of catch block is executed.
                //     // if we want our else part to be executed we need to get rid from
                //     // this try catch or add that code in catch block.

                //     try {
                //       await FirebaseAuthService().getOrCreateUser();

                //       if (FirebaseAuth.instance.currentUser == null) {
                //         Navigator.push(
                //             context,
                //             MaterialPageRoute(
                //                 builder: (context) => const HomeScreen()));
                //       }

                //       //  This code is gone inside the catch block
                //       // which is executed only when we have firebaseexception
                //       //  else {
                //       //   showDialog(
                //       //       context: context,
                //       //       builder: (context) => AlertDialog(
                //       //               title: Text(
                //       //                   " Invalid Username or password. Please register again or make sure that username and password is correct"),
                //       //               actions: [
                //       //                 ElevatedButton(
                //       //                   child: Text("Register Now"),
                //       //                   onPressed: () {
                //       //                     Navigator.push(
                //       //                         context,
                //       //                         MaterialPageRoute(
                //       //                             builder: (context) =>
                //       //                                 SignUpScreen()));
                //       //                   },
                //       //                 )
                //       //               ]));

                //       // }
                //     } on FirebaseException catch (e) {
                //       debugPrint("error is ${e.message}");
                //     }

                //     // Navigator.push(context,
                //     //     MaterialPageRoute(builder: (_) => const LoginScreen()));
                //   },
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
