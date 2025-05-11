


import 'package:flutter/material.dart';
import 'dart:async';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // Navigate to the scrollable screens after 3 seconds
    Timer(Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => OnboardingScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          decoration: BoxDecoration(
            color: Color(0xff1E3882),
            image: DecorationImage(
              image: AssetImage('assets/splash.png'),
              // fit: BoxFit.cover, // Cover the entire screen
            ),
          ),
        ),
      ),
    );
  }
}

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  PageController _pageController = PageController();
  int _currentPage = 0;

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  void _nextPage() {
    if (_currentPage < 2) {
      _pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    } else {
      Navigator.of(context).pushReplacementNamed('/login'); // Navigate to login page on last screen
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            onPageChanged: _onPageChanged,
            children: <Widget>[
              _buildPageContent(
                image: 'assets/h3.png',
                content: 'Input Offenses in \n Seconds',
                footerText: 'Enter charges, view penalties \n instantly',
              ),
              _buildPageContent(
                image: 'assets/h2.png',
                content: 'Track Imprisonment \n & Bail',
                footerText: 'Stay updated on bail \n eligibility with real-time \n tracking',
              ),
              _buildPageContent(
                image: 'assets/h1.png',
                content: 'Ensure Legal \n Compliance',
                footerText: 'Never miss a step with our \n compliance checklist.',
              ),
            ],
          ),
          Positioned(
            bottom: 20, // Adjust the position of the button as needed
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
                padding: EdgeInsets.all(12),
                child: IconButton(
                  onPressed: _nextPage,
                  icon: Icon(Icons.arrow_forward, color: Colors.white),
                  iconSize: 30,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPageContent({required String image, required String content, required String footerText}) {
    return Stack(
      children: [
        // White background
        Container(
          color: Colors.white,
        ),
        // Gradient container with limited height
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Container(
            height: MediaQuery.of(context).size.height * 0.4, // Adjust the height as needed
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF161B4B), Color(0xFF20D0C6)], // Gradient colors
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [0.4, 0.7],
              ),
            ),
          ),
        ),
        // Polygon image at the bottom
        Positioned(
          bottom: 240,
          left: 0,
          right: 0,
          child: Image.asset(
            'assets/Polygon1.png',
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
          ),
        ),
        // h1, h2, h3 images stacked above the polygon image
        Positioned(
          top: 250, // Adjust the top position as needed
          left: 0,
          right: 0,
          child: Column(
            children: [
              Image.asset(
                image,
                width: MediaQuery.of(context).size.width * 0.8, // Adjust width as needed
                height: MediaQuery.of(context).size.height * 0.3, // Adjust height as needed
                fit: BoxFit.contain, // Fit the image within the given width and height
              ),
            ],
          ),
        ),
        // Content text
        Positioned(
          top: 120, // Adjust this value to position the text
          left: 0,
          right: 0,
          child: Center(
            child: Text(
              content,
              style: TextStyle(fontSize: 27, color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        // Footer text above the arrow button
        Positioned(
          bottom: 150, // Adjust this value to position the footer text above the arrow button
          left: 0,
          right: 0,
          child: Center(
            child: Text(
              footerText,
              style: TextStyle(fontSize: 24, color: Colors.black,fontWeight: FontWeight.bold), // Adjust font size and color as needed
              textAlign: TextAlign.center,

            ),
          ),
        ),
      ],
    );
  }
}

