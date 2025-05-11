import 'package:flutter/material.dart';

class JudgesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Judges',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Judgemental Analysis',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: [
                  CaseTile(
                    caseName: 'Case 1: Aayush Srivastav',
                    decision: 'Judge Roy: Rapist, Sentence to Death',
                  ),
                  CaseTile(
                    caseName: 'Case 2: Harish Singh',
                    decision: 'Judge Aman Singh: Murderer, 10 year imprisonment',
                  ),
                  CaseTile(
                    caseName: 'Case 3: subham banerjee',
                    decision: 'Judge hakim ulah: Dismissed due to lack of evidence',
                  ),
                  CaseTile(
                    caseName: 'Case 4: mamta banerjee',
                    decision: 'Judge Manmohan Singh: Fine of 500,000 imposed',
                  ),
                  CaseTile(
                    caseName: 'Case 5: Saswat',
                    decision: 'Judge Harendra Mehta : Custody awarded to mother',
                  ),
                  // Add more cases as needed
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CaseTile extends StatelessWidget {
  final String caseName;
  final String decision;

  CaseTile({required this.caseName, required this.decision});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 16.0),
      child: ListTile(
        title: Text(caseName),
        subtitle: Text(decision),
      ),
    );
  }
}
