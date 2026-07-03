import 'package:agc_canteen/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class GroupCountSelector extends StatelessWidget {
  final int count;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const GroupCountSelector({super.key, 
    required this.count,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("Select total vouchers",style: Theme.of(context).textTheme.titleLarge),
          SizedBox(height: 15),
          
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Decrement
              Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: onDecrement,
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.gold700),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.remove_rounded,
                      size: 28,
                      color: count > 1 ? Colors.deepOrange : Colors.grey.shade800,
                    ),
                  ),
                ),
              ),
          
              const SizedBox(width: 15),
          
              // Count display
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                transitionBuilder: (child, anim) =>
                    ScaleTransition(scale: anim, child: child),
                child: Container(
                  key: ValueKey(count),
                  width: 72,
                  height: 50,
                 
                  alignment: Alignment.center,
                  child: Text(
                    '$count',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: AppColors.gold700,
                    ),
                  ),
                ),
              ),
          
              const SizedBox(width: 15),
          
              // Increment
              Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: onIncrement,
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.gold700),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.add_rounded,
                      size: 28,
                      color: Colors.deepOrange,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
