import 'package:flutter/material.dart';
import 'package:msdl/commons/widgets/topTitle.dart';

class NameScreen extends StatefulWidget {
  const NameScreen({super.key});

  @override
  State<NameScreen> createState() => _NameScreenState();
}

class _NameScreenState extends State<NameScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: TopTitle(text: "What is your name?"),
      ),
    );
  }
}
