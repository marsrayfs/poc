import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:standalone_pkg/domain/repository/firebase_user_repository_impl.dart';
import 'package:standalone_pkg/domain/usecase/user_usecase.dart';
import 'package:standalone_pkg/presentation/user_bloc/user_bloc.dart';

class DashBoardScreen extends StatelessWidget {
  DashBoardScreen({Key? key}) : super(key: key);

  final userInfo = UserBloc(UserUseCase(FirebaseUserRepositoryImpl()));

  @override
  Widget build(BuildContext context) {
    userInfo.add(FetchUserInfo());
    return Scaffold(
      body: BlocConsumer<UserBloc, UserState>(
        bloc: userInfo,
        listener: (context, state) {
          if (state is UserInfoLoaded) {
            debugPrint('authenticated: ${state.user}');
          }
        },
        builder: (context, state) {
          if (state is UserInfoLoaded) {
            // final user = ((state.user as Success)).data as User;
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Welcome to dashboard',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text('${state.user.nickname}'),
                  Text(
                    '${state.user.firstname} ${state.user.lastname}',
                    style: const TextStyle(
                        fontStyle: FontStyle.italic, fontSize: 20),
                  ),
                ],
              ),
            );
          }
          if (state is UserInfoLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return Container();
        },
      ),
    );
  }
}
