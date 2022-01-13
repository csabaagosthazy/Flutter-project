import 'package:flutter/material.dart';
import 'package:flutter_group2_tshirt_project/pages/home_page.dart';
import 'package:introduction_screen/introduction_screen.dart';

class WelcomeScreens extends StatefulWidget {
  const WelcomeScreens({Key? key}) : super(key: key);

  @override
  _WelcomeScreensState createState() => _WelcomeScreensState();
}

class _WelcomeScreensState extends State<WelcomeScreens> {
  final key = GlobalKey<IntroductionScreenState>();

  void endOfWelcomeScreens(context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const HomePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    const pageDecoration = PageDecoration(
      titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
      bodyTextStyle: TextStyle(fontSize: 19.0),
      descriptionPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      pageColor: Colors.white,
      imagePadding: EdgeInsets.zero,
    );

    return IntroductionScreen(
      key: key,
      globalBackgroundColor: Colors.white,

      pages: [
        PageViewModel(
          title: "Welcome\n to our T-shirt App!",
          body:
              "Smart T-shirt will help you to monitor your health indicators and sport activity in live mode.",
          image: Image.asset('assets/images/tshirt2.PNG', width: 350),
          decoration: const PageDecoration(
            titlePadding:
                EdgeInsets.only(left: 0, top: 16.0, bottom: 24.0, right: 35.0),
            titleTextStyle:
                TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
            bodyTextStyle: TextStyle(fontSize: 19.0),
            descriptionPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
            pageColor: Colors.white,
            imagePadding: EdgeInsets.zero,
          ),
        ),
        PageViewModel(
          title: "Save your data anywhere ",
          body:
              "Smart T-shirt provides an opportunity to monitor and save your data even if you are somewhere without Internet, for example, on a walk in the Swiss mountains.",
          image: Image.asset('assets/images/tourism.png', width: 300),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Personal digital assistance",
          body:
              "Smart T-shirt is your individual digital assistant that allows you to monitor your health indicators and always stay up to date.",
          image: Image.asset('assets/images/neural.png', width: 300),
          decoration: pageDecoration,
        ),
      ],
      onDone: () => endOfWelcomeScreens(context),
      showSkipButton: true,
      skipFlex: 0,
      nextFlex: 0,
      //rtl: true, // Display as right-to-left
      skip: const Text('Skip', style: TextStyle(fontWeight: FontWeight.bold)),
      next: const Icon(Icons.arrow_forward),
      done: const Text("Let's go!",
          style: TextStyle(fontWeight: FontWeight.bold)),
      curve: Curves.fastLinearToSlowEaseIn,
      controlsMargin: const EdgeInsets.all(16),
      controlsPadding: const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
      dotsDecorator: const DotsDecorator(
        size: Size(20.0, 15.0),
        color: Color(0xFFBDBDBD),
        activeSize: Size(22.0, 15.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      ),
      dotsContainerDecorator: const ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
      ),
    );
  }
}
