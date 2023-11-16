// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:FLUTTER_APPLICATION_1/widgets/auth_form_state.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;
  bool _isLoading = false;

  // Create a GlobalKey<ScaffoldMessengerState>
  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  void _submitAuth(String email, String name, String password, bool isLogin,
      BuildContext ctx, XFile image) async {
    try {
      if (!mounted) {
        return; // Check if the widget is still mounted
      }

      setState(() {
        _isLoading = true;
      });

      UserCredential authentication;

      if (isLogin) {
        authentication = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Login successful'),
            duration: Duration(
                seconds:
                    2), // Optional: Set the duration for how long the SnackBar should be displayed.
          ),
        );
      } else {
        authentication = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        // Setup storage reference
        final ref = FirebaseStorage.instance
            .ref()
            .child('user_image')
            .child(authentication.user!.uid + '.jpg');

        // Upload the file
        await ref.putFile(File(image.path)).then((taskSnapshot) async {
          // Retrieve the download URL after the file is uploaded
          final url = await ref.getDownloadURL();

          // Store user data in Firestore with the download URL
          await FirebaseFirestore.instance
              .collection('users')
              .doc(authentication.user!.uid)
              .set({'username': name, 'email': email, 'url': url});

          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('account created successfully'),
              duration: Duration(seconds: 2),
            ),
          );
        });
      }

      if (mounted) {
        // Check if the widget is still mounted before setting state
        setState(() {
          _isLoading = false;
        });
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage = 'Error occurred while login';

      if (e.code.contains('INVALID_LOGIN_CREDENTIALS')) {
        errorMessage =
            'Invalid login credentials. Please check your email or sign up.';
      } else if (e.code == 'user-not-found') {
        errorMessage = 'User not found. Please check your email or sign up.';
      } else if (e.code == 'wrong-password') {
        errorMessage = 'Incorrect password. Please try again.';
      } else {
        errorMessage = 'Unexpected error: ${e.message}';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          duration: const Duration(seconds: 2),
        ),
      );

      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      // Handle other exceptions

      _scaffoldMessengerKey.currentState?.showSnackBar(
        const SnackBar(
          content: Text('An error occurred. Please try again.'),
        ),
      );

      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple,
      body: AuthForm(
        _submitAuth,
        _isLoading,
      ),
    );
  }

  @override
  void dispose() {
    // Dispose of the GlobalKey
    _scaffoldMessengerKey.currentState?.dispose();
    super.dispose();
  }
}
