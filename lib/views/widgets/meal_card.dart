import 'package:agc_canteen/services/database/app_database.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controllers/providers.dart';

final _menuTypeNameMapProvider = FutureProvider<Map<String, String>>((ref) async {
  final db = ref.watch(databaseProvider);
  final types = await db.getAllMenuTypes();
  return {for (final t in types) t.id: t.name};
});

class MealCard extends ConsumerWidget {
  final Meal meal;
  final bool isSelected;
  final VoidCallback onTap;

  const MealCard({
    required this.meal,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final menuTypes = ref.watch(_menuTypeNameMapProvider).asData?.value ?? {};
    return Card(
      elevation: isSelected ? 4 : 1,
      shadowColor: Theme.of(context).colorScheme.primary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isSelected
              ? Theme.of(context).colorScheme.primary
              : Colors.transparent,
          width: 2,
        ),
      ),
      color: Theme.of(context).colorScheme.surface,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: Stack(
            alignment: AlignmentGeometry.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [                  const SizedBox(height: 10),

                  _MealImage(photoUrl: meal.photoUrl),
                  const SizedBox(height: 10),
          
                  Text(
                    meal.name,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
          
              Positioned(
                top: 3,
                left: 5,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.primary.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    menuTypes[meal.menuTypeId] ?? meal.mealType,
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MealImage extends StatelessWidget {
  final String? photoUrl;
  const _MealImage({this.photoUrl});

  @override
  Widget build(BuildContext context) {
    if (photoUrl == null || photoUrl!.isEmpty) {
      return Image.asset('assets/app_logo.png', height: 80, width: 80);
    }
    return CachedNetworkImage(
      imageUrl: photoUrl!,
      height: 80,
      width: 100,
      
      imageBuilder: (context, imageProvider) =>
          Image(image: imageProvider, height: 80,width: 80,fit: BoxFit.cover,),
      fit: BoxFit.cover,
      placeholder: (context, url) => const SizedBox(
        height: 50,
        child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
      ),
      errorWidget: (context, url, error) =>
          Image.asset('assets/app_logo.png', height: 80, width: 80),
    );
  }
}