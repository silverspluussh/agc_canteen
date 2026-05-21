import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'providers.dart';
import '../services/mock/mock_services.dart';

final mockFingerprintDeviceProvider =
    Provider<MockPosFingerprintService>((ref) => MockPosFingerprintService());

/// Add this to your [ProviderScope.overrides] to switch the POS to mock
/// fingerprint authentication.
///
/// ```dart
/// void main() async {
///   // ... init DB ...
///   await seedMockData(database);
///
///   runApp(
///     ProviderScope(
///       overrides: [...mockFingerprintOverrides],
///       child: const MyApp(),
///     ),
///   );
/// }
/// ```
final mockFingerprintOverrides = [
  fingerprintDeviceProvider.overrideWith((ref) {
    final mock = ref.watch(mockFingerprintDeviceProvider);
    return mock;
  }),
];

/// A compact staff-picker widget for mock mode. Place it on the
/// [StaffAuthPage] or any debug panel to select which mock staff member
/// "scans" on the next [MockPosFingerprintService.capture] call.
class MockStaffSelector extends ConsumerWidget {
  const MockStaffSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mock = ref.watch(mockFingerprintDeviceProvider);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.orange.shade50,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                const Icon(Icons.fingerprint, size: 18, color: Colors.orange),
                const SizedBox(width: 6),
                const Text('Mock Staff',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              ],
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 6,
              runSpacing: 4,
              children: List.generate(kMockStaff.length, (i) {
                final s = kMockStaff[i];
                final isSelected = mock.currentStaff.id == s.id;
                return ChoiceChip(
                  label: Text(s.displayName, style: const TextStyle(fontSize: 12)),
                  selected: isSelected,
                  onSelected: (_) => mock.selectStaff(i),
                  visualDensity: VisualDensity.compact,
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
