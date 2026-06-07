import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart' as enc;

import '../core/di/securestorage.dart';

/// Key name stored in secure storage.
const _kEncryptionKeyStorageKey = 'encryption_key';

class EncryptionService {
  final SecureStorage _storage;

  enc.Key? _key;

  EncryptionService({required SecureStorage storage}) : _storage = storage;

  Future<void> init() async {
    final raw = await _storage.storage.read(key: _kEncryptionKeyStorageKey);
    if (raw == null || raw.isEmpty) {
      throw StateError(
        'EncryptionService: no encryption key found in secure storage '
        '(key: "$_kEncryptionKeyStorageKey"). '
        'Store one with SecureStorage before initialising this service.',
      );
    }
    _key = _deriveKey(raw);
  }

  Future<void> storeKey(String keyValue) async {
    await _storage.storage.write(
      key: _kEncryptionKeyStorageKey,
      value: keyValue,
    );
    _key = _deriveKey(keyValue);
  }

  String encrypt(String plainText) {
    _assertReady();
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

  /// Decrypts a Base64 string produced by [encrypt].
  String decrypt(String base64CipherText) {
    _assertReady();
    final combined = base64.decode(base64CipherText);

    final iv = enc.IV(Uint8List.fromList(combined.sublist(0, 16)));
    final cipherBytes = enc.Encrypted(Uint8List.fromList(combined.sublist(16)));

    final encrypter = enc.Encrypter(
      enc.AES(_key!, mode: enc.AESMode.cbc, padding: 'PKCS7'),
    );
    return encrypter.decrypt(cipherBytes, iv: iv);
  }

  // ─── Private ─────────────────────────────────────────────────

  /// Derives a 32-byte AES-256 key by hashing [raw] with SHA-256.
  enc.Key _deriveKey(String raw) {
    final hash = sha256.convert(utf8.encode(raw));
    return enc.Key(Uint8List.fromList(hash.bytes));
  }

  void _assertReady() {
    if (_key == null) {
      throw StateError(
        'EncryptionService not initialised. Call init() before encrypt/decrypt.',
      );
    }
  }
}
