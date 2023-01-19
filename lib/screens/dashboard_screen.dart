import 'package:cached_network_image/cached_network_image.dart';
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
                  CircleAvatar(
                      backgroundColor: Colors.blue,
                      radius: 80,
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(80),
                          child: CachedNetworkImage(
                              imageUrl: state.user.photo.toString(),
                              placeholder: (context, url) =>
                                  const CircularProgressIndicator(),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                              fit: BoxFit.cover,
                              width: 300,
                              height: 300))),
                  const SizedBox(
                    height: 20,
                  ),
                  Text('${state.user.nickname}'),
                  Text(
                    '${state.user.firstname} ${state.user.lastname}',
                    style: const TextStyle(
                        fontStyle: FontStyle.italic, fontSize: 20),
                  ),
                  BottomNavigationBar(items: const [
                    BottomNavigationBarItem(icon: Icon(Icons.abc), label: "hi"),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.abc), label: "hello"),
                  ]),
                  const SizedBox(
                    height: 20,
                  ),
                  _infoWidget('Birth Date: ',
                      '${state.user.birthYear}-${state.user.birthDay}-${state.user.birthMonth}'),
                  _infoWidget('Kana Name: ',
                      '${state.user.firstnameKana} ${state.user.lastnameKana}'),
                  _infoWidget('Gender: ', state.user.sex.toString()),
                  _infoWidget('City: ', state.user.addressCity.toString()),
                  _infoWidget(
                      'Address Number: ', state.user.addressNumber.toString()),
                  _infoWidget(
                      'Prefecture: ', state.user.addressPrefecture.toString()),
                  _infoWidget(
                      'Phone Number: ', state.user.phoneNumber.toString()),
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

  _infoWidget(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          const Spacer(),
          Expanded(
              flex: 2,
              child: Text(
                title,
                textAlign: TextAlign.left,
              )),
          Expanded(
            flex: 2,
            child: Text(
              value,
              style: const TextStyle(fontSize: 18),
              textAlign: TextAlign.left,
            ),
          ),
          const Spacer()
        ],
      ),
    );
  }
}
