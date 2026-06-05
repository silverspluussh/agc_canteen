
import 'package:agc_canteen/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({super.key,
    required this.onPressed,
    this.label,
    this.prefixChild,
    this.color,
    this.width,
    this.height

  });
  final double? width ;
  final double? height ;
  final  void Function()? onPressed ;
  final Widget? label;
  final Widget? prefixChild;
  final Color? color;


  @override
  Widget build(BuildContext context) {
    return Container(
            width: width ?? double.infinity,
      height: height?? 55,
      decoration: BoxDecoration(
        color: color ?? Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: AppColors.gold800,
            blurStyle: BlurStyle.solid,
            offset: const Offset(0,7),
            blurRadius: 4,
    
          ),
        ]
      ),
      child: MaterialButton(
              onPressed: onPressed != null
                  ? () {
                      HapticFeedback.lightImpact();
                      onPressed!();
                    }
                  : null,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (prefixChild != null) ...[
              prefixChild!,
              const SizedBox(width: 8),
            ],
            if (label != null)
              label ??  const SizedBox(),
          ],
        ),
      ),
    );
  }
}






class DestructiveButton extends StatelessWidget {
  const DestructiveButton({super.key,
    required this.onPressed,
    this.label,
    this.prefixChild,
    this.color,
    this.width
  });
  final double? width ;
  final double height = 48;
  final void Function() onPressed ;
  final Widget? label;
  final Widget? prefixChild;
  final Color? color;


  @override
  Widget build(BuildContext context) {
    return Container(
            width: width ?? double.infinity,
      height: height,
      decoration: BoxDecoration(
        color: color ?? AppColors.error,
        borderRadius: BorderRadius.circular(30),
       
      ),
      child: MaterialButton(
              onPressed: () {
                HapticFeedback.lightImpact();
                onPressed();
              },
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (prefixChild != null) ...[
              prefixChild!,
              const SizedBox(width: 8),
            ],
            if (label != null)
              label ??  const SizedBox(),
          ],
        ),
      ),
    );
  }
}




class OutlineButton extends StatelessWidget {
  const OutlineButton({super.key,
    required this.onPressed,
    this.label,
    this.prefixChild,
    this.color,
  });
  final double? width = double.infinity;
  final double height = 48;
  final void Function() onPressed ;
  final Widget? label;
  final Widget? prefixChild;
  final Color? color;


  @override
  Widget build(BuildContext context) {
    return Container(
            width: width,
      height: height,
      decoration: BoxDecoration(
        color: color ?? Colors.transparent,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Theme.of(context).colorScheme.primary, width: 2),
       
      ),
      child: MaterialButton(
              onPressed: () {
                HapticFeedback.lightImpact();
                onPressed();
              },
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (prefixChild != null) ...[
              prefixChild!,
              const SizedBox(width: 8),
            ],
            if (label != null)
              label ??  const SizedBox(),
          ],
        ),
      ),
    );
  }
}