import 'package:chat_app_flutter/widgets/widgets.dart';
import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  TextEditingController usernameTEController = new TextEditingController();
  TextEditingController emailTEController = new TextEditingController();
  TextEditingController passwordTEController = new TextEditingController();
  TextEditingController confirmPassTEController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: usernameTEController,
                style: TextStyle(color: Colors.white),
                decoration: customTextFieldDecoration("Enter Username"),
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 12),
              TextField(
                controller: emailTEController,
                style: TextStyle(color: Colors.white),
                decoration: customTextFieldDecoration("Enter E-Mail"),
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 12),
              TextField(
                controller: passwordTEController,
                style: TextStyle(color: Colors.white),
                decoration: customTextFieldDecoration("Set Password"),
                obscureText: true,
              ),
              SizedBox(height: 12),
              TextField(
                controller: confirmPassTEController,
                style: TextStyle(color: Colors.white),
                decoration: customTextFieldDecoration("Confirm Password"),
                obscureText: true,
              ),
              SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {},
                style: ButtonStyle(
                  overlayColor: MaterialStateProperty.all(Colors.white54),
                  backgroundColor: MaterialStateProperty.all(Colors.teal),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                ),
                child: Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(vertical: 20),
                  width: MediaQuery.of(context).size.width,
                  child: Text(
                    "Sign Up",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              ),
              SizedBox(height: 15),
              ElevatedButton(
                onPressed: () {},
                style: ButtonStyle(
                  overlayColor: MaterialStateProperty.all(Colors.tealAccent),
                  backgroundColor: MaterialStateProperty.all(Colors.white),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                ),
                child: Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(vertical: 20),
                  width: MediaQuery.of(context).size.width,
                  child: Text(
                    "Sign Up with Google",
                    style: TextStyle(color: Colors.black, fontSize: 18),
                  ),
                ),
              ),
              SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already have an account?",
                    style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(width: 5),
                  TextButton(
                    onPressed: () {},
                    style: ButtonStyle(
                      visualDensity: VisualDensity.compact,
                      textStyle: MaterialStateProperty.all(
                        TextStyle(decoration: TextDecoration.underline),
                      ),
                      overlayColor: MaterialStateProperty.all(Colors.teal),
                      foregroundColor: MaterialStateProperty.all(Colors.white),
                    ),
                    child: Text("Login Now"),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
