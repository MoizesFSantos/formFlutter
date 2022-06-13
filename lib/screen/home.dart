// ignore_for_file: prefer_const_constructors
import 'package:string_validator/string_validator.dart' as validator;
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final controller = TextEditingController();
  final formKey = GlobalKey<FormState>();
  var user = UserModel();
  var passwordCache = '';
  var passwordCacheConfirm = '';
  bool isVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Forms'),
      ),
      body: Form(
        key: formKey,
        child: Padding(
          padding: EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              // ignore: prefer_const_literals_to_create_immutables
              children: [
                CustomTextField(
                  label: 'Name',
                  hint: 'type your name ...',
                  icon: Icons.person,
                  onSaved: (text) => user = user.copyWith(name: text),
                  validator: (text) {
                    if (text == null || text.isEmpty) {
                      return 'this field can\'t be empty';
                    }
                    if (text.length < 3) {
                      return 'Name must have more than 3 characters';
                    }
                  },
                ),
                SizedBox(height: 15.0),
                CustomTextField(
                  label: 'Email',
                  hint: 'type your email ...',
                  icon: Icons.mail,
                  onSaved: (text) => user = user.copyWith(email: text),
                  validator: (text) {
                    if (text == null || text.isEmpty) {
                      return 'this field can\'t be empty';
                    }
                    if (!validator.isEmail(text)) {
                      return 'value must be email type';
                    }
                  },
                ),
                SizedBox(height: 15.0),
                CustomTextField(
                  label: 'Password',
                  hint: 'type your password ...',
                  icon: Icons.vpn_key,
                  obscureText: isVisible,
                  suffix: IconButton(
                    onPressed: () {
                      setState(() {
                        isVisible = !isVisible;
                      });
                    },
                    icon: Icon(
                      isVisible ? Icons.visibility : Icons.visibility_off,
                    ),
                  ),
                  onSaved: (text) => user = user.copyWith(password: text),
                  validator: (text) {
                    if (text == null || text.isEmpty) {
                      return 'this field can\'t be empty';
                    }
                  },
                  onChanged: (text) => passwordCache = text,
                ),
                SizedBox(height: 15.0),
                CustomTextField(
                  label: 'Confirm Password',
                  hint: 'Confirm Password ...',
                  icon: Icons.vpn_key,
                  obscureText: isVisible,
                  suffix: IconButton(
                    onPressed: () {
                      setState(() {
                        isVisible = !isVisible;
                      });
                    },
                    icon: Icon(
                      isVisible ? Icons.visibility : Icons.visibility_off,
                    ),
                  ),
                  onSaved: (text) => user = user.copyWith(password: text),
                  validator: (text) {
                    if (text == null || text.isEmpty) {
                      return 'this field can\'t be empty';
                    }
                    if (passwordCacheConfirm != passwordCache) {
                      return 'Password must be the same';
                    }
                  },
                  onChanged: (text) => passwordCacheConfirm = text,
                ),
                SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton.icon(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          formKey.currentState!.save();
                          print(''' 
                            FORM
                            Name: ${user.name}
                            Email: ${user.email}
                            password: ${user.password}
                          ''');
                        }
                      },
                      icon: Icon(Icons.save),
                      label: Text('Save')),
                ),
                SizedBox(height: 15),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(primary: Colors.red),
                      onPressed: () {
                        formKey.currentState?.reset();
                      },
                      icon: Icon(Icons.save),
                      label: Text('Reset')),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  final String label;
  final String? hint;
  final IconData? icon;
  final bool obscureText;
  final Widget? suffix;
  final String? Function(String? text)? validator;
  final void Function(String? text)? onSaved;
  final void Function(String text)? onChanged;

  const CustomTextField({
    Key? key,
    required this.label,
    this.icon,
    this.hint,
    this.validator,
    this.onSaved,
    this.onChanged,
    this.obscureText = false,
    this.suffix,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: validator,
      onSaved: onSaved,
      onChanged: onChanged,
      obscureText: obscureText,
      decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          border: OutlineInputBorder(),
          prefixIcon: icon == null ? null : Icon(icon),
          suffixIcon: suffix),
    );
  }
}

@immutable
class UserModel {
  final String name;
  final String email;
  final String password;

  UserModel({
    this.name = '',
    this.email = '',
    this.password = '',
  });

  UserModel copyWith({
    String? name,
    String? email,
    String? password,
  }) {
    return UserModel(
        name: name ?? this.name,
        email: email ?? this.email,
        password: password ?? this.password);
  }
}
