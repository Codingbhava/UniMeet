import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? title;
  final VoidCallback? BackBtn;
  const CustomAppBar({
    super.key,
    this.title,
    this.BackBtn,
  });
  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: false,
      automaticallyImplyLeading: false,
      leading:
          IconButton(onPressed: BackBtn, icon: Icon(Icons.arrow_back_ios_new)),
      title: title,
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(50);
}
