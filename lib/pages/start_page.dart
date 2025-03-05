import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:test_app/pages/login_page.dart';

class StartPage extends StatelessWidget {
  const StartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image with blur
          Positioned.fill(
            child: Image.network(
              'https://s3-alpha-sig.figma.com/img/faca/04b9/dbb2507876f812c1f2679e620f3889d9?Expires=1742169600&Key-Pair-Id=APKAQ4GOSFWCW27IBOMQ&Signature=QwX2XKia-78ikEc6Btw6xUroVPGnZpscmIiB3l~oiJxZOY3kOBchDH7~hkxP6APQSSL22Nd2XlI0v1Lv2lO4JO4cF5-5cYkUi5H6XG~JJnI7D3b9eIUze8YTMgac4uER7JQS27wuLb6fcgUXy8bYa6baKQn9H40f7d-59ExWjuBrzA49fZZVEDrE-8WaooKoXHZjKiJHrmC7InOnnX2q~gbwJeC~fd9AdmhgTxdP9SdDmjt4ynex74c8z6ZM0UdB7yiWXmhSfqfzx3JJYOC0bEl3Dd0j8QntUbeI0VBhmeqsW~eGFgNL5QlNtwVH2Jh4mhVFdKqocUDGaSvvv-CpNA__',
              fit: BoxFit.cover,
            ),
          ),
          // Blur Effect
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 3,
                sigmaY: 3,
              ), // Adjust blur intensity
              child: Container(
                color: Colors.black.withOpacity(
                  0.2,
                ), // Helps enhance blur effect
              ),
            ),
          ),
          // Gradient Overlay (Top Transparent to Bottom Black)
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.0), // Top light dar
                    Colors.black.withOpacity(0.9), // Bottom Dark
                  ],
                  stops: [0.2, 1], // Adjusts gradient smoothness
                ),
              ),
            ),
          ),
          // FastBag logo
          Positioned(
            top: 160,
            left: 1,
            right: 40,
            bottom: 300,
            child: Image.network(
              scale: 1.8,
              'https://s3-alpha-sig.figma.com/img/8752/f8c9/6f05cef92da77e8f946c303920fa8a7e?Expires=1742169600&Key-Pair-Id=APKAQ4GOSFWCW27IBOMQ&Signature=s8aqbGfrZxpsOu8SeYVzKfrlDudwDstVBQISTB8S5rM99JRe1snhiJDpMXdv-qlAV9cti2GD~gO4NU3MaA-sA1SJconYjq0-5xOFpFUIZvnQQWS57btV5gukO5M9MAp07LHbWFvY5hYkXLTXC3EdBt7NQYBTht8IfKh98N5KSLIMolr3b4Fph17muoYnsn2Rdjz8Bxph5zpjvu3QGIfFuLX-XvpXDD9kxp3nOz39sRsDL9YB9dBtNymmDatyGuO6RxdRiy1gpg7vr5XYoNr5g8dvbTR0SPXtjUh0jk90v-v8mVtawkLQF0Gjcqme7OSDEhnWHLMPWPbjKT4rEB09HQ__',
            ),
          ),

          // Content
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 540),

              // Description
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: Text(
                  "FastBag brings food, groceries, and fashion together, making it easy to find everything you need in one place.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 17,
                    color: Colors.white,
                    fontFamily: 'figtree',
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),

              SizedBox(height: 10),

              // Start Button
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
                child: Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: Icon(
                    Icons.arrow_right_alt_sharp,
                    size: 45,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
