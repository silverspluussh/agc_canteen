import 'package:flutter/material.dart';

class VoucherCard extends StatelessWidget {
  final String orderCode;
  final String staffName;
  final String mealType;
  final String orderTime;

  const VoucherCard({super.key, 
    required this.orderCode,
    required this.staffName,
    required this.mealType,
    required this.orderTime,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final mealLabel =
        mealType[0].toUpperCase() + mealType.substring(1).replaceAll('_', ' ');
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'ASG CANTEEN',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(height: 4),
            Text(
              orderCode,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: cs.primary,
              ),
            ),
            const Divider(height: 10),
            _row(context, 'Time:', orderTime),
            _row(context, 'Staff:', staffName),
            _row(context, 'Meal:', mealLabel),
          ],
        ),
      ),
    );
  }

  Widget _row(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 60,
            child: Text(
              '$label:',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}