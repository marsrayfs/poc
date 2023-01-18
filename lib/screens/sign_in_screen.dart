import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:poc/screens/sign_up_screen.dart';
import 'package:standalone_pkg/domain/model/user.dart';
import 'package:standalone_pkg/presentation/sign_in_bloc/sign_in_bloc.dart';
import 'package:standalone_pkg/util/result.dart';

import 'dashboard_screen.dart';
import 'user_info_membership_screen.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({Key? key, required this.backgroundColor})
      : super(key: key);
  final String backgroundColor;

  @override
  Widget build(BuildContext context) {
    var emailController = TextEditingController();
    var passwordController = TextEditingController();

    return Scaffold(
      backgroundColor: getColor(backgroundColor),
      body: BlocConsumer<SignInBloc, SignInState>(
        listener: (context, state) {
          if (state is AuthenticatedUser) {
            final result = ((state.result as Success)).data as User;
            debugPrint('state: $result');
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Signed in successfully!')));
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => DashBoardScreen()),
                (Route<dynamic> route) => false);
          }
          if (state is EmailNotVerified) {
            _showSignInDialog(context, 'oops',
                'please verify your email address, check your email or tap resend to receive new verification',
                actions: [
                  TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Close')),
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        context.read<SignInBloc>().add(SendEmailVerification());
                      },
                      child: const Text('Resend'))
                ]);
          }
          if (state is UserInfoNotExisted) {
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('user have no collection info')));
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => UserInfoMemberShipScreen()));
          }
          if (state is ExceptionOccurred) {
            debugPrint('failed: ${state.message}');
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.message)));
          }
          if (state is EmailVerificationSent) {
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('please check your email!')));
          }
        },
        builder: (context, state) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(20),
                        child: Text(
                          'Sign In',
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 40),
                      TextFormField(
                        decoration:
                            const InputDecoration(hintText: 'Email Address'),
                        controller: emailController,
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        decoration: const InputDecoration(hintText: 'Password'),
                        controller: passwordController,
                        obscureText: true,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        height: 50,
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            context.read<SignInBloc>().add(SignIn(
                                email: emailController.text,
                                password: passwordController.text));
                          },
                          child: const Text("Sign In"),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                          width: double.infinity,
                          child: TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const SignUpScreen()),
                                );
                              },
                              child: const Text(
                                'Sign Up',
                                style: TextStyle(color: Colors.white),
                              )))
                    ],
                  ),
                  if (state is SignInLoading)
                    const Center(
                      child: CircularProgressIndicator(),
                    )
                ],
              ),
            ),
          );
        },
      ),
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

  Color getColor(String color) {
    switch (color) {
      case "red":
        return Colors.red;
      case "blue":
        return Colors.blue;
      case "green":
        return Colors.green;
    }
    return Colors.black;
  }
}
