import 'dart:async';
import 'package:flutter/material.dart';

import '../../services/nfc/nfc_service.dart';

class NfcTestPage extends StatefulWidget {
  const NfcTestPage({super.key});

  @override
  State<NfcTestPage> createState() => _NfcTestPageState();
}

class _NfcTestPageState extends State<NfcTestPage> {
  final _nfc = NfcService();
  final _log = <String>[];
  bool _supportNfc = false;
  bool _nfcEnabled = false;
  bool _reverseBytes = false;
  bool _isReading = false;
  StreamSubscription<Map<String, dynamic>>? _subscription;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    final support = await _nfc.supportNfc();
    final enabled = support ? await _nfc.isEnabled() : false;
    setState(() {
      _supportNfc = support;
      _nfcEnabled = enabled;
    });
    _append('NFC supported: $support, enabled: $enabled');

    if (support && enabled) {
      _startReading();
    } else {
      _append('Cannot start — NFC not available');
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  void _append(String line) {
    final now = DateTime.now();
    final ts = '${now.hour.toString().padLeft(2, '0')}'
        ':${now.minute.toString().padLeft(2, '0')}'
        ':${now.second.toString().padLeft(2, '0')}';
    setState(() => _log.insert(0, '[$ts] $line'));
  }

  void _startReading() {
    _subscription = _nfc.tagStream.listen(
      (tag) {
        final hex = tag['tagId'] as String;
        final display = _reverseBytes ? NfcService.reverseHex(hex) : hex;
        final decimal = NfcService.hexToDecimal(display);
        _append('Tag: $display (decimal: $decimal)');
      },
      onError: (error) => _append('Stream error: $error'),
      onDone: () => _append('Stream closed'),
    );
    setState(() => _isReading = true);
    _append('NFC reader mode enabled');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('NFC Test')),
      body: Column(
        children: [
          _buildStatusBar(),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: _log.length,
              itemBuilder: (_, i) => Text(
                _log[i],
                style: const TextStyle(fontFamily: 'monospace', fontSize: 11),
              ),
            ),
          ),
          const Divider(height: 1),
          _buildControls(),
        ],
      ),
    );
  }

  Widget _buildStatusBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Theme.of(context).colorScheme.surfaceContainerLowest,
      child: Row(
        children: [
          Icon(
            Icons.nfc,
            size: 20,
            color: _nfcEnabled ? Colors.green : Colors.red,
          ),
          const SizedBox(width: 8),
          Text(
            _supportNfc
                ? (_nfcEnabled ? 'NFC Ready' : 'NFC Disabled')
                : 'No NFC Hardware',
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          const Spacer(),
          if (_isReading)
            const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
        ],
      ),
    );
  }

  Widget _buildControls() {
    return Container(
      padding: const EdgeInsets.all(12),
      color: Theme.of(context).colorScheme.surfaceContainerLowest,
      child: SafeArea(
        child: Row(
          children: [
            FilterChip(
              label: const Text('Reverse byte order'),
              selected: _reverseBytes,
              onSelected: (v) => setState(() => _reverseBytes = v),
            ),
            const Spacer(),
            TextButton.icon(
              icon: const Icon(Icons.clear_all, size: 16),
              label: const Text('Clear log'),
              onPressed: () => setState(() => _log.clear()),
            ),
          ],
        ),
      ),
    );
  }
}
