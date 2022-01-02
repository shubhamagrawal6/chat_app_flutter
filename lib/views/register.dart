import 'package:chat_app_flutter/services/auth.dart';
import 'package:chat_app_flutter/services/database.dart';
import 'package:chat_app_flutter/views/login.dart';
import 'package:chat_app_flutter/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'contacts.dart';

class Register extends StatefulWidget {
  final Auth auth;
  Register({required this.auth});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  bool isLoading = false;
  final formKey = GlobalKey<FormState>();
  late Auth auth = widget.auth;
  Database database = new Database();
  TextEditingController usernameTEController = new TextEditingController();
  TextEditingController emailTEController = new TextEditingController();
  TextEditingController passwordTEController = new TextEditingController();
  TextEditingController confirmPassTEController = new TextEditingController();

  registerValidator() {
    if (formKey.currentState!.validate()) {
      Map<String, String> userMap = {
        "name": usernameTEController.text,
        "email": emailTEController.text,
      };

      SharedPrefUtil.setUserName(username: usernameTEController.text);
      SharedPrefUtil.setUserEmail(userEmail: emailTEController.text);

      setState(() {
        isLoading = true;
      });

      auth.RegisterWithEmail(
        email: emailTEController.text,
        password: passwordTEController.text,
      ).then((value) {
        print("$value");

        database.uploadUserInfo(userMap: userMap);
        SharedPrefUtil.setUserLoggedIn(isLoggedIn: true);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Contacts(auth: auth)),
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
                            validator: (value) => value == null || value.isEmpty
                                ? "Invalid Username"
                                : null,
                            controller: usernameTEController,
                            style: TextStyle(color: Colors.white),
                            decoration:
                                customTextFieldDecoration("Enter Username"),
                          ),
                          SizedBox(height: 12),
                          TextFormField(
                            validator: (value) => value != null &&
                                    RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                        .hasMatch(value)
                                ? null
                                : "Invalid Email",
                            controller: emailTEController,
                            style: TextStyle(color: Colors.white),
                            decoration:
                                customTextFieldDecoration("Enter E-Mail"),
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
                            decoration:
                                customTextFieldDecoration("Set Password"),
                            obscureText: true,
                          ),
                          SizedBox(height: 12),
                          TextFormField(
                            validator: (value) => value != null &&
                                    value.isNotEmpty &&
                                    value == passwordTEController.text
                                ? null
                                : "Password doesn't match",
                            controller: confirmPassTEController,
                            style: TextStyle(color: Colors.white),
                            decoration:
                                customTextFieldDecoration("Confirm Password"),
                            obscureText: true,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 40),
                    ElevatedButton(
                      onPressed: () => registerValidator(),
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
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LogIn(auth: auth)),
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
