// ignore_for_file: must_be_immutable
import 'package:FLUTTER_APPLICATION_1/picker/user_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AuthForm extends StatefulWidget {
  AuthForm(this.submit, this.isloading);
  final void Function(String email, String name, String password, bool islogin,
      BuildContext ctx, XFile image) submit;
  bool isloading;
  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  bool _isLogin = true;
  XFile? pickimage;
  void _pickedImage(XFile image) {
    pickimage = image;
  }

  void _trySubmit() {
    final bool isValid = formKey.currentState?.validate() ?? false;

    if (!_isLogin && pickimage == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Image is not picked'),
        backgroundColor: Colors.red,
      ));
      return;
    }

    if (isValid) {
      formKey.currentState?.save();

      if (!_isLogin || (pickimage != null)) {
        widget.submit(
            emailController.text.trim(),
            usernameController.text.trim(),
            passwordController.text.trim(),
            _isLogin,
            context,
            pickimage!);
      } else {
        widget.submit(
          emailController.text.trim(),
          usernameController.text.trim(),
          passwordController.text.trim(),
          _isLogin,
          context,
          pickimage ?? XFile(''),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: formKey,
              autovalidateMode: AutovalidateMode.disabled,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!_isLogin)
                    user_image_picker(
                      imagepikedfn: _pickedImage,
                    ),
                  TextFormField(
                    key: const ValueKey('email'),
                    controller: emailController,
                    validator: (value) {
                      if (value!.isEmpty || !value.contains('@')) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.emailAddress,
                    decoration:
                        const InputDecoration(labelText: 'Email Address'),
                    onSaved: (value) {
                      // No need to save in this case
                    },
                  ),
                  if (!_isLogin)
                    TextFormField(
                      key: const ValueKey('username'),
                      controller: usernameController,
                      validator: (value) {
                        if (value!.length < 4) {
                          return 'Please enter at least 4 characters';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(labelText: 'Username'),
                      onSaved: (value) {
                        // No need to save in this case
                      },
                    ),
                  TextFormField(
                    key: const ValueKey('password'),
                    controller: passwordController,
                    validator: (value) {
                      if (value!.length < 7) {
                        return 'Password must be at least 7 characters long';
                      }
                      return null;
                    },
                    obscureText: true,
                    decoration: const InputDecoration(labelText: 'Password'),
                    onSaved: (value) {
                      // No need to save in this case
                    },
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  if (widget.isloading) const CircularProgressIndicator(),
                  if (!widget.isloading)
                    ElevatedButton(
                      onPressed: _trySubmit,
                      child: Text(_isLogin ? 'Login' : 'Signup'),
                    ),
                  if (!widget.isloading)
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _isLogin = !_isLogin;
                          emailController.text = '';
                          usernameController.text = '';
                          passwordController.text = '';
                        });
                      },
                      child: Text(_isLogin
                          ? 'Create New account'
                          : 'I already have an account'),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
