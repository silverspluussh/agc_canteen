import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../models/nfc_card.model.dart';
import '../repos/nfc_card_service.dart';
import 'injection_container.dart';

final nfcCardListProvider = FutureProvider<List<NfcCard>>((ref) async {
  final service = getIt<NfcCardService>();
  return await service.getAllCards();
});

final nfcCardSearchQueryProvider = StateProvider<String>((ref) => '');

final nfcCardStatusFilterProvider = StateProvider<String?>((ref) => null);

final nfcCardTypeFilterProvider = StateProvider<String?>((ref) => null);

final filteredNfcCardListProvider =
    Provider.autoDispose<AsyncValue<List<NfcCard>>>((ref) {
  final cardsAsync = ref.watch(nfcCardListProvider);
  final query = ref.watch(nfcCardSearchQueryProvider).trim().toLowerCase();
  final statusFilter = ref.watch(nfcCardStatusFilterProvider);
  final typeFilter = ref.watch(nfcCardTypeFilterProvider);

  return cardsAsync.whenData((list) {
    var result = list;
    if (query.isNotEmpty) {
      result = result.where((card) {
        final code = card.code?.toLowerCase() ?? '';
        final reversedCode = card.reversedCode?.toLowerCase() ?? '';
        return code.contains(query) || reversedCode.contains(query);
      }).toList();
    }
    if (statusFilter != null) {
      result = result.where((card) => card.status == statusFilter).toList();
    }
    if (typeFilter != null) {
      result =
          result.where((card) => card.assignedToType == typeFilter).toList();
    }
    return result;
  });
});
