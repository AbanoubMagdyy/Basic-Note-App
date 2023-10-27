import 'dart:convert';
import 'dart:io';
import 'package:basic_fivver_note_app/models/user_model.dart';
import 'package:basic_fivver_note_app/screens/birthday_screen.dart';
import 'package:basic_fivver_note_app/screens/home_screen.dart';
import 'package:basic_fivver_note_app/shared/bloc/states.dart';
import 'package:basic_fivver_note_app/shared/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class NotesCubit extends Cubit<NotesStates> {
  NotesCubit() : super(InitState());

  static NotesCubit get(context) => BlocProvider.of(context);

  List<Widget> screens = [
    const HomeScreen(),
    const BirthdayScreen(),
  ];

  int currantIndex = 0;

  void changeBNB(int index) {
    currantIndex = index;
    emit(ChangeBNB());
  }

  DateTime date = DateTime.now();
  bool putDate = false;

  void showTheDate({
    required context,
  }) {
    showDatePicker(
            context: context,
            initialDate: DateTime(1980, 07, 31),
            firstDate: DateTime(1950),
            lastDate: DateTime(DateTime.now().year))
        .then((value) {
      date = value!;
      putDate = true;
      emit(SuccessChooseDate());
    }).catchError((error) {
      if (kDebugMode) {
        print(error);
      }
      emit(ErrorChooseDate());
    });
  }

  ImagePicker imagePicker = ImagePicker();
  File? profileImage;

  Future<void> getImageFromGallery() async {
    final XFile? pickedFile =
        await imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      profileImage = File(pickedFile.path);
      emit(SuccessPutImage());
    } else {
      emit(ErrorPutImage());
    }
  }

   UserInfo model = UserInfo(name: '', birthday: '', profileImage: '');

  late String json;




  void saveDate(model) {
    json = jsonEncode(model);
    Shared.saveDate(key: 'user', value: json);
    emit(SaveData());
  }

  getData() {
    Map<String, dynamic> jsonData = jsonDecode(Shared.getDate('user'));
    model = UserInfo.fromJson(jsonData);
    emit(GetData());
  }

  updateData(name, birthday, profileImage) {
    model =
        UserInfo(name: name, birthday: birthday, profileImage: profileImage);
    saveDate(model);
    getData();
    emit(UpdateData());
  }

  bool isThisMyBirthday = false;

  void birthday() {
    isThisMyBirthday = !isThisMyBirthday;
    emit(Birthday());
  }
}
