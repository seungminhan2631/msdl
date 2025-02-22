import 'package:flutter/material.dart';
import 'package:msdl/commons/widgets/buttons/customButton.dart';

class bottomScrollSheet extends StatelessWidget {
  final DraggableScrollableController sheetController;
  final String currentAddress;

  bottomScrollSheet(
      {required this.sheetController, required this.currentAddress});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      controller: sheetController,
      initialChildSize: 0.12,
      minChildSize: 0.05,
      maxChildSize: 0.4,
      builder: (context, scrollController) {
        return Container(
          color: Color(0xFF2C2C2C),
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Column(
            children: [
              Container(width: 80, height: 3, color: Colors.grey),
              SizedBox(height: 6),
              Text("Current location: $currentAddress",
                  style: TextStyle(color: Colors.white, fontSize: 16)),
              CustomButton(text: "Add New Workplace", routeName: "/homeScreen"),
            ],
          ),
        );
      },
    );
  }
}
