import 'package:chat_app_flutter/services/auth.dart';
import 'package:chat_app_flutter/views/register.dart';
import 'package:chat_app_flutter/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'contacts.dart';

class LogIn extends StatefulWidget {
  @override
  _LogInState createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  bool isLoading = false;
  final formKey = GlobalKey<FormState>();
  Auth auth = new Auth();
  TextEditingController emailTEController = new TextEditingController();
  TextEditingController passwordTEController = new TextEditingController();

  logInValidator() {
    if (formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      auth
          .logInWithEmail(
        email: emailTEController.text,
        password: passwordTEController.text,
      )
          .then((value) {
        print("$value");

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Contacts()),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height,
                padding: EdgeInsets.symmetric(horizontal: 25),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Form(
                      key: formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            validator: (value) => value != null &&
                                    RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                        .hasMatch(value)
                                ? null
                                : "Invalid Email",
                            controller: emailTEController,
                            style: TextStyle(color: Colors.white),
                            decoration: customTextFieldDecoration("E-Mail"),
                            keyboardType: TextInputType.emailAddress,
                          ),
                          SizedBox(height: 12),
                          TextFormField(
                            validator: (value) =>
                                value != null && value.length > 6
                                    ? null
                                    : "Atleast 7 characters required",
                            controller: passwordTEController,
                            style: TextStyle(color: Colors.white),
                            decoration: customTextFieldDecoration("Password"),
                            obscureText: true,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 25),
                    Container(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {},
                        child: Text(
                          "Forgot Password?",
                          style: TextStyle(color: Colors.white54),
                        ),
                        style: ButtonStyle(
                          visualDensity: VisualDensity.compact,
                          overlayColor: MaterialStateProperty.all(Colors.teal),
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                    ElevatedButton(
                      onPressed: () => logInValidator(),
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
                          "Log In",
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                    ElevatedButton(
                      onPressed: () {},
                      style: ButtonStyle(
                        overlayColor:
                            MaterialStateProperty.all(Colors.tealAccent),
                        backgroundColor:
                            MaterialStateProperty.all(Colors.white),
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
                          "Log In with Google",
                          style: TextStyle(color: Colors.black, fontSize: 18),
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account?",
                          style: TextStyle(color: Colors.white),
                        ),
                        SizedBox(width: 5),
                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Register(),
                              ),
                            );
                          },
                          style: ButtonStyle(
                            visualDensity: VisualDensity.compact,
                            textStyle: MaterialStateProperty.all(
                              TextStyle(decoration: TextDecoration.underline),
                            ),
                            overlayColor:
                                MaterialStateProperty.all(Colors.teal),
                            foregroundColor:
                                MaterialStateProperty.all(Colors.white),
                          ),
                          child: Text("Register Now"),
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
