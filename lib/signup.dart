import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _professionController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  void _signup() async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      // Save additional user info to Firestore
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'firstName': _firstNameController.text.trim(),
        'lastName': _lastNameController.text.trim(),
        'profession': _professionController.text.trim(),
        'email': _emailController.text.trim(),
      });

      Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      if (e is FirebaseAuthException) {
        if (e.code == 'email-already-in-use') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('The email address is already in use. Please log in.')),
          );
          Navigator.pushNamed(context, '/login');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Sign Up failed: ${e.message}')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(right: 30, left: 30, top: 0, bottom: 5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Transform.translate(
                offset: Offset(0, -8), // Adjust the y-offset value to move the image up
                child: Image.asset(
                  'assets/splash.png', // Replace with your image path
                  width: 250, // Adjust width as needed
                  height: 250, // Adjust height as needed
                ),
              ),
              SizedBox(height: 20),

              // First Name input field
              Container(
                padding: EdgeInsets.symmetric(vertical: 0, horizontal: 15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextFormField(
                  controller: _firstNameController,
                  decoration: InputDecoration(
                    labelText: 'First Name',
                    border: InputBorder.none,
                  ),
                ),
              ),
              SizedBox(height: 15),

              // Last Name input field
              Container(
                padding: EdgeInsets.symmetric(vertical: 0, horizontal: 15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextFormField(
                  controller: _lastNameController,
                  decoration: InputDecoration(
                    labelText: 'Last Name',
                    border: InputBorder.none,
                  ),
                ),
              ),
              SizedBox(height: 15),

              // Profession input field
              Container(
                padding: EdgeInsets.symmetric(vertical: 0, horizontal: 15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextFormField(
                  controller: _professionController,
                  decoration: InputDecoration(
                    labelText: 'Profession',
                    border: InputBorder.none,
                  ),
                ),
              ),
              SizedBox(height: 15),

              // Email input field
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
                    border: InputBorder.none,
                  ),
                ),
              ),
              SizedBox(height: 15),

              // Password input field
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
                    border: InputBorder.none,
                  ),
                  obscureText: true,
                ),
              ),
              SizedBox(height: 20),

              ElevatedButton(
                onPressed: _signup,
                child: Text('Sign Up'),
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
                  Navigator.pushNamed(context, '/login');
                },
                child: Text('Already have an account? Log In'),
                style: TextButton.styleFrom(
                  foregroundColor: Color(0xffCF914B),
                ),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Color(0xff1E3882), // Set the background color of the entire page
    );
  }
}
