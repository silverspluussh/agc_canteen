import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../services/pos/pos_card_service.dart';

class CardTestPage extends StatefulWidget {
  const CardTestPage({super.key});

  @override
  State<CardTestPage> createState() => _CardTestPageState();
}

class _CardTestPageState extends State<CardTestPage> {
  final _card = PosCardService();
  final _log = <String>[];
  final _dataCtrl = TextEditingController(text: '00112233445566778899AABBCCDDEEFF');
  final _offsetCtrl = TextEditingController(text: '0');
  final _lengthCtrl = TextEditingController(text: '16');
  final _fileIdCtrl = TextEditingController(text: 'DF01');
  bool _busy = false;

  @override
  void dispose() {
    _dataCtrl.dispose();
    _offsetCtrl.dispose();
    _lengthCtrl.dispose();
    _fileIdCtrl.dispose();
    super.dispose();
  }

  void _append(String line) {
    final now = DateTime.now();
    final ts = '${now.hour.toString().padLeft(2, '0')}'
        ':${now.minute.toString().padLeft(2, '0')}'
        ':${now.second.toString().padLeft(2, '0')}';
    setState(() => _log.insert(0, '[$ts] $line'));
  }

  Uint8List? _parseHex(String text) {
    try {
      final clean = text.replaceAll(RegExp(r'\s'), '');
      if (clean.isEmpty || clean.length % 2 != 0) return null;
      return Uint8List.fromList(
        List.generate(clean.length ~/ 2, (i) => int.parse(clean.substring(i * 2, i * 2 + 2), radix: 16)),
      );
    } catch (_) {
      return null;
    }
  }

  String _toHex(Uint8List? bytes) {
    if (bytes == null) return '(null)';
    return bytes.map((b) => b.toRadixString(16).padLeft(2, '0').toUpperCase()).join(' ');
  }

  int _parseInt(String s) => int.tryParse(s) ?? 0;

  Future<void> _run(String label, Future<Object?> Function() op) async {
    setState(() => _busy = true);
    try {
      final result = await op();
      if (result is Uint8List?) {
        _append('$label → ${_toHex(result)}');
      } else if (result is int) {
        _append('$label → code=$result');
      } else {
        _append('$label → $result');
      }
    } on PlatformException catch (e) {
      _append('$label ERROR: ${e.message}');
    } catch (e) {
      _append('$label ERROR: $e');
    } finally {
      setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Card Test')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: _log.length,
              itemBuilder: (_, i) => Text(
                _log[i],
                style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
              ),
            ),
          ),
          const Divider(height: 1),
          _buildControls(),
        ],
      ),
    );
  }

  Widget _buildControls() {
    return Container(
      padding: const EdgeInsets.all(12),
      color: Theme.of(context).colorScheme.surfaceContainerLowest,
      child: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              controller: _fileIdCtrl,
              decoration: const InputDecoration(
                labelText: 'File ID (hex)',
                border: OutlineInputBorder(),
                isDense: true,
              ),
            ),
            const SizedBox(height: 4),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: _busy
                    ? null
                    : () {
                        final bytes = _parseHex(_fileIdCtrl.text);
                        if (bytes == null) {
                          _append('Invalid file ID hex');
                          return;
                        }
                        _run('SELECT ${_fileIdCtrl.text}', () => _card.selectFile(bytes));
                      },
                child: const Text('Select'),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                SizedBox(
                  width: 80,
                  child: TextField(
                    controller: _offsetCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Offset',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  width: 80,
                  child: TextField(
                    controller: _lengthCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Length',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: TextField(
                    controller: _dataCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Data (hex)',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                    maxLines: 2,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ActionChip(
                  avatar: const Icon(Icons.power_settings_new, size: 18),
                  label: const Text('Reset'),
                  onPressed: _busy
                      ? null
                      : () => _run('RESET', () => _card.icReset()),
                ),
                ActionChip(
                  avatar: const Icon(Icons.download, size: 18),
                  label: const Text('Read'),
                  onPressed: _busy
                      ? null
                      : () {
                          final off = _parseInt(_offsetCtrl.text);
                          final len = _parseInt(_lengthCtrl.text);
                          _run('READ offset=$off len=$len', () => _card.readBinary(off, len));
                        },
                ),
                ActionChip(
                  avatar: const Icon(Icons.upload, size: 18),
                  label: const Text('Write'),
                  onPressed: _busy
                      ? null
                      : () {
                          final data = _parseHex(_dataCtrl.text);
                          if (data == null) {
                            _append('Invalid data hex');
                            return;
                          }
                          final off = _parseInt(_offsetCtrl.text);
                          _run('WRITE offset=$off len=${data.length}', () => _card.updateBinary(off, data));
                        },
                ),
                ActionChip(
                  avatar: const Icon(Icons.delete_outline, size: 18),
                  label: const Text('Erase'),
                  onPressed: _busy
                      ? null
                      : () {
                          final off = _parseInt(_offsetCtrl.text);
                          final len = _parseInt(_lengthCtrl.text);
                          _run('ERASE offset=$off len=$len', () => _card.eraseData(off, len));
                        },
                ),
                ActionChip(
                  avatar: const Icon(Icons.credit_card, size: 18),
                  label: const Text('Swipe'),
                  onPressed: _busy
                      ? null
                      : () => _run('SWIPE', () => _card.swipeCard()),
                ),
              ],
            ),
            const SizedBox(height: 8),
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
