import 'package:flutter/material.dart';

class LoadingContainer extends StatefulWidget {
  const LoadingContainer({Key? key}) : super(key: key);

  @override
  State<LoadingContainer> createState() => _LoadingContainerState();
}

class _LoadingContainerState extends State<LoadingContainer> {
  static const List<Color> colorList = [
    Color.fromRGBO(2, 230, 208, .2),
    Color.fromRGBO(0, 150, 136, .6),
  ];

  int index = 0;
  Color bottomColor = colorList[0];
  Color topColor = colorList[1];

  @override
  Widget build(BuildContext context) {
    if (index == 0) {
      Future.delayed(const Duration(milliseconds: 10), () {
        setState(() {
          bottomColor = colorList[1];
        });
      });
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(5.0),
      child: AnimatedContainer(
        duration: Duration(seconds: 2),
        curve: Curves.easeInOut,
        onEnd: () {
          setState(() {
            index = index + 1;
            bottomColor = colorList[index % colorList.length];
            topColor = colorList[(index + 1) % colorList.length];
          });
        },
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
            colors: [bottomColor, topColor],
          ),
        ),
      ),
    );
  }
}
