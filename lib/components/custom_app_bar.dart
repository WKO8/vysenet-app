import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final int index;
  final List<Widget>? actions;

  const CustomAppBar({
    Key? key,
    required this.title,
    required this.index,
    this.actions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomRight: index == 2 ? Radius.zero : Radius.circular(45),
          bottomLeft: index == 0 ? Radius.zero : Radius.circular(45),
        ),
      ),
      child: SafeArea(
        child: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: Row(
            mainAxisSize: MainAxisSize.min,
            //mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset("assets/icon/net_icon.svg", width: 36),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  color: Color.fromRGBO(68, 138, 181, 1),
                  fontWeight: FontWeight.bold,
                  fontSize: 32,
                ),
              ),
            ],
          ),
          actions: actions,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
