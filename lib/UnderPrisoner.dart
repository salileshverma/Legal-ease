import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UndertrialPrisonerPage extends StatefulWidget {
  @override
  _UndertrialPrisonerPageState createState() => _UndertrialPrisonerPageState();
}

class _UndertrialPrisonerPageState extends State<UndertrialPrisonerPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _offenseCountController = TextEditingController();

  int _numberOfOffenses = 0;
  bool _offenseFieldsVisible = false;
  bool _isResponseVisible = false;
  String _serverResponse = '';

  List<Map<String, TextEditingController>> _offenseControllers = [];

  @override
  void dispose() {
    _dateController.dispose();
    _offenseCountController.dispose();
    _offenseControllers.forEach((map) {
      map.forEach((key, controller) {
        controller.dispose();
      });
    });
    super.dispose();
  }

  void _submitInitialData() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _numberOfOffenses = int.parse(_offenseCountController.text);
        _offenseFieldsVisible = true;

        // Initialize offense controllers
        _offenseControllers = List.generate(_numberOfOffenses, (_) {
          return {
            'offense_severity': TextEditingController(),
            'offense_type': TextEditingController(),
            'evidence_strength': TextEditingController(),
            'securing_presence': TextEditingController(),
            'tampering_risk': TextEditingController(),
          };
        });
      });
    }
  }

  Future<void> _submitOffenses() async {
    List<Map<String, String>> offenses = _offenseControllers.map((map) {
      return {
        'offense_severity': map['offense_severity']!.text,
        'offense_type': map['offense_type']!.text,
        'evidence_strength': map['evidence_strength']!.text,
        'securing_presence': map['securing_presence']!.text,
        'tampering_risk': map['tampering_risk']!.text,
      };
    }).toList();

    Map<String, dynamic> data = {
      'start_date': _dateController.text,
      'offenses': offenses,
      'custom_factor': 30 // Add any custom factor if needed
    };

    String url = 'https://0592-14-139-226-226.ngrok-free.app/check_bail_eligibility';

    try {
      final response = await http.post(
        Uri.parse(url),
        body: json.encode(data),
        headers: {'Content-Type': 'application/json'},
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        setState(() {
          _isResponseVisible = true;
          _serverResponse = response.body;
          _offenseFieldsVisible = false; // Hide input fields after submission
        });
      } else {
        setState(() {
          _serverResponse = 'Failed to submit data. Error: ${response.statusCode}';
        });
      }
    } catch (error) {
      setState(() {
        _serverResponse = 'Error submitting data: $error';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Go back to the previous page
          },
        ),
        title: Text('Imprisonment Tracker'),
        backgroundColor: Color(0xff1E3882), // Same color as your HomePage AppBar
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!_offenseFieldsVisible && !_isResponseVisible) ...[
                TextFormField(
                  controller: _dateController,
                  decoration: InputDecoration(labelText: 'Date (YYYY-MM-DD)'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a date';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _offenseCountController,
                  decoration: InputDecoration(labelText: 'Number of Offenses'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the number of offenses';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _submitInitialData,
                  child: Text('Submit'),
                ),
              ],
              if (_offenseFieldsVisible) ...[
                Expanded(
                  child: ListView.builder(
                    itemCount: _numberOfOffenses,
                    itemBuilder: (context, index) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Offense ${index + 1}',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          DropdownButtonFormField<String>(
                            value: _offenseControllers[index]['offense_severity']!.text.isNotEmpty
                                ? _offenseControllers[index]['offense_severity']!.text
                                : null,
                            items: ['Severe', 'Moderate'].map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (newValue) {
                              setState(() {
                                _offenseControllers[index]['offense_severity']!.text = newValue!;
                              });
                            },
                            decoration: InputDecoration(labelText: 'Offense Severity'),
                          ),
                          DropdownButtonFormField<String>(
                            value: _offenseControllers[index]['offense_type']!.text.isNotEmpty
                                ? _offenseControllers[index]['offense_type']!.text
                                : null,
                            items: ['Bailable', 'Non-Bailable'].map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (newValue) {
                              setState(() {
                                _offenseControllers[index]['offense_type']!.text = newValue!;
                              });
                            },
                            decoration: InputDecoration(labelText: 'Offense Type'),
                          ),
                          DropdownButtonFormField<String>(
                            value: _offenseControllers[index]['evidence_strength']!.text.isNotEmpty
                                ? _offenseControllers[index]['evidence_strength']!.text
                                : null,
                            items: ['Strong', 'Weak', 'Moderate'].map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (newValue) {
                              setState(() {
                                _offenseControllers[index]['evidence_strength']!.text = newValue!;
                              });
                            },
                            decoration: InputDecoration(labelText: 'Evidence Strength'),
                          ),
                          DropdownButtonFormField<String>(
                            value: _offenseControllers[index]['securing_presence']!.text.isNotEmpty
                                ? _offenseControllers[index]['securing_presence']!.text
                                : null,
                            items: ['Likely', 'Unlikely', 'Certain'].map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (newValue) {
                              setState(() {
                                _offenseControllers[index]['securing_presence']!.text = newValue!;
                              });
                            },
                            decoration: InputDecoration(labelText: 'Securing Presence'),
                          ),
                          DropdownButtonFormField<String>(
                            value: _offenseControllers[index]['tampering_risk']!.text.isNotEmpty
                                ? _offenseControllers[index]['tampering_risk']!.text
                                : null,
                            items: ['High', 'Low', 'Medium'].map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (newValue) {
                              setState(() {
                                _offenseControllers[index]['tampering_risk']!.text = newValue!;
                              });
                            },
                            decoration: InputDecoration(labelText: 'Tampering Risk'),
                          ),
                          SizedBox(height: 20),
                        ],
                      );
                    },
                  ),
                ),
                ElevatedButton(
                  onPressed: _submitOffenses,
                  child: Text('Submit Offenses'),
                ),
              ],
              if (_isResponseVisible) ...[
                Expanded(
                  child: SingleChildScrollView(
                    child: Text(
                      _serverResponse,
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
