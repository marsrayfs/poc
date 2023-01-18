import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:standalone_pkg/presentation/register_bloc/register_bloc.dart';
import 'package:standalone_pkg/util/result.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var emailController = TextEditingController();
    var passwordController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text('Sign Up')),
      body: BlocConsumer<RegisterBloc, RegisterState>(
        listener: (context, state) {
          if (state.state == RegisterStateEnum.registered) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text(
                    'Signed up successfully! Please check your email to verify')));
            Navigator.of(context).pop();
          }
          if (state.state == RegisterStateEnum.failed) {
            final message = ((state.result as Failure)).error as String;
            debugPrint('failed: $message');
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(message)));
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
                            context.read<RegisterBloc>().add(StartRegisterEvent(
                                emailController.text, passwordController.text));
                          },
                          child: const Text("Sign Up"),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                          width: double.infinity,
                          child: TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text(
                                'Sign In',
                                style: TextStyle(color: Colors.black87),
                              )))
                    ],
                  ),
                  if (state.state == RegisterStateEnum.loading)
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
}
