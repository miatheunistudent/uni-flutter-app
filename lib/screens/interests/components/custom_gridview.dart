import 'package:flutter/material.dart';
import 'custom_cards.dart';

List<String> wordList = [
  "Lifestyle",
  "Fitness",
  "Nature",
  "Food",
  "People",
  "Fashion",
  "Beauty",
  "Bikes",
  "Books",
  "Technology",
  "Science",
  "Events",
  "Music",
  "Food",
  "Travel",
  "Hotels",
  "Research",
  "Design"
];
String url = "https://source.unsplash.com/featured/?";

class CustomGridView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: GridView.count(
      childAspectRatio: 15 / 22,
      crossAxisCount: 2,
      mainAxisSpacing: 10.0,
      crossAxisSpacing: 10.0,
      children: List.generate(
        wordList.length,
        (index) => CustomCard(url + wordList[index], wordList[index]),
      ),
    ));
  }
}
