// ignore_for_file: file_names

import 'package:flutter/material.dart';

class CustomButton extends StatefulWidget {
  
  final Widget content;
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  final Color? color;
  final Icon? icon;
  final VoidCallback? onPressed;
  final BuildContext scaffoldContext;

  const CustomButton._({
    // ignore: unused_element
    required this.content,
    this.width = 200,
    this.height = 80,
    this.color = Colors.blue,
    required this.onPressed,
    this.borderRadius,
    this.icon,
    required this.scaffoldContext,
  });

  factory CustomButton({
    required Widget content, 
    double? width,
    double? height,
    VoidCallback? onPressed,
    BorderRadius? borderRadius,
    Color? color,
    required BuildContext scaffoldContext,
  }) => 
    CustomButton._(
      content: content, 
      width: width,
      height: height,
      onPressed: onPressed,
      borderRadius: borderRadius,
      color: color,
      scaffoldContext: scaffoldContext,
    );

  factory CustomButton.icon({
    required Icon icon, 
    required Widget content, 
    double? width,
    double? height,
    VoidCallback? onPressed,
    BorderRadius? borderRadius,
    Color? color,
    required BuildContext scaffoldContext,
  }) => 
    CustomButton._(
      content: content,
      width: width,
      height: height,
      onPressed: onPressed,
      icon: icon,
      borderRadius: borderRadius,
      color: color,
      scaffoldContext: scaffoldContext,
    );

  @override
  State<CustomButton> createState() => _CustomButtonState();
}
 
class _CustomButtonState extends State<CustomButton> {
  late final BorderRadius borderRadius;
  late final bool isDisabled;
  double elevation = 2;


  @override
  void initState() {
    super.initState();
    borderRadius = widget.borderRadius ?? BorderRadius.circular(8);
    isDisabled = widget.onPressed == null;
  }
  
  @override
  Widget build(BuildContext context) {
    return Material(
      color: isDisabled ? Colors.grey[350] : widget.color,
      borderRadius: borderRadius,
      elevation: isDisabled ? 0 : elevation,
      child: InkWell(
        onTap: isDisabled
            ? null 
            : () {
                widget.onPressed?.call();
                elevation = 2;
                setState(() {});
        },
        onTapDown: (_) {
          elevation = 10;
          setState(() {});
        },
        onTapCancel: () {
          elevation = 2;
          setState(() {});
        },
        borderRadius: borderRadius,
        child: Container(
          width: widget.width,
          height: widget.height,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: borderRadius
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (widget.icon != null)...{
                Padding(
                  padding: const EdgeInsets.only(right: 5),
                  child: widget.icon!,
                )
              }, 
              widget.content,
            ],
          ),
        ),
      ),
    );
  }
}