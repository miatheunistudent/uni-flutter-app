/* ************************************************************************
 * FILE : contentModeration.dart
 * DESC : Detects vulgar content in a text and helps filter.
 * ************************************************************************
 */

import 'package:unistudentapp/data/badWords.dart';

// Checks if a text contains bad words.
bool containsBadWords(String text){
  return text != moderatedText(text);
}

// Turns bad words into nice astericks ***.
String moderatedText(String text){
  // Separates string into a list of words
  final wordList = text.split(' ');
  final RegExp punctuations = RegExp('[.,!?]');

  var cleanedWordList = [];
  
  // Goes through each word
  for (var i = 0; i < wordList.length; i ++) {
    var origWord = wordList[i];

    var word = origWord.toLowerCase();
    var punc = '';

    // If there is punctuation
    if (word.contains(punctuations)){
      var puncSplit = word.indexOf(punctuations);
      word = word.substring(0, puncSplit);
      punc = origWord.substring(puncSplit, origWord.length);
    }
 
    // Changes into astericks
    if (badWordsList.contains(word)){
      var cleaned = '*' * word.length;
      cleanedWordList.add(cleaned + punc);
    }
    // Adds original word
    else {
      cleanedWordList.add(origWord);
    }
  }
  return cleanedWordList.join(' ');
}
