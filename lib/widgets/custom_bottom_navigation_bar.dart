import 'package:flutter/material.dart';
import 'package:vysenet/services/auth_shared_preference_service.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  final Icon firstIcon;
  final Icon secondIcon;
  final Icon thirdIcon;
  final Text firstText;
  final Text secondText;
  final Text thirdText;
  final Color firstColor;
  final Color secondColor;
  final Color thirdColor;
  final Color? backgroundColor;
  final LinearGradient? linearGradient;
  final BorderRadius? borderRadius;
  final MainAxisAlignment mainAxisAlignment;
  final void Function(int)? onPressed; // ⬅️ ALTERADO para aceitar índice

  const CustomBottomNavigationBar({
    super.key,
    required this.firstIcon,
    required this.secondIcon,
    required this.thirdIcon,
    this.firstText = const Text(""),
    this.secondText = const Text(""),
    this.thirdText = const Text(""),
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
    borderRadius = widget.borderRadius ??
        const BorderRadius.only(
            topLeft: Radius.circular(15), topRight: Radius.circular(15));
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
      height: 70,
      decoration: hasLinearGradient
          ? BoxDecoration(
              gradient: widget.linearGradient, borderRadius: borderRadius)
          : BoxDecoration(color: widget.backgroundColor),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              mainAxisAlignment: widget.mainAxisAlignment,
              children: [
                // Botão 0 - Adicionar
                GestureDetector(
                  onTap: () => widget.onPressed?.call(0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(widget.firstIcon.icon, color: widget.firstColor),
                      Text(widget.firstText.data ?? "",
                          style: widget.firstText.style),
                    ],
                  ),
                ),
                // Botão 1 - Scan
                GestureDetector(
                  onTap: () => widget.onPressed?.call(1),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(widget.secondIcon.icon, color: widget.secondColor),
                      Text(widget.secondText.data ?? "",
                          style: widget.secondText.style),
                    ],
                  ),
                ),
                // Botão 2 - Perfil
                GestureDetector(
                  onTap: () => widget.onPressed?.call(2),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(widget.thirdIcon.icon, color: widget.thirdColor),
                      Text(widget.thirdText.data ?? "",
                          style: widget.thirdText.style),
                    ],
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
