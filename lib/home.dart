import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:untitled2/Judge.dart';
import 'package:untitled2/Lawyer.dart';
import 'dart:convert'; // For JSON decoding
import 'UnderPrisoner.dart';
import 'Lawyer.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _auth = FirebaseAuth.instance;
  String _selectedItem = 'Statues';
  TextEditingController _searchController = TextEditingController();
  Map<String, dynamic>? _formData;

  void _signOut() {
    _auth.signOut();
  }

  void _onDropdownChanged(String? newValue) {
    setState(() {
      _selectedItem = newValue!;
    });
  }

  Future<void> _search() async {
    try {
      String searchQuery = _searchController.text;
      String collection = _selectedItem.toLowerCase();

      if (searchQuery.isEmpty || collection.isEmpty) {
        _showDialog('Error', 'Please enter a section number and select a collection.');
        return;
      }

      final response = await http.post(
        Uri.parse('https://0592-14-139-226-226.ngrok-free.app/get_section'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'collection': collection,
          'section_number': int.tryParse(searchQuery) ?? 0, // Use `int.tryParse` to handle invalid integers
        }),
      );

      if (response.statusCode == 200) {
        try {
          final Map<String, dynamic> responseData = jsonDecode(response.body);
          setState(() {
            _formData = responseData;
          });
          _showStructuredDialog('Section Information');
        } catch (e) {
          _showDialog('Error', 'Failed to parse response data: $e');
        }
      } else {
        _showDialog('Error', 'Failed to fetch data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      _showDialog('Error', 'An unexpected error occurred: $e');
    }
  }

  void _showDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showStructuredDialog(String title) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: _formData != null
              ? SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _formData!.entries.map((entry) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: _formatEntry(entry.key, entry.value),
                  ),
                );
              }).toList(),
            ),
          )
              : Text('No data available.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  List<Widget> _formatEntry(String key, dynamic value) {
    List<Widget> widgets = [];
    if (value is Map<String, dynamic>) {
      widgets.add(Text(
        key,
        style: TextStyle(fontWeight: FontWeight.bold),
      ));
      value.forEach((subKey, subValue) {
        widgets.addAll(_formatEntry(subKey, subValue));
      });
    } else if (value is List) {
      widgets.add(Text(
        key,
        style: TextStyle(fontWeight: FontWeight.bold),
      ));
      for (var item in value) {
        widgets.addAll(_formatEntry('', item));
      }
    } else {
      widgets.add(Text(
        '$key: ${value.toString()}',
      ));
    }
    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false, // Prevent the UI from resizing
      appBar: AppBar(
        backgroundColor: Color(0xff1E3882),
        foregroundColor: Colors.white, // Set the text color
        title: Text('Home'),
        actions: [
          IconButton(
            icon: Image.asset('assets/Vector.png'), // Replace with your image asset path
            onPressed: () {
              _signOut();
              Navigator.pushReplacementNamed(context, '/home');
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text('Menu'),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            ListTile(
              title: Text('Profile'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
              },
            ),
            ListTile(
              title: Text('Settings'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
              },
            ),
            ListTile(
              title: Text('Help'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
              },
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                height: 10.0, // Same height as AppBar
                color: Color(0xff1E3882), // Match the AppBar color
              ),
              Padding(
                padding: const EdgeInsets.all(7.0),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.only(right: 40.0,top:0),
                      child: Text(
                        'Cases and provision',
                        style: TextStyle(
                          color: Color(0xFFCF914B),
                          fontSize: 20.0, // Change text size
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Expanded(
                      child: DropdownButton<String>(
                        value: _selectedItem,
                        items: <String>['Statues', 'ipc', 'bns', 'bnss', 'bsa']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: _onDropdownChanged,
                        icon: Icon(Icons.arrow_drop_down, color: Color(0xffCDCFD4)),
                        underline: SizedBox(), // Remove underline
                        dropdownColor: Colors.grey, // Change dropdown color if needed
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch, // Makes button stretch to full width
                  children: [
                    TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Enter Section',
                        prefixIcon: Icon(Icons.search, color: Colors.blue),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(color: Colors.blue),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(color: Colors.blue),
                        ),
                        contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 5.0),
                      ),
                    ),
                    SizedBox(height: 10.0), // Space between text field and button
                    ElevatedButton(
                      onPressed: _search,
                      child: Text('Search'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue, // Button color
                        foregroundColor: Colors.white, // Text color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Center(
                  child: Transform.translate(
                    offset: Offset(0, -100), // Move the image up by 170 pixels
                    child: Image.asset(
                      'assets/image.png', // Replace with your image path
                      width: 300, // Adjust width as needed
                      height: 300, // Adjust height as needed
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 40.0), // Adjust this value to move up
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/home');
                    },
                    child: Text('User Support and Feedback'),
                    style: TextButton.styleFrom(
                      foregroundColor: Color(0xffCF914B),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 80,
            left: 150,
            right: 0,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LawyerPage(), // Replace with the page you want to navigate to
                  ),
                );
              },
              child: Image.asset(
                'assets/image1.png',
                width: 100, // Adjust width as needed
                height: 340, // Adjust height as needed
              ),
            ),
          ),
          Positioned(
            bottom: 100,
            left: 0,
            right: 150,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UndertrialPrisonerPage(),),
                );
              },
              child: Image.asset(
                'assets/image4.png',
                width: 298, // Adjust width as needed
                height:298, // Adjust height as needed
              ),
            ),
          ),

          Positioned(
            bottom: -20,
            left: 150,
            right: 0,
            child: Image.asset(
              'assets/image3.png',
              width: 300, // Adjust width as needed
              height: 300, // Adjust height as needed
            ),
          ),
          Positioned(
            bottom: 75,
            left: 0,
            right: 150,
    child: GestureDetector(
    onTap: () {
    Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => JudgesPage()),
    );
    },

    child: Image.asset(
              'assets/image2.png',
              width: 110, // Adjust width as needed
              height: 100, // Adjust height as needed
            ),

          ),),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.home),
              onPressed: () {
                // Handle home button press
              },
            ),
            IconButton(
              icon: Image.asset(
                'assets/Group.png',
                width: 24,
                height: 24,
              ),
              onPressed: () {
                // Handle group button press
              },
            ),
            IconButton(
              icon: Icon(Icons.notifications),
              onPressed: () {
                Navigator.pushNamed(context, '/Notification');
              },
            ),
            IconButton(
              icon: Icon(Icons.account_circle),
              onPressed: () {
                Navigator.pushNamed(context, '/contact');
              },
            ),
          ],
        ),
      ),
    );
  }
}


