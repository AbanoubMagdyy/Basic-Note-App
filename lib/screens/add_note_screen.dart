import 'dart:io';
import 'package:basic_fivver_note_app/components/components.dart';
import 'package:basic_fivver_note_app/screens/view_image_screen.dart';
import 'package:basic_fivver_note_app/shared/add_note_bloc/cubit.dart';
import 'package:basic_fivver_note_app/shared/add_note_bloc/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../layout/layout_screen.dart';
import '../style/colors.dart';
import 'background_image.dart';

class AddNoteScreen extends StatelessWidget {
  final title = TextEditingController();
  final note = TextEditingController();
  final double requiredWidth = 320;
  final double requiredHeight = 750;

  AddNoteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AddNoteCubit, AddNotesStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = AddNoteCubit.get(context);
        return WillPopScope(
          onWillPop: () async {
            if (note.text.isNotEmpty ||
                title.text.isNotEmpty ||
                cubit.imageFiles.isNotEmpty) {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      backgroundColor: secondColor,
                      contentPadding: const EdgeInsetsDirectional.all(50),
                      content: Text(
                        'Do you want to save this note'.toUpperCase(),
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      actions: [
                        MaterialButton(
                          onPressed: () {
                            Navigator.pop(context);
                            toast(msg: 'add note success', isError: false);
                            cubit
                                .insertNoteToDB(
                              time: DateFormat.jm().format(DateTime.now()),
                              date: DateFormat.yMMMMd().format(DateTime.now()),
                              title: title.text,
                              note: note.text,
                            )
                                .then(
                              (value) {
                                cubit.removeImages();
                              },
                            );

                            Navigator.pop(context);
                          },
                          child: Text(
                            'save'.toUpperCase(),
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        MaterialButton(
                          onPressed: () {
                            AddNoteCubit.get(context).removeImages();
                            navigateTo(context, const LayoutScreen());
                          },
                          child: Text(
                            'cancel'.toUpperCase(),
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    );
                  },
              );
            } else {
              Navigator.pop(context);
            }
            return true;
          },
          child: Scaffold(
            body: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
              final double availableWidth = constraints.maxWidth;
              final double availableHeight = constraints.maxHeight;
              return BackgroundImage(
                sigma: 25,
                child: Padding(
                  padding:
                      const EdgeInsets.only(right: 20, left: 10),
                  child: SafeArea(
                    child: Column(
                      children: [
                        ///appBar
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: Row(
                             mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              if(requiredWidth <= availableWidth)
                              Expanded(
                                child: Row(
                                  children: [
                                    defIconButton(
                                      icon: Icons.arrow_back_ios,
                                      onTap: () {
                                          navigateTo(context, const LayoutScreen());
                                      },
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      'Add Note'.toUpperCase(),
                                      style: const TextStyle(
                                        fontSize: 24,
                                        wordSpacing: 5,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              defIconButton(
                                icon: Icons.check,
                                onTap: () {
                                  if (note.text.isNotEmpty ||
                                      title.text.isNotEmpty ||
                                      cubit.imageFiles.isNotEmpty) {
                                    cubit
                                        .insertNoteToDB(
                                      time:
                                          DateFormat.jm().format(DateTime.now()),
                                      date: DateFormat.yMMMMd()
                                          .format(DateTime.now()),
                                      title: title.text,
                                      note: note.text,
                                    )
                                        .then(
                                      (value) {
                                        toast(msg: 'add note success', isError: false);
                                        cubit.removeImages();
                                        Navigator.pop(context);
                                      },
                                    );
                                  } else {
                                    toast(msg: 'he note is empty', isError: false);
                                  }
                                },
                              ),
                              defIconButton(
                                icon: Icons.photo_library_outlined,
                                onTap: () {
                                  cubit.selectImages();
                                },
                              )
                            ],
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Column(
                              children: [
                                /// title
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 15.0),
                                  child: TextFormField(
                                    maxLines: 1,
                                    controller: title,
                                    style: const TextStyle(
                                      fontSize: 24,
                                      wordSpacing: 5,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Please enter some information';
                                      }
                                      return null;
                                    },
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'Title',
                                    ),
                                  ),
                                ),

                                /// note
                                Expanded(
                                  flex: 2,
                                  child: SingleChildScrollView(
                                    child: TextFormField(
                                      enabled: true,
                                      readOnly: false,
                                      minLines: 1,
                                      maxLines: 1000,
                                      controller: note,
                                      keyboardType: TextInputType.multiline,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'Please enter some information';
                                        }
                                        return null;
                                      },
                                      style: const TextStyle(
                                        fontSize: 24,
                                        wordSpacing: 5,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      decoration: const InputDecoration(
                                        border: InputBorder.none,
                                        hintText: 'Type Something ...',
                                      ),
                                    ),
                                  ),
                                ),

                                /// images
                                if (cubit.imageFiles.isNotEmpty)
                                  Expanded(
                                    flex: 1,
                                    child: Padding(
                                      padding: const EdgeInsets.only(bottom: 5),
                                      child: ListView.separated(
                                        itemCount: cubit.imageFiles.length,
                                        scrollDirection: Axis.horizontal,
                                        separatorBuilder: (context, index) =>
                                            const SizedBox(width: 5),
                                        itemBuilder: (context, index) {
                                          File? imageFile =
                                              cubit.imageFiles[index];
                                          return InkWell(
                                            onTap: () {
                                              navigateTo(
                                                context,
                                                FullScreenImage(
                                                    imagePath: imageFile.path),
                                              );
                                            },
                                            child: Stack(
                                              children: [
                                                Image.file(imageFile),
                                                if(availableHeight >= 750)
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 8.0),
                                                  child: defIconButton(
                                                    height: 40,
                                                    icon: Icons.delete_outline,
                                                    onTap: () => cubit
                                                        .removeImage(imageFile),
                                                  ),
                                                ),
                                                if(requiredHeight > availableHeight && availableHeight > 350)
                                                  IconButton(
                                                    icon:const Icon(Icons.remove_circle_outline_sharp),
                                                    onPressed: () =>
                                                        cubit.removeImage(imageFile),
                                                    alignment: Alignment.topLeft,
                                                    padding: EdgeInsets.zero,
                                                  ),
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
            ),
          ),
        );
      },
    );
  }
}
