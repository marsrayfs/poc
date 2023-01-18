import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:poc/screens/sign_in_screen.dart';
import 'package:standalone_pkg/domain/model/remote_config.dart';
import 'package:standalone_pkg/domain/repository/firebase_configuration_repository_impl.dart';
import 'package:standalone_pkg/domain/repository/firebase_register_repository_impl.dart';
import 'package:standalone_pkg/domain/repository/firebase_send_email_verification_repository_impl.dart';
import 'package:standalone_pkg/domain/repository/firebase_sign_in_repository_impl.dart';
import 'package:standalone_pkg/domain/repository/firebase_user_repository_impl.dart';
import 'package:standalone_pkg/domain/usecase/get_config_usecase.dart';
import 'package:standalone_pkg/domain/usecase/register_usecase.dart';
import 'package:standalone_pkg/domain/usecase/send_email_verification_usecase.dart';
import 'package:standalone_pkg/domain/usecase/sign_in_usecase.dart';
import 'package:standalone_pkg/domain/usecase/user_usecase.dart';
import 'package:standalone_pkg/presentation/config_bloc/config_bloc.dart';
import 'package:standalone_pkg/presentation/register_bloc/register_bloc.dart';
import 'package:standalone_pkg/presentation/sign_in_bloc/sign_in_bloc.dart';
import 'package:standalone_pkg/presentation/user_bloc/user_bloc.dart';
import 'package:standalone_pkg/util/result.dart';

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // return const Scaffold();
    print("My App Started");
    return MultiBlocProvider(
      providers: [
        BlocProvider<SignInBloc>(
            create: (BuildContext context) => SignInBloc(
                SignInUseCase(FirebaseSignInRepositoryImpl()),
                UserUseCase(FirebaseUserRepositoryImpl()),
                SendEmailVerificationUseCase(
                    FirebaseSendEmailVerificationRepositoryImpl()))),
        BlocProvider<RegisterBloc>(
            create: (BuildContext context) => RegisterBloc(
                RegisterUseCase(FirebaseRegisterRepositoryImpl()),
                SendEmailVerificationUseCase(
                    FirebaseSendEmailVerificationRepositoryImpl()))),
        BlocProvider<ConfigBloc>(
            create: (BuildContext context) => ConfigBloc(
                GetConfigUseCase(FirebaseRemoteConfigRepositoryImpl()))
              ..add(const RequestConfigurationEvent())),
        BlocProvider<UserBloc>(
            create: (BuildContext context) =>
                UserBloc(UserUseCase(FirebaseUserRepositoryImpl()))),
      ],
      child: BlocConsumer<ConfigBloc, ConfigState>(
        listener: (context, state) {
          // print("MyApp Consumer:" + (state.result as Failure).error.toString());
          if (state.state == ConfigStateEnum.sucess) {
            FlutterNativeSplash.remove();
          } // TODO: implement listener
        },
        builder: (context, state) {
          return MaterialApp(
            title: 'Flutter Demo',
            theme: ThemeData(
              fontFamily: 'Poppins',
              primarySwatch: Colors.blue,
            ),
            home: SignInScreen(
              backgroundColor: state.result == null
                  ? "red"
                  : state.result is Success
                      ? ((state.result as Success).data as RemoteConfiguration)
                          .color
                      : "blue",
            ),
            // home: RegisterScreen(
            //   color: state.result == null
            //       ? "red"
            //       : state.result is Success
            //           ? ((state.result as Success).data as RemoteConfiguration)
            //               .color
            //           : "blue",
            // ),
          );
        },
      ),
    );
  }
}
