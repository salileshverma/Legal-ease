
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _auth = FirebaseAuth.instance;

  void _login() async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login failed')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true, // This will adjust the body when the keyboard appears
      backgroundColor: Color(0xff1E3882), // Set the background color of the entire page
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 30.0),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Move the image upwards using Transform.translate
                Transform.translate(
                  offset: Offset(0, -10), // Adjust the offset as needed
                  child: Image.asset(
                    'assets/splash.png', // Replace with your image path
                    width: 300, // Adjust width as needed
                    height: 300, // Adjust height as needed
                  ),
                ),
                SizedBox(height: 20), // Space between the image and the text fields

                // Email input field in a white box
                Container(
                  padding: EdgeInsets.symmetric(vertical: 0, horizontal: 15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      border: InputBorder.none, // Remove border from TextFormField
                    ),
                  ),
                ),
                SizedBox(height: 15), // Space between the email and password fields

                // Password input field in a white box
                Container(
                  padding: EdgeInsets.symmetric(vertical: 0, horizontal: 15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      border: InputBorder.none, // Remove border from TextFormField
                    ),
                    obscureText: true,
                  ),
                ),
                SizedBox(height: 20), // Space before the login button

                // ElevatedButton(
                //   onPressed: _login,
                //   child: Text('Login'),
                // ),
                // TextButton(
                //   onPressed: () {
                //     Navigator.pushNamed(context, '/signup');
                //   },
                //   child: Text('Don\'t have an account? Sign Up'),
                // ),
          ElevatedButton(
            onPressed: _login,
            child: Text('Login'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xffCF914B), // Background color of the button
              foregroundColor: Colors.white, // Text color of the button
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15), // Optional: Adjust padding
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25), // Optional: Rounded corners
              ),
            ),
          ),

          TextButton(
            onPressed: () {
              Navigator.pushNamed(context, '/signup');
            },
            child: Text('Don\'t have an account? Sign Up'),
            style: TextButton.styleFrom(
              foregroundColor: Color(0xffCF914B),),)



              ],
            ),
          ),
        ),
      ),
    );
  }
}
