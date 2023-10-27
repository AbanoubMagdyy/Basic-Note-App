import 'dart:io';
import 'package:basic_fivver_note_app/components/components.dart';
import 'package:basic_fivver_note_app/screens/view_image_screen.dart';
import 'package:basic_fivver_note_app/shared/add_note_bloc/cubit.dart';
import 'package:basic_fivver_note_app/shared/add_note_bloc/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../layout/layout_screen.dart';
import '../models/note_model.dart';
import '../style/colors.dart';
import 'background_image.dart';

class NoteScreen extends StatelessWidget {
  final Note note;
  final double requiredHeight = 750;
  final titleController = TextEditingController();

  final noteController = TextEditingController();

  NoteScreen(this.note, {super.key});

  @override
  Widget build(BuildContext context) {
    String images = note.images;
    final paths = images.split(',');
    AddNoteCubit.get(context).imageFiles =
        paths.map((path) => File(path.trim())).toList();

    titleController.text = note.title;
    noteController.text = note.note;
    if (images == 'null') {
      AddNoteCubit.get(context).removeImages();
    }

    return BlocConsumer<AddNoteCubit, AddNotesStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = AddNoteCubit.get(context);

        return WillPopScope(
          onWillPop: () async {
            if (noteController.text != note.note ||
                titleController.text != note.title) {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    backgroundColor: secondColor,
                    contentPadding: const EdgeInsetsDirectional.all(50),
                    content: Text(
                      'Do you want to save this edit'.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    actions: [
                      MaterialButton(
                        onPressed: () {
                          Navigator.pop(context);
                          cubit
                              .updateNote(
                            title: titleController.text,
                            id: note.id,
                            time: DateFormat.jm().format(DateTime.now()),
                            date: DateFormat.yMMMMd().format(DateTime.now()),
                            note: noteController.text,
                          )
                              .then((value) {
                            cubit.removeImages();
                            toast(msg: 'edit note success', isError: false);
                          });
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
                          cubit.removeImages();
                          navigateTo(context, const LayoutScreen());
                        },
                        child: Text(
                          'cancel'.toUpperCase(),
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              );
            }
            return true;
          },
          child: Scaffold(
            body: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                final double availableHeight = constraints.maxHeight;

                return BackgroundImage(
                  sigma: 25,
                  child: Padding(
                    padding:
                        const EdgeInsets.only(top: 10.0, right: 20, left: 10),
                    child: SafeArea(
                      child: Column(
                        children: [
                          ///appBar
                          Row(
                            children: [
                              defIconButton(
                                icon: Icons.arrow_back_ios,
                                onTap: () {
                                  navigateTo(context, const LayoutScreen());
                                },
                              ),
                              const Spacer(),
                              defIconButton(
                                icon: Icons.save_outlined,
                                onTap: () {
                                  cubit
                                      .updateNote(
                                    title: titleController.text,
                                    id: note.id,
                                    time:
                                        DateFormat.jm().format(DateTime.now()),
                                    date: DateFormat.yMMMMd()
                                        .format(DateTime.now()),
                                    note: noteController.text,
                                  )
                                      .then((value) {
                                    toast(msg: 'edit note success', isError: false);
                                    Navigator.pop(context);
                                    cubit.removeImages();
                                  });
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
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10, top: 15),
                              child: Column(
                                children: [
                                  /// title
                                  TextFormField(
                                    maxLines: 1,
                                    controller: titleController,
                                    style: const TextStyle(
                                      fontSize: 24,
                                      wordSpacing: 5,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'Title',
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),

                                  /// note
                                  Expanded(
                                    flex: 2,
                                    child: TextFormField(
                                      minLines: 1,
                                      maxLines: 1000,
                                      controller: noteController,
                                      keyboardType: TextInputType.multiline,
                                      style: const TextStyle(
                                        fontSize: 24,
                                        wordSpacing: 5,
                                        height: 1.3,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      decoration: const InputDecoration(
                                        border: InputBorder.none,
                                        hintText:
                                            'Type Something if you want ot edit ...',
                                      ),
                                    ),
                                  ),

                                  /// images
                                  if (cubit.imageFiles.isNotEmpty)
                                    Expanded(
                                      flex: 1,
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 5),
                                        child: ListView.separated(
                                            separatorBuilder:
                                                (context, index) =>
                                                    const SizedBox(width: 5),
                                            scrollDirection: Axis.horizontal,
                                            itemCount: cubit.imageFiles.length,
                                            itemBuilder: (context, index) {
                                              if (cubit.imageFiles.isNotEmpty) {
                                                final file =
                                                    cubit.imageFiles[index];
                                                return InkWell(
                                                  onTap: () {
                                                    navigateTo(
                                                      context,
                                                      FullScreenImage(
                                                          imagePath: file.path),
                                                    );
                                                  },
                                                  child: Stack(
                                                    children: [
                                                      Image.file(file),
                                                      if (availableHeight >=
                                                          750)
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                            top: 8.0,
                                                          ),
                                                          child: defIconButton(
                                                            height: 40,
                                                            icon: Icons
                                                                .delete_outline,
                                                            onTap: () => cubit
                                                                .removeImage(
                                                              file,
                                                            ),
                                                          ),
                                                        ),
                                                      if (requiredHeight >
                                                              availableHeight &&
                                                          availableHeight > 350)
                                                        IconButton(
                                                          icon: const Icon(Icons
                                                              .remove_circle_outline_sharp),
                                                          onPressed: () =>
                                                              cubit.removeImage(
                                                                  file),
                                                          alignment:
                                                              Alignment.topLeft,
                                                          padding:
                                                              EdgeInsets.zero,
                                                        ),
                                                    ],
                                                  ),
                                                );
                                              }
                                              return null;
                                            }),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
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
