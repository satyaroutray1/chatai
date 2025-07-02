import 'package:flutter/material.dart';

class Bubble extends StatelessWidget {

  const Bubble({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(8, 2, 8, 2),
      margin: EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
          color: Colors.blue.withOpacity(.1),
          borderRadius: BorderRadius.circular(10)
      ),
      child: child,
    );
  }
}
