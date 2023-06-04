import 'package:easy_auto_form/enums/enums.dart';
import 'package:flutter/material.dart';

class FieldSetting {
  FieldSetting({
    required this.fieldKey,
    this.inputType = FieldInputType.normal,
    this.inputDecoration,
    this.selectOptions,
    this.autocompleteSource,
  });

  final String fieldKey;
  FieldInputType inputType;
  InputDecoration? inputDecoration;

  // If the input type is select, this is the list of options to display.
  List<String>? selectOptions;

  // If the input type is autocomplete, this is the source of options to display.
  AutocompleteSource? autocompleteSource;
}

class AutocompleteSource {
  AutocompleteSource({
    required this.source,
  });

  final Future<List<String>> Function(String pattern)? source;
}
