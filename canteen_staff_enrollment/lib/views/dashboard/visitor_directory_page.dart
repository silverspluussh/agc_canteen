import 'package:canteen_staff_enrollment/models/visitor.model.dart';
import 'package:canteen_staff_enrollment/views/app_buttons.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../controllers/visitor_controller.dart';
import '../../core/theme/app_colors.dart';
import 'visitor_biodata_page.dart';

class VisitorDirectoryPage extends ConsumerWidget {
  const VisitorDirectoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final visitorAsync = ref.watch(filteredVisitorListProvider);
    final searchQuery = ref.watch(visitorQueryProvider);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: (val) =>
                        ref.read(visitorQueryProvider.notifier).state = val,
                    decoration: InputDecoration(
                      hintText: 'Search visitors by name...',
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: searchQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () =>
                                  ref.read(visitorQueryProvider.notifier).state = '',
                            )
                          : null,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  ref.invalidate(visitorListProvider);
                  await ref.read(visitorListProvider.future);
                },
                child: visitorAsync.when(
                  data: (visitorList) {
                    if (visitorList.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.person_outline,
                              size: 64,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withValues(alpha: 0.3),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'No visitors found',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      );
                    }

                    return ListView.separated(
                      itemCount: visitorList.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final visitor = visitorList[index];
                        final biodata = visitor.bioData ?? [];
                        final isEnrolled = biodata.isNotEmpty;

                        return Card(
                          margin: EdgeInsets.zero,
                          child: InkWell(
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                                ),
                                builder: (_) => _VisitorActionSheet(
                                  visitor: visitor,
                                  isEnrolled: isEnrolled,
                                ),
                              );
                            },
                            borderRadius: BorderRadius.circular(12),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 24,
                                    backgroundColor: Theme.of(context)
                                        .colorScheme
                                        .primary
                                        .withValues(alpha: 0.1),
                                    child: Text(
                                      visitor.name.isNotEmpty ? visitor.name[0].toUpperCase() : '?',
                                      style: TextStyle(
                                        color: Theme.of(context).colorScheme.primary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          visitor.name,
                                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                        ),
                                        if (visitor.company != null) ...[
                                          const SizedBox(height: 4),
                                          Text(
                                            visitor.company!,
                                            style: TextStyle(
                                              fontSize: 13,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onSurface
                                                  .withValues(alpha: 0.6),
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: isEnrolled
                                              ? const Color(0xFF2E7D32).withValues(alpha: 0.1)
                                              : const Color(0xFFE65100).withValues(alpha: 0.1),
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              isEnrolled ? Icons.check_circle : Icons.pending,
                                              size: 14,
                                              color: isEnrolled
                                                  ? const Color(0xFF2E7D32)
                                                  : const Color(0xFFE65100),
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              isEnrolled ? 'Enrolled' : 'Pending',
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                                color: isEnrolled
                                                    ? const Color(0xFF2E7D32)
                                                    : const Color(0xFFE65100),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      if (isEnrolled) ...[
                                        const SizedBox(height: 4),
                                        Text(
                                          '${biodata.length} Finger(s)',
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurface
                                                .withValues(alpha: 0.6),
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                  const SizedBox(width: 8),
                                  Icon(
                                    Icons.chevron_right,
                                    size: 20,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface
                                        .withValues(alpha: 0.35),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (err, stack) => Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline, size: 48, color: AppColors.error),
                        const SizedBox(height: 16),
                        Text('Failed to load visitors: $err'),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => ref.refresh(visitorListProvider),
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _VisitorActionSheet extends StatelessWidget {
  final Visitor visitor;
  final bool isEnrolled;

  const _VisitorActionSheet({
    required this.visitor,
    required this.isEnrolled,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            spacing: 15,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                visitor.name,
                style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: isEnrolled
                      ? const Color(0xFF2E7D32).withValues(alpha: 0.1)
                      : const Color(0xFFE65100).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isEnrolled ? Icons.check_circle : Icons.pending,
                      size: 16,
                      color: isEnrolled
                          ? const Color(0xFF2E7D32)
                          : const Color(0xFFE65100),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      isEnrolled ? 'Enrolled' : 'Not Enrolled',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: isEnrolled
                            ? const Color(0xFF2E7D32)
                            : const Color(0xFFE65100),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: OutlineButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => VisitorBiodataPage(visitor: visitor),
                  ),
                );
              },
              prefixChild: const Icon(Icons.person_outline, size: 18, color: AppColors.gold600),
              label: const Text(
                'View Visitor Biodata',
                style: TextStyle(color: AppColors.gold600, fontWeight: FontWeight.w500, fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
