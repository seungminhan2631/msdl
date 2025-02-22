import 'package:flutter/material.dart';
import 'package:msdl/commons/widgets/topTitle.dart';

class EditPasswordScreen extends StatefulWidget {
  const EditPasswordScreen({super.key});

  @override
  State<EditPasswordScreen> createState() => _EditPasswordScreenState();
}

class _EditPasswordScreenState extends State<EditPasswordScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TopTitle(text: "Edit Password"),
    );
  }
}
