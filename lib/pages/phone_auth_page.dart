import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:project3/pages/home_screen.dart';

class Phoneverification extends StatefulWidget {
  const Phoneverification({Key? key}) : super(key: key);

  @override
  State<Phoneverification> createState() => _PhoneverificationState();
}

class _PhoneverificationState extends State<Phoneverification> {
  var verId;
  var phone;
  bool codeSent = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "SIGN IN",
          style: TextStyle(fontSize: 25),
        ),
        // backgroundColor: hexStringToColor("CB2B93"),
        elevation: 0,
        foregroundColor: Colors.white,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [
          Colors.white,
          Colors.green,
          Colors.red,
        ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 40,left: 20, right: 20),
            child: Column(
              children: [
                // logoWidget("assets/logo.png"),
                const SizedBox(
                  height: 130,
                  width: 180,
                  child: Image(
                      image: AssetImage("assets/logo.png",), fit: BoxFit.fill,),
                ),
                SizedBox(
                  height: 30,
                ),
                Text(
                  "Phone Authentication",
                  style: TextStyle(
                    fontSize: 25,
                    color: Color.fromARGB(255, 0, 0, 0),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      codeSent
                          ? OTPTextField(
                              length: 6,
                              width: MediaQuery.of(context).size.width,
                              fieldWidth: 30,
                              style: TextStyle(fontSize: 20),
                              textFieldAlignment: MainAxisAlignment.spaceAround,
                              fieldStyle: FieldStyle.underline,
                              onCompleted: (pin) {
                                verifyPin(pin);
                              },
                            )
                          : IntlPhoneField(
                              decoration: InputDecoration(
                                  labelText: 'Phone Number',
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(),
                                  )),
                              initialCountryCode: 'IN',
                              onChanged: (phoneNumber) {
                                setState(() {
                                  phone = phoneNumber.completeNumber;
                                });
                              },
                            ),
                      SizedBox(
                        height: 10,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          verifyPhone();
                        },
                        child: Text("Verify"),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> verifyPhone() async {
    
                              
    await FirebaseAuth.instance.verifyPhoneNumber(
      
        phoneNumber: phone,
        verificationCompleted: (PhoneAuthCredential credential) async {
          // Navigator.of(context).pop();
          await FirebaseAuth.instance.signInWithCredential(credential);

          // Navigator.of(context).pop();

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HomeScreen(),
            ),
          );
          final snackBar = SnackBar(content: Text("Login Success"));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        },
        verificationFailed: (FirebaseAuthException e) {
          final snackBar = SnackBar(content: Text("${e.message}"));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        },
        codeSent: (verficationId, resendToken) {
          setState(() {
            codeSent = true;
            verId = verficationId;
          });
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          setState(() {
            verId = verificationId;
          });
        },
        timeout: Duration(seconds: 60));
  }

  void verifyPin(String pin) async {
    
    // showDialog(
    //                           context: context,
    //                           builder: (context) {
    //                             return const Center(
    //                               child: CircularProgressIndicator(),
    //                             );
    //                           });


    
    PhoneAuthCredential credential =
        PhoneAuthProvider.credential(verificationId: verId, smsCode: pin);

    try {
      await FirebaseAuth.instance.signInWithCredential(credential);
      final snackBar = SnackBar(content: Text("Login Success"));

      // Navigator.of(context).pop();
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen()
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } on FirebaseAuthException catch (e) {
      final snackBar = SnackBar(content: Text("${e.message}"));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
  
}
