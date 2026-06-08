import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart' as enc;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class EncryptionService {
  enc.Key? _key;

  EncryptionService();

  Future<String> _encrypt(String plainText) async {
    await _ensureReady();
    final iv = enc.IV.fromSecureRandom(16);
    final encrypter = enc.Encrypter(
      enc.AES(_key!, mode: enc.AESMode.cbc, padding: 'PKCS7'),
    );
    final encrypted = encrypter.encrypt(plainText, iv: iv);

    final combined = Uint8List(iv.bytes.length + encrypted.bytes.length)
      ..setRange(0, iv.bytes.length, iv.bytes)
      ..setRange(
        iv.bytes.length,
        iv.bytes.length + encrypted.bytes.length,
        encrypted.bytes,
      );

    return base64.encode(combined);
  }

  Future<String> _decrypt(String base64CipherText) async {
    await _ensureReady();
    final combined = base64.decode(base64CipherText);

    final iv = enc.IV(Uint8List.fromList(combined.sublist(0, 16)));
    final cipherBytes = enc.Encrypted(Uint8List.fromList(combined.sublist(16)));

    final encrypter = enc.Encrypter(
      enc.AES(_key!, mode: enc.AESMode.cbc, padding: 'PKCS7'),
    );
    return encrypter.decrypt(cipherBytes, iv: iv);
  }

  Future<String> encrypt(String plainText) => _encrypt(plainText);

  Future<String> decrypt(String base64CipherText) =>
      _decrypt(base64CipherText);

  // ─── Private ─────────────────────────────────────────────────

  enc.Key _deriveKey(String raw) {
    final hash = sha256.convert(utf8.encode(raw));
    return enc.Key(Uint8List.fromList(hash.bytes));
  }

  Future<void> _ensureReady() async {
    if (_key != null) return;
    final secret = dotenv.env['SECREY_KEY'];
    if (secret == null || secret.isEmpty) {
      throw StateError('SECREY_KEY is not set in .env.');
    }
    _key = _deriveKey(secret);
  }
}
