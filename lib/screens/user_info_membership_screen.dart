import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:standalone_pkg/domain/model/user.dart';
import 'package:standalone_pkg/presentation/user_bloc/user_bloc.dart';
import 'package:standalone_pkg/util/string_constant.dart';

import 'dashboard_screen.dart';

class UserInfoMemberShipScreen extends StatelessWidget {
  UserInfoMemberShipScreen({Key? key}) : super(key: key);

  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('User Info Membership'),
        ),
        body: BlocConsumer<UserBloc, UserState>(
          listener: (context, state) {
            if (state is SaveInfoSuccess) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(const SnackBar(content: Text('success')));
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => DashBoardScreen()),
                  (Route<dynamic> route) => false);
            }
            if (state is UserInfoException) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(state.message)));
            }
          },
          builder: (context, state) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Stack(
                  children: [
                    FormBuilder(
                      key: _formKey,
                      child: Column(
                        children: [
                          const SizedBox(height: 40),
                          FormBuilderTextField(
                            name: StringConstant.nickName,
                            decoration:
                                const InputDecoration(hintText: 'Nickname'),
                          ),
                          const SizedBox(height: 10),
                          FormBuilderTextField(
                            name: StringConstant.firstName,
                            decoration:
                                const InputDecoration(hintText: 'Firstname'),
                          ),
                          const SizedBox(height: 10),
                          FormBuilderTextField(
                            name: StringConstant.lastName,
                            decoration:
                                const InputDecoration(hintText: 'Lastname'),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          SizedBox(
                            height: 50,
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState!.saveAndValidate()) {
                                  final user = User(
                                      uid: '',
                                      nickname: _formKey.currentState
                                          ?.value[StringConstant.nickName],
                                      firstname: _formKey.currentState
                                          ?.value[StringConstant.firstName],
                                      lastname: _formKey.currentState
                                          ?.value[StringConstant.lastName]);
                                  context
                                      .read<UserBloc>()
                                      .add(SaveUserInfo(user));
                                }
                              },
                              child: const Text("Save Information"),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (state is UserInfoLoading)
                      const Center(
                        child: CircularProgressIndicator(),
                      )
                  ],
                ),
              ),
            );
          },
        ));
  }
}
