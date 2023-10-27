import 'package:basic_fivver_note_app/shared/bloc/cubit.dart';
import 'package:basic_fivver_note_app/shared/bloc/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutAppScreen extends StatelessWidget {
  final double requiredWidth = 390;

  const AboutAppScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff564638),
      body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final double availableWidth = constraints.maxWidth;
            double radius = constraints.maxWidth / 18;


            return  SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Container(
                  alignment: Alignment.center,
                  width: double.infinity,
                  height: double.infinity,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/thanks.png'),
                      fit: BoxFit.fill,
                    ),
                  ),
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Column(
                        children: [
                          Expanded(child: Container()),
                          const SizedBox(height: 20,),
                          Expanded(
                            flex: 2,
                            child: Column(
                              children: [
                                /// text
                                BlocConsumer<NotesCubit,NotesStates>(
                                  listener: (context,state){},
                                  builder: (context,state){

                                    return Expanded(
                                      child: SingleChildScrollView(
                                        child: Text(
                                          'Dear ${NotesCubit.get(context).model.name.toUpperCase().split(' ')[0]}, \n\ni wanted to take this opportunity to wish you all the happiness and success in your life. May all your dreams come true and may you continue to achieve great things.\n\nIf you ever encounter any problems while using application, please do not hesitate to contact me. i am always here to help and provide support. Your feedback is important to me and i committed to providing the best possible experience for you.\n\nThank you for choosing my application and hope that you continue to enjoy using it.\n\nBest regards,\nAbanoub',
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold, fontSize: 25),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                const SizedBox(height: 10,),
                                /// ITEMS
                                if(requiredWidth <= availableWidth)
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      /// facebook and gmail
                                      Padding(
                                        padding: const EdgeInsets.only(bottom: 10.0),
                                        child: item(
                                          image1: 'assets/images/social/facebook.png',
                                          name1: 'Facebook',
                                          onTap1: facebook,
                                          image2: 'assets/images/social/gmail.png',
                                          name2: 'Gmail',
                                          onTap2: gmail,
                                        ),
                                      ),

                                      /// whats app and telegram
                                      Padding(
                                        padding: const EdgeInsets.only(bottom: 10.0),
                                        child: item(
                                          image1: 'assets/images/social/whatsapp.png',
                                          name1: 'What\'s App',
                                          onTap1: whatsApp,
                                          image2: 'assets/images/social/telegram.png',
                                          name2: 'Telegram',
                                          onTap2: telegram,
                                        ),
                                      ),

                                      /// linkedin and fivver
                                      Padding(
                                        padding: const EdgeInsets.only(bottom: 10.0),
                                        child: item(
                                          image1: 'assets/images/social/fivver.png',
                                          name1: 'Fivver',
                                          image2: 'assets/images/social/linkedin.png',
                                          name2: 'Linkedin', onTap1: () {  },
                                          onTap2: linkedIn,
                                        ),
                                      ),
                                    ],
                                  ),
                                if(requiredWidth > availableWidth)
                                  Container(
                                    height: 80,
                                    margin: const EdgeInsets.only(bottom: 10),
                                    decoration: BoxDecoration(
                                      color: const Color(0xffa18848),
                                      borderRadius: BorderRadius.circular(20),

                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        /// telegram
                                        socialMediaItem(
                                          image:
                                          'assets/images/social/telegram.png',
                                          onTap: telegram,
                                          radius: radius,
                                        ),

                                        /// whats app
                                        socialMediaItem(
                                          image:
                                          'assets/images/social/whatsapp.png',
                                          onTap: whatsApp,
                                          radius: radius,
                                        ),

                                        /// facebook
                                        socialMediaItem(
                                          image:
                                          'assets/images/social/facebook.png',
                                          onTap: facebook,
                                          radius: radius,
                                        ),

                                        /// gmail
                                        socialMediaItem(
                                          image:
                                          'assets/images/social/gmail.png',
                                          onTap: gmail,
                                          radius: radius,
                                        ),

                                        /// fivver
                                        socialMediaItem(
                                          image:
                                          'assets/images/social/fivver.png',
                                          onTap: () {},
                                          radius: radius,
                                        ),

                                        /// linkedin
                                        socialMediaItem(
                                          image:
                                          'assets/images/social/linkedin.png',
                                          onTap: linkedIn,
                                          radius: radius,
                                        ),
                                      ],
                                    ),
                                  )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          }
      ),
    );
  }

  Widget item({
    required String image1,
    required String name1,
    required String image2,
    required String name2,
    required Function() onTap1,
    required  Function() onTap2,
  }) =>
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          /// icon 1
          Expanded(
            child: InkWell(
              onTap: onTap1,
              child: Container(
                height: 55,
                padding: const EdgeInsetsDirectional.all(10),
                margin: const EdgeInsetsDirectional.only(end: 5),
                decoration: const BoxDecoration(color: Color(0xffa18848)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Image.asset(image1),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      name1,
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 17,),
                    )
                  ],
                ),
              ),
            ),
          ),

          /// icon 2
          Expanded(
            child: InkWell(
              onTap:onTap2 ,
              child: Container(
                height: 55,
                padding: const EdgeInsetsDirectional.all(10),
  margin: const EdgeInsetsDirectional.only(start: 5),
  decoration: const BoxDecoration(color: Color(0xffa18848)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Image.asset(image2),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      name2,
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      );


  gmail()async{
    final Uri uri = Uri(
        scheme: 'mailto',
        path: 'noteapps31@gmail.com'
    );
    if(await canLaunchUrl(uri)){
      await launchUrl(uri);
    } else{
      throw 'could font $uri';
    }
  }

  facebook()async{
    final Uri url = Uri.parse('fb://facewebmodal/f?href=https://www.facebook.com/abanoub.magdy.129');
    if (await launchUrl(url,)) {
      throw 'Could not launch $url';
    }else {
      // Launch the Facebook website in the browser.
      await launchUrl(Uri.parse('https://www.facebook.com/my-facebook-account'));
    }
  }

  Future<void> telegram() async {
    final Uri url = Uri.parse('tg://resolve?domain=AbanoubMagdy15');
    if (!await launchUrl(url)) {
      throw 'Could not launch $url';
    }
  }

  Future<void> linkedIn() async {
    final Uri url = Uri.parse('https://www.linkedin.com/in/magdy-mouris-a8376a244/');
    if (!await launchUrl(url)) {
      throw 'Could not launch $url';
    }
  }

  Future<void> whatsApp() async {
    final Uri url = Uri.parse('whatsapp://send?phone=+201278803223');
    if (!await launchUrl(url)) {
      throw 'Could not launch $url';
    }
  }

  Widget socialMediaItem({
    required String image,
    required double radius,
    required Function() onTap,
  }) =>
      InkWell(
          onTap: onTap,
          child: CircleAvatar(
            radius: radius,
            backgroundImage: AssetImage(image),
          ));
}
