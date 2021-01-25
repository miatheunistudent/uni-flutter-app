/* ************************************************************************
 * FILE : tags.dart
 * DESC : Class from which PostTags and SkillTags derive.
 * ************************************************************************
 */

import 'dart:collection';

class UniTags with IterableMixin {

  Map<String, bool> tagValues = {};
  List<String> tagLabels = [];

  void generateTagValues() {
    this.tagLabels.forEach((dynamic tag) =>
      this.tagValues[tag.toString()] = false);
  }

  // Contains at least one of the tags enabled in the other object
  bool atLeastOneOf(UniTags otherTags) {

    List<String> otherTagStrs = otherTags.toArray();

    for (String tagStr in toArray())
      if (otherTagStrs.contains(tagStr))
        return true;

    return false;
  }

  // Overloads [] getter
  bool operator [](String tag) {
    return this.tagValues[tag] != null
      ? this.tagValues[tag]
      : false;
  }

  // Overloads [] setter
  void operator []=(String tag, bool value) {
    this.tagValues[tag] = value;
  }

  // Converts to list of strings
  List<String> toArray() {

    List<String> tagStrings = [];

    // Maps bool values onto labels
    for (String tag in this.tagValues.keys) {
      if (this.tagValues[tag])
        tagStrings.add(tag);
    }
    return tagStrings;
  }

  // Builds from list of strings
  UniTags fromArray(List<dynamic> tagData) {

    // Locates each string in labels and stores corresponding value
    for (String tag in tagData..forEach((element) => element.toString()))
      if (this.tagLabels.contains(tag))
        this.tagValues[tag] = true;
        
    return this;
  }

  // True if tags empty
  bool empty() {
    Set<bool> tagValueSet = this.tagValues.values.toSet();
    return tagValueSet.length == 1 && tagValueSet.first == false;
  }

  // Gets number of selected tags
  get numberEnabled {
    return this.tagValues.values.where((value) => value).length;
  }

  // Gets total number of tags
  get length {
    return this.tagLabels.length;
  }

  // Iterates over all tag strings
  @override
  Iterator<dynamic> get iterator => this.tagLabels.iterator;
}