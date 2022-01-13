import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

///
///This class manages about page
///
///
class AboutPage extends StatelessWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
          child: Column(
        children: <Widget>[
          const SizedBox(height: 30),
          Text(
            "About us",
            style: GoogleFonts.lora(
                color: Colors.deepPurple,
                fontSize: 32,
                fontWeight: FontWeight.bold,
                letterSpacing: 2
                //   letterSpacing: 0.5
                ),
          ),
          Container(
              margin: const EdgeInsets.only(top: 20.0),
              //   alignment: Alignment.topLeft,
              child: Center(
                  child: Image.asset('assets/images/devteam.png',
                      height: 300, width: 500))),
          Container(
              margin: const EdgeInsets.all(25.0),
              //   alignment: Alignment.topLeft,
              child: Center(
                child: Text(
                  "This application was developed by Agosthazy Csaba, Aymon Ekaterina, Babaiantz Mathias, Battiston Arnaud and Fernandes David with Flutter framework and database Firebase.",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.roboto(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    //   letterSpacing: 0.5
                  ),
                ),
              )),
          const SizedBox(height: 40),
          Text("HES-SO Valais-Wallis\n2022",
              textAlign: TextAlign.center,
              style: GoogleFonts.sora(
                color: Colors.grey,
                letterSpacing: 0.5,
              )),
        ],
      )),
    );
  }
}
