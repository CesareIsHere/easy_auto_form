import 'package:easy_auto_form/easy_auto_form.dart';

import 'package:flutter/material.dart';

class TestPage extends StatefulWidget {
  const TestPage({super.key});

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    var entity = <String, dynamic>{
      "name": "test",
      "age": 30,
      "height": 1.8,
      "isMarried": true,
    };
    return Scaffold(
      appBar: AppBar(
        title: const Text('TestPage'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: EasyAutoForm(
            formKey: formKey,
            entity: entity,
            runDirection: RunDirection.vertical,
            expanded: true,
            onSave: (entity) {
              print(entity);
            },
            onCancel: () {},
            fieldsSettings: FieldsSettings(
              settings: [
                FieldSetting(
                    fieldKey: "name",
                    inputType: FieldInputType.autocomplete,
                    autocompleteSource: AutocompleteSource(
                      source: (pattern) async => [
                        "test",
                        "test2",
                        "test3",
                        "test4"
                      ].where((element) => element.contains(pattern)).toList(),
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
