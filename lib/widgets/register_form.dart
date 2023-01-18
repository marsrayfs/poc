import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:standalone_pkg/presentation/sign_in_bloc/sign_in_bloc.dart';
import 'package:standalone_pkg/util/result.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SignInBloc, SignInState>(
      listener: (context, state) {
        // if (state.state == RegisterStateEnum.registered) {
        if (state is AuthenticatedUser) {
          final result = ((state.result as Success)).data as User;
          debugPrint('state: $result');
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Signed up successfully!'),
              backgroundColor: Colors.green));
        }
        if (state is EmailNotVerified) {
          _showSignInDialog(context, 'oops',
              'please verify your email address, check your email or tap resend to receive new verification',
              actions: [
                TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text('close')),
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      context.read<SignInBloc>().add(SendEmailVerification());
                    },
                    child: Text('resend'))
              ]);
        }
        if (state is UserInfoNotExisted) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('user have no collection info')));
        }
        if (state is ExceptionOccurred) {
          debugPrint('failed: ${state.message}');
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(state.message), backgroundColor: Colors.red));
        }
        if (state is EmailVerificationSent) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('please check your email!'),
              backgroundColor: Colors.red));
        }
      },
      builder: (context, state) {
        return Stack(
          children: [
            Card(
              child: Column(
                children: [
                  TextFormField(
                    decoration:
                        const InputDecoration(hintText: 'Email Address'),
                    controller: emailController,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(hintText: 'Password'),
                    controller: passwordController,
                    obscureText: true,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      context.read<SignInBloc>().add(SignIn(
                          email: emailController.text,
                          password: passwordController.text));
                    },
                    child: const Text("Register"),
                  )
                ],
              ),
            ),
            if (state is SignInLoading)
              const Center(
                child: CircularProgressIndicator(),
              )
          ],
        );
      },
    );
  }

  Future _showSignInDialog(BuildContext context, String title, String message,
      {List<Widget>? actions}) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => AlertDialog(
            title: Text(title,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            content: Text(message, style: const TextStyle(fontSize: 14)),
            actions: actions));
  }
}
