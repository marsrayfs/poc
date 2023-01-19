import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:poc/util/string_constant.dart';
import 'package:standalone_pkg/domain/model/user.dart';
import 'package:standalone_pkg/presentation/profilepic_bloc/profilepic_bloc.dart';
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
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(parent: ScrollPhysics()),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const ProfilePhotoWidget(),
                const SizedBox(
                  height: 30,
                ),
                BlocConsumer<UserBloc, UserState>(
                  listener: (context, state) {
                    if (state is SaveInfoSuccess) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('success')));
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (context) => DashBoardScreen()),
                          (Route<dynamic> route) => false);
                    }
                    if (state is UserInfoException) {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text(state.message)));
                    }
                  },
                  builder: (context, state) {
                    return SingleChildScrollView(
                      child: Stack(
                        children: [
                          FormBuilder(
                            key: _formKey,
                            child: Column(
                              children: [
                                FormBuilderTextField(
                                  name: StringConstant.nickName,
                                  decoration: const InputDecoration(
                                      hintText: 'Nickname',
                                      labelText: 'Nickname'),
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
                                    initialValue:
                                        genderList.asMap()[2].toString(),
                                    name: StringConstant.gender,
                                    borderColor: Colors.black45,
                                    selectedColor: Colors.blue,
                                    options: genderList
                                        .map((gender) => FormBuilderFieldOption(
                                            value: gender,
                                            child: SizedBox(
                                                height: 30,
                                                child: Center(
                                                    child: Text(gender)))))
                                        .toList(),
                                    decoration: const InputDecoration(
                                        border: InputBorder.none,
                                        filled: false)),
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
                                      if (_formKey.currentState!
                                          .saveAndValidate()) {
                                        ProfilepicState profilePicState =
                                            context
                                                .read<ProfilepicBloc>()
                                                .state;
                                        String photoUrl =
                                            profilePicState is ProfilpicSaved
                                                ? (profilePicState.result).data
                                                    as String
                                                : '';

                                        debugPrint('photoUrl: $photoUrl');
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
                                          firstnameKana:
                                              _formKey.currentState?.value[
                                                  StringConstant.kanaFirstName],
                                          lastnameKana:
                                              _formKey.currentState?.value[
                                                  StringConstant.kanaLastName],
                                          sex: _formKey.currentState
                                              ?.value[StringConstant.gender],
                                          addressCity: _formKey.currentState
                                              ?.value[StringConstant.city],
                                          addressNumber:
                                              _formKey.currentState?.value[
                                                  StringConstant.addressNumber],
                                          addressPrefecture:
                                              _formKey.currentState?.value[
                                                  StringConstant.prefecture],
                                          phoneNumber:
                                              _formKey.currentState?.value[
                                                  StringConstant.phoneNumber],
                                          photo: photoUrl,
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
                    );
                  },
                ),
              ],
            ),
          ),
        ));
  }
}

class ProfilePhotoWidget extends StatefulWidget {
  const ProfilePhotoWidget({Key? key}) : super(key: key);

  @override
  State<ProfilePhotoWidget> createState() => _ProfilePhotoWidgetState();
}

class _ProfilePhotoWidgetState extends State<ProfilePhotoWidget> {
  File? iconFile;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet<void>(
            context: context,
            builder: (BuildContext context) {
              return Wrap(children: [
                _uploadPhotoItem(
                    icon: Icons.photo_library_rounded,
                    title: 'Select from Gallery',
                    onTap: () {
                      Navigator.of(context).pop();
                      pickImage(context: context, isOpenCamera: false);
                    },
                    isEnable: true),
                _uploadPhotoItem(
                    icon: Icons.camera_alt_rounded,
                    title: 'Open Camera',
                    onTap: () {
                      Navigator.of(context).pop();
                      pickImage(context: context, isOpenCamera: true);
                    },
                    isEnable: true)
              ]);
            });
      },
      child: Stack(
        children: [
          CircleAvatar(
              backgroundColor: Colors.blue,
              radius: 80,
              child: iconFile != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(80),
                      child: Image.file(iconFile!,
                          fit: BoxFit.cover, width: 300, height: 300))
                  : const Icon(Icons.person, size: 80, color: Colors.white)),
          circularAddIcon()
        ],
      ),
    );
  }

  Future pickImage(
      {required BuildContext context, required bool isOpenCamera}) async {
    final contextRead = context.read<ProfilepicBloc>();
    try {
      final image = await ImagePicker().pickImage(
          source: isOpenCamera ? ImageSource.camera : ImageSource.gallery,
          maxHeight: 512,
          maxWidth: 512,
          imageQuality: 75);
      if (image == null) return;
      final imageTemp = File(image.path);
      setState(() => iconFile = imageTemp);
      contextRead.add(UploadProfilepicEvent(imageTemp));
    } on PlatformException catch (e) {
      debugPrint('Failed to pick image: $e');
    }
  }

  _uploadPhotoItem(
      {required IconData icon,
      required String title,
      required Function() onTap,
      required bool isEnable}) {
    return ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20),
        leading: Icon(icon,
            color: isEnable ? Colors.black : Colors.black38, size: 20),
        title: Text(title,
            style: TextStyle(
                color: isEnable ? Colors.black : Colors.black38, fontSize: 15)),
        onTap: isEnable ? onTap : null);
  }

  Widget circularAddIcon() => const Positioned(
      top: 10,
      right: 0,
      child: CircleAvatar(
          radius: 15,
          backgroundColor: Colors.white,
          child: CircleAvatar(
              backgroundColor: Colors.grey,
              radius: 14,
              child: Icon(Icons.add, size: 20))));
}
