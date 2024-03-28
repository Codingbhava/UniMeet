import 'package:flutter/material.dart';

const myBackground = Color(0xFF050816);
const text = Color(0xFFAABBC3);
const primary = Color(0xFF1E88E5);
const secondary = Color(0xFF64B5F6);
const accent = Color(0xFFFBC02D);
const userBackground = Color(0xFF191D28);
const chatBackground = Color(0xFF002B36);
const neonBlue = Colors.blue;
const neonPurple = Colors.purple;
const grey = Color.fromARGB(255, 37, 37, 37);
const common = Color(0xFFAABBC3);
const glow = Color.fromARGB(255, 0, 174, 255);
bool isDarkMode(context) => Theme.of(context).brightness == Brightness.dark;
double Radius = 5.0;
double findWidth(context) => MediaQuery.of(context).size.width;
double findHeight(context) => MediaQuery.of(context).size.height;
