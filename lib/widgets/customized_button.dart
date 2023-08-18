import 'package:flutter/material.dart';

class CustomizedButton extends StatelessWidget {
  final String? buttonText;
  final Color? buttonColour;
  final Color? textColour;
  final VoidCallback? onPressed;

  const CustomizedButton(
      {Key? key, this.buttonText, this.buttonColour, this.onPressed, this.textColour})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: InkWell(
        onTap: onPressed,
        child: Container(
          height: 60,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: buttonColour,
            border: Border.all(width: 1, color: Colors.black),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
              child: Text(
            buttonText!,
            style: TextStyle(color: textColour, fontSize: 20,),
          )),
        ),
      ),
    );
  }
}
