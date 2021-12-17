import 'package:flutter/material.dart';

/// This is the stateless widget that the main application instantiates.
class InfoCard extends StatelessWidget {
  const InfoCard(
      {Key? key,
      required this.title,
      required this.fun,
      required this.value,
      required this.icon})
      : super(key: key);

  final String value;
  final Icon icon;
  final String title;
  final Function(String) fun;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        child: InkWell(
          splashColor: Colors.blue.withAlpha(30),
          onTap: () {
            fun(title);
          },
          child: Column(children: [
            icon,
            Center(
              child: Text(value),
            )
          ]),
        ),
      ),
    );
  }
}
