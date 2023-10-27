import 'dart:io';
import 'package:basic_fivver_note_app/screens/about_app_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../components/components.dart';
import '../shared/bloc/cubit.dart';
import '../shared/bloc/states.dart';
import '../style/colors.dart';
import 'background_image.dart';
import 'edit_screen.dart';

class SettingsScreen extends StatelessWidget {
  final double requiredWidth = 280;

  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NotesCubit, NotesStates>(
      listener: (context, state) {},
      builder: (context, state) {
        NotesCubit cubit = NotesCubit.get(context);
        return Scaffold(
          body: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              final double availableWidth = constraints.maxWidth;
              double radius = constraints.maxWidth / 3;


              return BackgroundImage(
                sigma: 20,
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        /// APPBAR
                        defAppBar(context: context, screenName: 'settings'),

                        Expanded(
                          child: Center(
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  ///   image
                                  CircleAvatar(
                                    radius: radius,
                                    backgroundColor: secondColor,
                                    child: CircleAvatar(
                                      backgroundImage: FileImage(
                                        File(cubit.model.profileImage),
                                      ),
                                      radius: radius-10,
                                    ),
                                  ),

                                  ///   NAME
                                  text(text: cubit.model.name),

                                  /// birthday
                                  text(text: cubit.model.birthday),

                                  /// ITEMS
                                  if(requiredWidth <= availableWidth)
                                  Column(
                                    children: [
                                      /// about app
                                      item(
                                        leftIcon: Icons.info_outline,
                                        itemName: 'about app',
                                        context: context,
                                        nextScreen: const AboutAppScreen(),
                                      ),

                                      /// edit profile
                                      item(
                                        leftIcon: Icons.mode_edit_outline_outlined,
                                        itemName: 'edit profile',
                                        context: context,
                                        nextScreen: EditScreen(),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            }
          ),
        );
      },
    );
  }

  Widget item({
    required IconData leftIcon,
    required String itemName,
    required context,
    required Widget nextScreen,
  }) =>
      InkWell(
        onTap: () => navigateTo(context, nextScreen),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: Row(
            children: [
              defIconButton(icon: leftIcon),
              const SizedBox(
                width: 10,
              ),
              Text(
                itemName.toUpperCase(),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              const Spacer(),
              defIconButton(icon: Icons.arrow_forward_ios),
              const SizedBox(
                width: 7,
              ),
            ],
          ),
        ),
      );

  Widget text({
    required String text,
  }) =>
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Text(
          text.toUpperCase(),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25,
            color: defColor,
          ),
        ),
      );
}
