import 'dart:io';

import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:basic_fivver_note_app/shared/bloc/cubit.dart';
import 'package:basic_fivver_note_app/shared/bloc/states.dart';
import 'package:basic_fivver_note_app/style/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../components/components.dart';
import '../components/constants.dart';
import '../screens/add_note_screen.dart';
import '../screens/background_image.dart';
import '../screens/create_account_screen.dart';
import '../screens/edit_screen.dart';
import '../screens/settings_screen.dart';
import '../shared/shared_preferences.dart';

class LayoutScreen extends StatelessWidget {
  final double requiredWidth = 280;
  const LayoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var hour = DateTime.now().hour;
    String greeting = "";
    if (hour < 12 && hour > 6) {
      greeting = "Good Morning";
    } else if (hour > 12 && hour < 18) {
      greeting = "Good Afternoon";
    } else if (hour > 18 && hour < 24) {
      greeting = "Good Evening";
    } else {
      greeting = "Good Night";
    }
    return BlocConsumer<NotesCubit, NotesStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = NotesCubit.get(context);
        final pageController = PageController(initialPage: cubit.currantIndex);
        return FutureBuilder<bool>(
          future: isLogged(),
          builder: (context, AsyncSnapshot<bool> snapshot) {
            if (snapshot.hasData && snapshot.data!) {
              return Scaffold(
                floatingActionButton: FloatingActionButton(
                  backgroundColor: secondColor,
                  onPressed: () {
                    navigateTo(context, AddNoteScreen());
                  },
                  child: const Icon(
                    Icons.add,
                  ),
                ),
                floatingActionButtonLocation:
                    FloatingActionButtonLocation.centerDocked,
                bottomNavigationBar: AnimatedBottomNavigationBar(
                  backgroundColor: defColor,
                  inactiveColor: secondColor,
                  activeColor: Colors.white,
                  shadow: const Shadow(blurRadius: 10),
                  gapLocation: GapLocation.center,
                  onTap: (int index) {
                    cubit.changeBNB(index);
                    pageController.animateToPage(cubit.currantIndex,
                        duration: const Duration(milliseconds: 1),
                        curve: Curves.ease);
                  },
                  activeIndex: cubit.currantIndex,
                  icons: const [Icons.home_outlined, Icons.cake_outlined],
                ),
                body: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  final double availableWidth = constraints.maxWidth;

                  return BackgroundImage(
                    child: SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          children: [
                            /// appbar
                            if(requiredWidth <= availableWidth)
                            BlocConsumer<NotesCubit, NotesStates>(
                              listener: (context, state) {},
                              builder: (context, state) {
                                var cubit = NotesCubit.get(context);
                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    /// text
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              constraints: BoxConstraints(
                                                maxWidth: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                    2 -
                                                    80,
                                              ),
                                              child: Text(
                                                'Hi ,${cubit.model.name.toUpperCase().split(' ')[0]}',
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                    fontSize: 23, height: 1.14),
                                              ),
                                            ),
                                            const Text(
                                              '👋',
                                              style: TextStyle(
                                                  fontSize: 23, height: 1.14),
                                            )
                                          ],
                                        ),
                                        Text(
                                          greeting,
                                          style: const TextStyle(
                                              fontSize: 23, height: 1.14),
                                        ),
                                      ],
                                    ),
                                    const Spacer(),

                                    /// item
                                    InkWell(
                                      onTap: () {
                                        navigateTo(context, EditScreen());
                                      },
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              color: defColor,
                                              borderRadius:
                                              BorderRadiusDirectional.circular(
                                                  30),
                                            ),
                                            child: Row(
                                              children: [
                                                /// text
                                                Container(
                                                  margin: const EdgeInsetsDirectional
                                                      .symmetric(horizontal: 10),
                                                  constraints: BoxConstraints(
                                                    maxWidth: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                        2 -
                                                        110,
                                                  ),
                                                  child: Text(
                                                    NotesCubit.get(context)
                                                        .model
                                                        .name
                                                        .toUpperCase()
                                                        .split(' ')[0],
                                                    overflow: TextOverflow.ellipsis,
                                                    style: const TextStyle(
                                                      color: secondColor,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                ),

                                                ///image
                                                if(cubit.model.profileImage != '')
                                                CircleAvatar(
                                                  backgroundImage: FileImage(
                                                    File(cubit.model.profileImage),
                                                  ),
                                                  radius: 21,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    /// settings
                                    defIconButton(
                                      onTap: () {
                                        navigateTo(
                                          context,
                                          const SettingsScreen(),
                                        );
                                      },
                                      icon: Icons.settings_outlined,
                                    ),
                                  ],
                                );
                              },
                            ),
                            Expanded(
                              child: PageView(
                                controller: pageController,
                                children: cubit.screens,
                                onPageChanged: (int index) {
                                  cubit.changeBNB(index);
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }
                ),
              );
            } else {
              return CreateAccount();
            }
          },
        );
      },
    );
  }

  Future<bool> isLogged() async {
    return Shared.getDate(login) ?? false;
  }
}
