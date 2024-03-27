import 'package:flutter/material.dart';
import 'package:unimeet/constants/data.dart';

class TextBtn extends StatelessWidget {
  final String imagePath, textBtn;
  final VoidCallback onPressed;
  final double horizontal;
  final bool isImg;
  final Color color;
  TextBtn(
      {super.key,
      required this.imagePath,
      required this.textBtn,
      required this.onPressed,
      this.isImg = true,
      this.color = myBackground,
      this.horizontal = 105});
  @override
  Widget build(BuildContext context) {
    return isImg
        ? Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [neonBlue, neonPurple]),
                borderRadius: BorderRadius.circular(Radius)),
            padding: EdgeInsets.symmetric(horizontal: 1, vertical: 0.5),
            child: TextButton.icon(
              onPressed: onPressed,
              icon: Image.asset(
                imagePath,
                width: 25,
              ),
              label: Text(
                textBtn,
                style: TextStyle(fontSize: 15, color: text),
              ),
              style: TextButton.styleFrom(
                padding:
                    EdgeInsets.symmetric(vertical: 10, horizontal: horizontal),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(Radius)),
                backgroundColor: userBackground,
              ),
            ),
          )
        : Container(
            padding: EdgeInsets.symmetric(horizontal: 5, vertical: 0.01),
            child: TextButton(
              onPressed: onPressed,
              child: Text(
                textBtn,
                style: TextStyle(fontSize: 15, color: text),
              ),
              style: TextButton.styleFrom(
                padding:
                    EdgeInsets.symmetric(vertical: 10, horizontal: horizontal),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(Radius)),
                backgroundColor: color,
              ),
            ),
          );
  }
}
