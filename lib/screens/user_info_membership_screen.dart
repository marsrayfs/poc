import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'package:poc/util/string_constant.dart';
import 'package:standalone_pkg/domain/model/user.dart';
import 'package:standalone_pkg/presentation/user_bloc/user_bloc.dart';

import 'dashboard_screen.dart';

class UserInfoMemberShipScreen extends StatelessWidget {
  UserInfoMemberShipScreen({Key? key}) : super(key: key);

  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();

  ///gender
  static const List<String> genderList = ["Female", "Male", "Others"];

  ///prefectures
  static const List<String> prefectureList = [
    'Cebu',
    'Luzon',
    'Visayas',
    'Mindanao'
  ];

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
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Stack(
                  children: [
                    FormBuilder(
                      key: _formKey,
                      child: Column(
                        children: [
                          FormBuilderTextField(
                            name: StringConstant.nickName,
                            decoration: const InputDecoration(
                                hintText: 'Nickname', labelText: 'Nickname'),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              Flexible(
                                child: FormBuilderTextField(
                                  name: StringConstant.firstName,
                                  decoration: const InputDecoration(
                                      hintText: 'First Name',
                                      labelText: 'First Name'),
                                ),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Flexible(
                                child: FormBuilderTextField(
                                  name: StringConstant.lastName,
                                  decoration: const InputDecoration(
                                      hintText: 'Last Name',
                                      labelText: 'Last Name'),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              Flexible(
                                child: FormBuilderTextField(
                                  name: StringConstant.kanaFirstName,
                                  decoration: const InputDecoration(
                                      hintText: 'Kana First Name',
                                      labelText: 'Kana First Name'),
                                ),
                              ),
                              const SizedBox(width: 20),
                              Flexible(
                                child: FormBuilderTextField(
                                  name: StringConstant.kanaLastName,
                                  decoration: const InputDecoration(
                                      hintText: 'Kana Last Name',
                                      labelText: 'Kana Last Name'),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          FormBuilderSegmentedControl<String>(
                              padding: const EdgeInsets.all(0),
                              initialValue: genderList.asMap()[2].toString(),
                              name: StringConstant.gender,
                              borderColor: Colors.black45,
                              selectedColor: Colors.blue,
                              options: genderList
                                  .map((gender) => FormBuilderFieldOption(
                                      value: gender,
                                      child: SizedBox(
                                          height: 30,
                                          child: Center(child: Text(gender)))))
                                  .toList(),
                              decoration: const InputDecoration(
                                  border: InputBorder.none, filled: false)),
                          const SizedBox(
                            height: 20,
                          ),
                          FormBuilderDateTimePicker(
                            lastDate: DateTime.now(),
                              name: StringConstant.birthdate,
                              inputType: InputType.date,
                              format: DateFormat("yyyy-MM-dd"),
                              decoration: const InputDecoration(
                                hintText: 'Birth Date',
                                labelText: 'Birth Date',
                              )),
                          const SizedBox(
                            height: 20,
                          ),
                          FormBuilderTextField(
                            name: StringConstant.city,
                            keyboardType: TextInputType.streetAddress,
                            decoration: const InputDecoration(
                                hintText: 'City', labelText: 'City'),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          FormBuilderTextField(
                            name: StringConstant.addressNumber,
                            keyboardType: TextInputType.streetAddress,
                            decoration: const InputDecoration(
                                hintText: 'Address Number',
                                labelText: 'Address Number'),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          FormBuilderDropdown(
                              name: StringConstant.prefecture,
                              isExpanded: false,
                              items: prefectureList
                                  .map((prefecture) => DropdownMenuItem(
                                      value: prefecture,
                                      child: Text(prefecture)))
                                  .toList(),
                              decoration: const InputDecoration(
                                  fillColor: Colors.white,
                                  filled: true,
                                  hintText: 'Prefecture',
                                  labelText: 'Prefecture')),
                          const SizedBox(
                            height: 20,
                          ),
                          FormBuilderTextField(
                            name: StringConstant.phoneNumber,
                            keyboardType: TextInputType.phone,
                            decoration: const InputDecoration(
                                hintText: 'Phone Number',
                                labelText: 'Phone Number'),
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
                                  var birthdate = [];
                                  var birthday = _formKey.currentState
                                      ?.value[StringConstant.birthdate];
                                  if (birthday != null) {
                                    birthdate = birthday
                                        .toString()
                                        .substring(0, 10)
                                        .split("-");
                                  }
                                  final user = User(
                                    uid: '',
                                    nickname: _formKey.currentState
                                        ?.value[StringConstant.nickName],
                                    firstname: _formKey.currentState
                                        ?.value[StringConstant.firstName],
                                    lastname: _formKey.currentState
                                        ?.value[StringConstant.lastName],
                                    birthYear: birthdate.isNotEmpty
                                        ? int.parse(birthdate[0])
                                        : -1,
                                    birthDay: birthdate.isNotEmpty
                                        ? int.parse(birthdate[1])
                                        : -1,
                                    birthMonth: birthdate.isNotEmpty
                                        ? int.parse(birthdate[2])
                                        : -1,
                                    firstnameKana: _formKey.currentState
                                        ?.value[StringConstant.kanaFirstName],
                                    lastnameKana: _formKey.currentState
                                        ?.value[StringConstant.kanaLastName],
                                    sex: _formKey.currentState
                                        ?.value[StringConstant.gender],
                                    addressCity: _formKey.currentState
                                        ?.value[StringConstant.city],
                                    addressNumber: _formKey.currentState
                                        ?.value[StringConstant.addressNumber],
                                    addressPrefecture: _formKey.currentState
                                        ?.value[StringConstant.prefecture],
                                    phoneNumber: _formKey.currentState
                                        ?.value[StringConstant.phoneNumber],
                                    subscription: false,
                                    withdraw: false,
                                  );

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
