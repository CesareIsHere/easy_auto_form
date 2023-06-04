library easy_auto_form;

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
    this.onCancel,
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

              // If key is an int field type, create an input with int validators
              if (widget.entity[key] is int) {
                widgets.add(
                  TextFormField(
                    initialValue: shadowEntity[key]?.toString() ?? "0",
                    decoration: widget.intInputDecorationOverride
                            ?.copyWith(labelText: key) ??
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
                  ),
                );
              }
              // If key is a double field type, create an input with double validators
              else if (widget.entity[key] is double) {
                widgets.add(
                  TextFormField(
                    initialValue: shadowEntity[key]?.toString() ?? "0",
                    decoration: widget.doubleInputDecorationOverride
                            ?.copyWith(labelText: key) ??
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
                  ),
                );
              }
              // If key is a String field type, create an input with String validators
              else if (widget.entity[key] is String) {
                widgets.add(
                  TextFormField(
                    initialValue: shadowEntity[key]?.toString() ?? "",
                    decoration: widget.stringInputDecorationOverride
                            ?.copyWith(labelText: key) ??
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
                  ),
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
                  TextFormField(
                    initialValue: shadowEntity[key]?.toString() ?? '',
                    decoration: widget.dateTimeInputDecorationOverride
                            ?.copyWith(labelText: key) ??
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
                  ),
                );
              }
              // If key is a dynamic field type, create a text input
              else {
                widgets.add(
                  TextFormField(
                    initialValue: shadowEntity[key]?.toString() ?? "",
                    decoration: widget.stringInputDecorationOverride
                            ?.copyWith(labelText: key) ??
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
                  ),
                );
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
}
