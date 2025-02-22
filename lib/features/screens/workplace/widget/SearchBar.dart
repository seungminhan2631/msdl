import 'package:flutter/material.dart';
import 'package:flutter_google_places_sdk/flutter_google_places_sdk.dart'
    as places;

class SearchBar extends StatelessWidget {
  final TextEditingController searchController;
  final Function(String) onSearchChanged;
  final List<places.AutocompletePrediction> predictions;
  final Function(String) onSelectPrediction;

  SearchBar({
    required this.searchController,
    required this.onSearchChanged,
    required this.predictions,
    required this.onSelectPrediction,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 40,
      left: 10,
      right: 20,
      child: Column(
        children: [
          TextField(
            controller: searchController,
            onChanged: onSearchChanged,
            decoration: InputDecoration(
              hintText: "Search location",
              prefixIcon: Icon(Icons.search_rounded, color: Colors.red),
            ),
          ),
          if (predictions.isNotEmpty)
            Container(
              decoration: BoxDecoration(color: Colors.white),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: predictions.length > 2 ? 2 : predictions.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(predictions[index].fullText),
                    onTap: () =>
                        onSelectPrediction(predictions[index].fullText),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
