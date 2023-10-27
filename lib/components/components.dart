import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../style/colors.dart';

Widget defTextField({
  required TextEditingController controller,
  required IconData icon,
  IconData? leftIcon,
  required String text,
  void Function()? onTap,
  void Function()? leftIconOnPressed,
  double fontSize = 25,
  bool hideInput = false,
  TextInputType keyboard = TextInputType.text,
  bool hideKeyboard = false,
}) =>
    TextFormField(
      readOnly: hideKeyboard,
      obscureText: hideInput,
      keyboardType: keyboard,
      style: TextStyle(
          fontSize: fontSize, wordSpacing: 5, fontWeight: FontWeight.bold,),
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please enter some information';
        }
        return null;
      },
      onTap: onTap,
      controller: controller,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderSide: const BorderSide(
            color: defColor,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: defColor,
          ),
        ),
        prefixIcon: Icon(
          icon,
          color: defColor,
        ),
        suffixIcon: IconButton(
          onPressed: () {},
          icon: Icon(leftIcon),
        ),
        hintText: text.toUpperCase(),
        hintStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );

Widget defTextButton({
  required String text,
  required void Function()? onTap,
}) =>
    Container(
      height: 60,
      width: 210,
      margin: const EdgeInsetsDirectional.symmetric(vertical: 15),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadiusDirectional.circular(30),
      ),
      child: MaterialButton(
        onPressed: onTap,
        color: defColor,
        child: Text(
          text,
          style: const TextStyle(
            color: secondColor,
            fontSize: 18,
          ),
        ),
      ),
    );

void navigateAndFinish(context, Widget screen) => Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => screen,
      ),
      (route) => false,
    );

void navigateTo(context, Widget screen) => Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => screen,
      ),
    );

Widget defIconButton({
  void Function()? onTap,
  required IconData icon,
  double margin = 7,
  double height = 45,
  Color iconColor = secondColor,
}) =>
    Container(
      height: height,
      margin: EdgeInsetsDirectional.only(start: margin),
      decoration: BoxDecoration(
        color: defColor,
        borderRadius: BorderRadiusDirectional.circular(20),
      ),
      child: IconButton(
        onPressed: onTap,
        icon: Icon(
          icon,
          color: iconColor,
        ),
      ),
    );

Widget defAppBar({
  required context,
  required String screenName,
})=>  Row(
  children: [
    defIconButton(
      icon: Icons.arrow_back_ios,
      onTap: () {
        Navigator.pop(context);
      },
    ),
    const SizedBox(
      width: 10,
    ),
    Text(
      screenName.toUpperCase(),
      style: const TextStyle(
        fontSize: 24,
        wordSpacing: 5,
        fontWeight: FontWeight.bold,
      ),
    ),
  ],
);

Future<bool?> toast({
  required String msg,
  required bool isError,
}) =>
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: isError ? Colors.red : Colors.black,
        textColor: Colors.white,
        fontSize: 18);

