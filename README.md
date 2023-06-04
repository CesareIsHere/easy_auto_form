<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages).
-->

A widget that generates a form based on a given entity.
The `AutoForm` widget is designed to work with any entity that is represented as a `Map<String, dynamic>`.
This means that it can be used with a wide variety of data types, including but not limited to:
- User profiles
- Product listings
- Blog posts
- Contact information
- Survey responses
The `AutoForm` widget will generate input fields for each key in the entity map, and will automatically determine the appropriate input type based on the value type.

## Features

- Supports a variety of entity types, including user profiles, product listings, blog posts, contact information, and survey responses.
- Includes options to ignore specific fields, override input decoration for different data types, and handle form submission and cancellation.


## Getting started

- Add the dependency to your `pubspec.yaml` file:

```yaml
dependencies:
  auto_form: ^0.0.1
```

- Install it

You can install packages from the command line:

```bash
$ flutter pub get
```

- Import it

Now in your Dart code, you can use:

```dart
import 'package:auto_form/auto_form.dart';
```

## Usage

The `AutoForm` widget is designed to work with any entity that is represented as a `Map<String, dynamic>`.
This means that it can be used with a wide variety of data types, including but not limited to:
- User profiles
- Product listings
- Blog posts
- Contact information
- Survey responses
The `AutoForm` widget will generate input fields for each key in the entity map, and will automatically determine the appropriate input type based on the value type.

```dart
import 'package:auto_form/auto_form.dart';

class User {
  String name;
  String email;
  String password;

    User({this.name, this.email, this.password});

    Map<String, dynamic> toMap() {
        return {
            'name': name,
            'email': email,
            'password': password,
        };
        }
    }

    final user = User(name: 'John Doe', email: 'john@gmail.com', password '123456');

    AutoForm(
        entity: user.toMap(),
        onSaved: (entity) {
            // Do something with the entity
        },
        onCancel: () {
            // Do something when the form is cancelled
        },
    );
```

## Additional information

TODO: Tell users more about the package: where to find more information, how to
contribute to the package, how to file issues, what response they can expect
from the package authors, and more.
