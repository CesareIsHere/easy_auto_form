library easy_auto_form;

import 'package:easy_auto_form/enums/enums.dart';
import 'package:easy_auto_form/models/field_setting.dart';
import 'package:easy_auto_form/models/field_settings.dart';
import 'package:flutter/material.dart';

/// A widget that generates a form based on a given entity.
///
/// The `EasyAutoForm` widget is designed to work with any entity that is represented as a `Map<String, dynamic>`.
/// This means that it can be used with a wide variety of data types, including but not limited to:
///
/// - User profiles
/// - Product listings
/// - Blog posts
/// - Contact information
/// - Survey responses
///
/// The `EasyAutoForm` widget will generate input fields for each key in the entity map, and will automatically determine the appropriate input type based on the value type.
class EasyAutoForm extends StatefulWidget {
  const EasyAutoForm({
    Key? key,
    required this.formKey,
    required this.entity,
    this.entityAsMock = true,
    this.fieldsToIgnore,
    required this.onSave,
    this.stringInputDecorationOverride,
    this.intInputDecorationOverride,
    this.doubleInputDecorationOverride,
    this.dateTimeInputDecorationOverride,
    this.selectInputDecorationOverride,
    this.autocompleteInputDecorationOverride,
    this.onCancel,
    this.fieldsSettings,
  }) : super(key: key);

  /// A key that uniquely identifies the form.
  final GlobalKey<FormState> formKey;

  /// The entity to generate the form for.
  final Map<String, dynamic> entity;

  /// Whether to use a copy of the entity as a mock or the original entity.
  final bool entityAsMock;

  /// A list of field names to ignore when generating the form.
  final List<String>? fieldsToIgnore;

  /// A function to call when the form is saved.
  final Function(dynamic entityResult)? onSave;

  /// A function to call when the form is cancelled.
  final Function()? onCancel;

  /// A decoration to apply to all string input fields.
  final InputDecoration? stringInputDecorationOverride;

  /// A decoration to apply to all int input fields.
  final InputDecoration? intInputDecorationOverride;

  /// A decoration to apply to all double input fields.
  final InputDecoration? doubleInputDecorationOverride;

  /// A decoration to apply to all DateTime input fields.
  final InputDecoration? dateTimeInputDecorationOverride;

  /// A decoration to apply to all select input fields.
  final InputDecoration? selectInputDecorationOverride;

  /// A decoration to apply to all autocomplete input fields.
  final InputDecoration? autocompleteInputDecorationOverride;

  /// A list of settings to apply to each field.
  final FieldsSettings? fieldsSettings;

  @override
  State<EasyAutoForm> createState() => _AutoFormState();
}

class _AutoFormState extends State<EasyAutoForm> {
  final shadowEntity = <String, dynamic>{};

  @override
  void initState() {
    if (!widget.entityAsMock) shadowEntity.addAll(widget.entity);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ...() {
            var widgets = <Widget>[];
            for (var key in widget.entity.keys) {
              if (widget.fieldsToIgnore?.contains(key) ?? false) continue;

              FieldSetting? fieldSetting = widget.fieldsSettings?.settings
                  .firstWhere((element) => element.fieldKey == key);

              fieldSetting ??= FieldSetting(fieldKey: key);

              switch (fieldSetting.inputType) {
                case FieldInputType.normal:
                  // If key is an int field type, create an input with int validators
                  if (widget.entity[key] is int) {
                    widgets.add(
                      intTextFormField(key),
                    );
                  }
                  // If key is a double field type, create an input with double validators
                  else if (widget.entity[key] is double) {
                    widgets.add(
                      doubleTextFormField(key),
                    );
                  }
                  // If key is a String field type, create an input with String validators
                  else if (widget.entity[key] is String) {
                    widgets.add(
                      stringTextFormField(key),
                    );
                  }
                  // If key is a bool field type, create a checkbox
                  else if (widget.entity[key] is bool) {
                    widgets.add(
                      CheckboxListTile(
                        title: Text(key),
                        value: shadowEntity[key] ?? false,
                        onChanged: (value) {
                          setState(() {
                            shadowEntity[key] = value;
                          });
                        },
                      ),
                    );
                  }
                  // If key is a DateTime field type, create a date picker
                  else if (widget.entity[key] is DateTime) {
                    widgets.add(
                      dateTimeTextFormField(key),
                    );
                  }
                  // If key is a dynamic field type, create a text input
                  else {
                    widgets.add(
                      stringTextFormField(key),
                    );
                  }
                  break;
                case FieldInputType.select:
                  if (fieldSetting.selectOptions == null)
                    throw Exception("Select options cannot be null");
                  if (fieldSetting.selectOptions!.isEmpty)
                    throw Exception("Select options cannot be empty");
                  widgets.add(
                    selectTextFormField(key, fieldSetting.selectOptions!),
                  );
                  break;
                case FieldInputType.autocomplete:
                  if (fieldSetting.autocompleteSource == null) {
                    throw Exception("Autocomplete source cannot be null");
                  }
                  widgets.add(
                    autocompleteTextFormField(
                        key, fieldSetting.autocompleteSource!),
                  );
                  break;
              }
            }
            return widgets;
          }(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: widget.onCancel,
                child: const Text('Cancella'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (widget.formKey.currentState!.validate()) {
                    widget.formKey.currentState!.save();
                    widget.onSave!(shadowEntity);
                  }

                  setState(() {});
                },
                child: const Text('Salva'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget intTextFormField(key) {
    return TextFormField(
      initialValue: shadowEntity[key]?.toString() ?? "0",
      decoration: widget.intInputDecorationOverride?.copyWith(labelText: key) ??
          InputDecoration(labelText: key),
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter some text';
        }
        if (int.tryParse(value) == null) {
          return 'Please enter an integer';
        }
        return null;
      },
      onSaved: (value) {
        shadowEntity[key] = int.parse(value!);
        setState(() {});
      },
    );
  }

  Widget doubleTextFormField(key) {
    return TextFormField(
      initialValue: shadowEntity[key]?.toString() ?? "0",
      decoration:
          widget.doubleInputDecorationOverride?.copyWith(labelText: key) ??
              InputDecoration(labelText: key),
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter some text';
        }
        if (double.tryParse(value) == null) {
          return 'Please enter a double';
        }
        return null;
      },
      onSaved: (value) {
        shadowEntity[key] = double.parse(value!);
        setState(() {});
      },
    );
  }

  Widget stringTextFormField(key) {
    return TextFormField(
      initialValue: shadowEntity[key]?.toString() ?? "",
      decoration:
          widget.stringInputDecorationOverride?.copyWith(labelText: key) ??
              InputDecoration(labelText: key),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter some text';
        }
        return null;
      },
      onSaved: (value) {
        shadowEntity[key] = value ?? "";
        setState(() {});
      },
    );
  }

  Widget boolCheckboxListTile(key) {
    return CheckboxListTile(
      title: Text(key),
      value: shadowEntity[key] ?? false,
      onChanged: (value) {
        setState(() {
          shadowEntity[key] = value;
        });
      },
    );
  }

  Widget dateTimeTextFormField(key) {
    return TextFormField(
      initialValue: shadowEntity[key]?.toString() ?? '',
      decoration:
          widget.dateTimeInputDecorationOverride?.copyWith(labelText: key) ??
              InputDecoration(labelText: key),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter some text';
        }
        if (DateTime.tryParse(value) == null) {
          return 'Please enter a date';
        }
        return null;
      },
      onSaved: (value) {
        shadowEntity[key] = DateTime.parse(value!);
        setState(() {});
      },
    );
  }

  Widget dynamicTextFormField(key) {
    return TextFormField(
      initialValue: shadowEntity[key]?.toString() ?? "",
      decoration:
          widget.stringInputDecorationOverride?.copyWith(labelText: key) ??
              InputDecoration(labelText: key),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter some text';
        }
        return null;
      },
      onSaved: (value) {
        shadowEntity[key] = value ?? '';

        setState(() {});
      },
    );
  }

  Widget selectTextFormField(key, List<String> options) {
    return DropdownButtonFormField(
      value: shadowEntity[key],
      decoration:
          widget.selectInputDecorationOverride?.copyWith(labelText: key) ??
              InputDecoration(labelText: key),
      items: options.map((String value) {
        return DropdownMenuItem(
          value: value,
          child: Text(value),
        );
      }).toList(),
      validator: (value) {
        if (value == null) {
          return 'Please select an option';
        }
        return null;
      },
      onChanged: (value) {
        shadowEntity[key] = value;
        setState(() {});
      },
    );
  }

  // Autocomplete form field usign AutocompleteSource that has a function that returns a list of strings (async or not). Use material autocomplete
  Widget autocompleteTextFormField(key, AutocompleteSource source) {
    if (source == null) throw Exception("AutocompleteSource cannot be null");
    return Autocomplete(
      optionsBuilder: (TextEditingValue textEditingValue) async {
        if (textEditingValue.text == '') {
          return const Iterable<String>.empty();
        }
        return await source.source!(textEditingValue.text);
      },
      onSelected: (String selection) {
        shadowEntity[key] = selection;
        setState(() {});
      },
      fieldViewBuilder: (BuildContext context,
          TextEditingController textEditingController,
          FocusNode focusNode,
          VoidCallback onFieldSubmitted) {
        return TextFormField(
          controller: textEditingController,
          decoration:
              widget.stringInputDecorationOverride?.copyWith(labelText: key) ??
                  InputDecoration(labelText: key),
          focusNode: focusNode,
          onFieldSubmitted: (String value) {
            onFieldSubmitted();
          },
        );
      },
      optionsViewBuilder: (BuildContext context,
          AutocompleteOnSelected<String> onSelected, Iterable<String> options) {
        return Align(
          alignment: Alignment.topLeft,
          child: Material(
            elevation: 4.0,
            child: SizedBox(
              height: 200.0,
              child: ListView(
                padding: const EdgeInsets.all(8.0),
                children: options
                    .map((String option) => GestureDetector(
                          onTap: () {
                            onSelected(option);
                          },
                          child: ListTile(
                            title: Text(option),
                          ),
                        ))
                    .toList(),
              ),
            ),
          ),
        );
      },
    );
  }
}
