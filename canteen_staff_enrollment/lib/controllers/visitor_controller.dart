import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../models/visitor.model.dart';
import '../repos/visitor_service.dart';
import 'injection_container.dart';

final visitorListProvider = FutureProvider<List<Visitor>>((ref) async {
  final service = getIt<VisitorService>();
  return await service.getAllVisitors();
});

final visitorQueryProvider = StateProvider<String>((ref) => '');

final filteredVisitorListProvider =
    Provider.autoDispose<AsyncValue<List<Visitor>>>((ref) {
  final visitorAsync = ref.watch(visitorListProvider);
  final query = ref.watch(visitorQueryProvider).trim().toLowerCase();

  return visitorAsync.whenData((list) {
    if (query.isEmpty) return list;
    return list
        .where((v) => v.name.toLowerCase().contains(query))
        .toList();
  });
});
