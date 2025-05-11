


import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  User? _user;
  bool _isEditing = false;

  late String _name;
  late String _phone;
  late String _age;
  late String _location;

  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _ageController = TextEditingController();
  final _locationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    final User? user = _auth.currentUser;
    if (user != null) {
      setState(() {
        _user = user;
        _nameController.text = '';
        _phoneController.text = '';
        _ageController.text = '';
        _locationController.text = '';
      });

      // Fetch user data from Firestore
      final doc = await _firestore.collection('users').doc(user.email).get();
      if (doc.exists) {
        final data = doc.data();
        setState(() {
          _name = data?['name'] ?? '';
          _phone = data?['phone'] ?? '';
          _age = data?['age'] ?? '';
          _location = data?['location'] ?? '';
          _nameController.text = _name;
          _phoneController.text = _phone;
          _ageController.text = _age;
          _locationController.text = _location;
        });
      }
    }
  }

  Future<void> _updateUserData() async {
    if (_user != null) {
      try {
        await _firestore.collection('users').doc(_user!.email).set({
          'name': _nameController.text.trim(),
          'phone': _phoneController.text.trim(),
          'age': _ageController.text.trim(),
          'location': _locationController.text.trim(),
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profile updated successfully!')),
        );

        setState(() {
          _isEditing = false; // Exit edit mode
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update profile: $e')),
        );
      }
    }
  }

  void _signOut() async {
    await _auth.signOut();
    Navigator.of(context).pushReplacementNamed('/');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff1E3882),
        title: Text('Profile'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _signOut,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _user == null
            ? Center(child: CircularProgressIndicator())
            : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Email: ${_user?.email}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 20),
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Name',
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
              enabled: _isEditing,
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: _phoneController,
              decoration: InputDecoration(
                labelText: 'Phone Number',
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
              keyboardType: TextInputType.phone,
              enabled: _isEditing,
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: _ageController,
              decoration: InputDecoration(
                labelText: 'Age',
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
              keyboardType: TextInputType.number,
              enabled: _isEditing,
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: _locationController,
              decoration: InputDecoration(
                labelText: 'Location',
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
              enabled: _isEditing,
            ),
            SizedBox(height: 20),
            Row(
              children: [
                if (_isEditing)
                  ElevatedButton(
                    onPressed: _updateUserData,
                    child: Text('Save Changes'),
                  ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _isEditing = !_isEditing;
                    });
                  },
                  child: Text(_isEditing ? 'Cancel' : 'Edit Profile'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

