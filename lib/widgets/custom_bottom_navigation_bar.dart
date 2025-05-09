import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vysenet/services/auth_shared_preference_service.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  final int index;
  final Color firstColor;
  final Color secondColor;
  final Color thirdColor;
  final Color? backgroundColor;
  final LinearGradient? linearGradient;
  final BorderRadius? borderRadius;
  final MainAxisAlignment mainAxisAlignment;
  final void Function(int)? onPressed;

  const CustomBottomNavigationBar({
    super.key,
    required this.index,
    this.firstColor = Colors.white,
    this.secondColor = Colors.white,
    this.thirdColor = Colors.white,
    this.backgroundColor = Colors.grey,
    this.linearGradient,
    this.borderRadius,
    this.mainAxisAlignment = MainAxisAlignment.spaceEvenly,
    required this.onPressed,
  });

  @override
  State<CustomBottomNavigationBar> createState() =>
      CustomBottomNavigationBarState();
}

class CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  late final BorderRadius borderRadius;
  late final bool hasLinearGradient;

  bool isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    borderRadius =
        widget.borderRadius ??
        const BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        );
    hasLinearGradient = widget.linearGradient != null;
    _loadLoginState();
  }

  Future<void> _loadLoginState() async {
    final bool loggedInState = await AuthSharedPreferences.loadLoggedInState();
    setState(() {
      isLoggedIn = loggedInState;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: 90,
      padding: EdgeInsets.only(bottom: 5),
      decoration: BoxDecoration(
        color: Color.fromRGBO(248, 248, 255, 1),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 0),
            child: Row(
              mainAxisAlignment: widget.mainAxisAlignment,
              children: [
                // Botão 0 - Adicionar
                GestureDetector(
                  onTap: () {
                    if (widget.index == 0) {
                      return;
                    }

                    widget.onPressed?.call(0);
                  },
                  child: SvgPicture.asset(
                    widget.index == 0
                        ? "assets/icon/plus_active.svg"
                        : "assets/icon/plus_off.svg",
                    width: 40,
                  ),
                ),
                // Botão 1 - Scan
                GestureDetector(
                  onTap: () {
                    if (widget.index == 1) {
                      return;
                    }
                    widget.onPressed?.call(1);
                  },
                  child: SvgPicture.asset(
                    widget.index == 1
                        ? "assets/icon/scan_active.svg"
                        : "assets/icon/scan_off.svg",
                    width: 40,
                  ),
                ),
                // Botão 2 - Perfil
                GestureDetector(
                  onTap: () {
                    if (widget.index == 2) {
                      return;
                    }
                    widget.onPressed?.call(2);
                  },
                  child: SvgPicture.asset(
                    widget.index == 2
                        ? "assets/icon/user_active.svg"
                        : "assets/icon/user_off.svg",
                    width: 40,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
