import 'dart:io';
import 'package:basic_fivver_note_app/components/components.dart';
import 'package:basic_fivver_note_app/screens/note_screen.dart';
import 'package:basic_fivver_note_app/shared/add_note_bloc/cubit.dart';
import 'package:basic_fivver_note_app/shared/add_note_bloc/states.dart';
import 'package:basic_fivver_note_app/shared/bloc/cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import '../models/note_model.dart';
import '../style/colors.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    NotesCubit.get(context).getData();
    return BlocConsumer<AddNoteCubit, AddNotesStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = AddNoteCubit.get(context);
        return WillPopScope(
          onWillPop: () async {
            SystemNavigator.pop();
            return false;
          },
          child: Column(
            children: [
              /// item
              if (cubit.notes.isNotEmpty)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Column(
                      children: [
                        Expanded(
                          child: StaggeredGridView.countBuilder(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            itemCount: cubit.notes.length,
                            itemBuilder: (context, index) {
                              return optionNoteItem(
                                  context, cubit.notes[index], index);
                            },
                            staggeredTileBuilder: (index) {
                              return index == 0
                                  ? const StaggeredTile.count(
                                  1, 1.0) //For Text
                                  : const StaggeredTile.count(
                                  1, 1.2); // others item
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              /// item is empty
              if (cubit.notes.isEmpty)
                ifNotesEmpty(),
            ],
          ),
        );
      },
    );
  }

  Widget ifNotesEmpty() => Expanded(
        child: SizedBox(
            height: double.infinity,
            width: double.infinity,
            child: Image.asset(
              'assets/gif/write_note.gif',
              fit: BoxFit.fill,
            )),
      );

  Widget noteItem({required Map model, index, context}) => LayoutBuilder(
  builder: (BuildContext context, BoxConstraints constraints) {
    final double availableWidth = constraints.maxWidth;
    const double minWidthForDate = 200;
    const double requiredWidthForTitle = 100;
    return Container(
      color: defColor.withOpacity(0.6),
      padding: const EdgeInsetsDirectional.all(15),
      child: Builder(builder: (context) {
        String images = model['image_paths'];
        final paths = images.split(',');
        final files = paths.map((path) => File(path.trim())).toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// title
            if (model['title'].toString().isNotEmpty && requiredWidthForTitle <= availableWidth)
              Padding(
                padding: const EdgeInsets.only(bottom: 15.0),
                child: Text(
                  '${model['title']}',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 27,
                      height: 1.15,
                      color: secondColor),
                ),
              ),

            /// note
            Expanded(
              flex: 2,
              child: Text(
                '${model['note']}',
                style: const TextStyle(
                  fontSize: 20,
                  height: 1.15,
                  color: secondColor,
                ),
              ),
            ),
            /// image
            if (model['image_paths'] != 'null')
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 5,top: 5),
                  child: ListView.separated(
                    physics: const BouncingScrollPhysics(),
                    separatorBuilder: (context, index) =>
                    const SizedBox(width: 5),
                    scrollDirection: Axis.horizontal,
                    itemCount: files.length,
                    itemBuilder: (context, index) {
                      final file = files[index];
                      return Image.file(file);
                    },
                  ),
                ),
              ),

            /// DATE
            if(minWidthForDate <= availableWidth)
            Row(
              children: [
                Text(
                  '${model['date']}',
                  style: const TextStyle(
                    color: secondColor,
                  ),
                ),
                const Spacer(),
                Text(
                  '${model['time']}',
                  style: const TextStyle(
                    color: secondColor,
                  ),
                ),
              ],
            )
          ],
        );
      },
      ),
    );
  }
  );

  Widget optionNoteItem(context, Map model, index) => FocusedMenuHolder(
        animateMenuItems: false,
        duration: const Duration(milliseconds: 0),
        menuWidth: MediaQuery.of(context).size.width * 0.50,
        menuItems: <FocusedMenuItem>[
          FocusedMenuItem(
              title: const Text(
                'open',
                style: TextStyle(fontSize: 25, height: 1.15, color: defColor),
              ),
              onPressed: () {
                Note note = Note(
                  id: model['id'],
                  title: model['title'],
                  note: model['note'],
                  date: model['date'],
                  time: model['time'],
                  images: model['image_paths'],
                );
                navigateTo(
                  context,
                  NoteScreen(note),
                );
              },
              trailingIcon: const Icon(Icons.open_in_new_rounded)),
          FocusedMenuItem(
            title: const Text(
              'delete',
              style: TextStyle(fontSize: 25, height: 1.15, color: defColor),
            ),
            onPressed: () {
              AddNoteCubit.get(context).deleteDB(id: model['id']);
            },
            trailingIcon: const Icon(
              Icons.delete_outline,
            ),
            backgroundColor: Colors.red,
          ),
        ],
        onPressed: () {},
        child: InkWell(
          onTap: () {
            Note note = Note(
              id: model['id'],
              title: model['title'],
              note: model['note'],
              date: model['date'],
              time: model['time'],
              images: model['image_paths'],
            );
            navigateTo(
              context,
              NoteScreen(note),
            );
          },
          child: noteItem(model: model, context: context),
        ),
      );
}
