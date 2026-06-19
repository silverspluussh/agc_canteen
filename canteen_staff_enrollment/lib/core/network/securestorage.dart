import 'package:flutter_secure_storage/flutter_secure_storage.dart';

AndroidOptions _getAndroidOptions() => AndroidOptions();

const String _expirationKey = 'token_expiration';
const String _kEncryptionKeyStorageKey = 'encryption_key';

IOSOptions _getIosOptions() => const IOSOptions();

class SecureStorage {
  final storage = FlutterSecureStorage(
    iOptions: _getIosOptions(),
    aOptions: _getAndroidOptions(),
  );

  Future writeSecureData(String key, String value) async {
    await storage.write(key: key, value: value);
  }

  Future writeBioSecret(String secret) async {
    await storage.write(key: _kEncryptionKeyStorageKey, value: secret);
  }

  Future writeSecureToken(String value) async {
    final expirationTime = DateTime.now().add(const Duration(hours: 12));

    await storage.write(key: 'access_token', value: value);
    await storage.write(
      key: _expirationKey,
      value: expirationTime.toIso8601String(),
    );
  }

  Future<String?> readSecureData(String key) async {
    final expirationTime = await storage.read(key: _expirationKey);
    if (expirationTime == null) return null;
    final expirationDateTime = DateTime.parse(expirationTime);
    if (expirationDateTime.isBefore(DateTime.now())) return null;
    return await storage.read(key: key) ?? 'No data found!';
  }

  Future<void> deleteSecureData(String key) async =>
      await storage.delete(key: key);

  Future<void> clearSecureData() async => await storage.deleteAll();

  //save email and add expiry of 12 hours
  Future<void> writeSecureEmail(String email) async {
    final expirationTime = DateTime.now().add(const Duration(hours: 12));
    await storage.write(key: 'email', value: email);
    await storage.write(
      key: 'email_expiration',
      value: expirationTime.toIso8601String(),
    );
  }

  Future<String?> readSecureEmail() async {
    final expirationTime = await storage.read(key: 'email_expiration');
    if (expirationTime == null) return null;
    final expirationDateTime = DateTime.parse(expirationTime);
    if (expirationDateTime.isBefore(DateTime.now())) return null;
    return await storage.read(key: 'email') ?? 'No email found!';
  }

  Future<void> deleteSecureEmail() async => await storage.delete(key: 'email');

  Future<void> clearSecureEmail() async => await storage.deleteAll();

  Future<void> writeSecurePhone(String phone) async {
    final expirationTime = DateTime.now().add(const Duration(hours: 12));
    await storage.write(key: 'phone', value: phone);
    await storage.write(
      key: 'phone_expiration',
      value: expirationTime.toIso8601String(),
    );
  }

  Future<String?> readSecurePhone() async {
    final expirationTime = await storage.read(key: 'phone_expiration');
    if (expirationTime == null) return null;
    final expirationDateTime = DateTime.parse(expirationTime);
    if (expirationDateTime.isBefore(DateTime.now())) return null;
    return await storage.read(key: 'phone') ?? 'No phone found!';
  }

  Future<void> deleteSecurePhone() async => await storage.delete(key: 'phone');

  Future<void> clearSecurePhone() async => await storage.deleteAll();

  Future<void> writeAdminCredentials(String email, String passwordHash) async {
    await storage.write(key: 'admin_email', value: email);
    await storage.write(key: 'admin_pass_hash', value: passwordHash);
  }

  Future<String?> readAdminEmail() async {
    return await storage.read(key: 'admin_email');
  }

  Future<String?> readAdminPassHash() async {
    return await storage.read(key: 'admin_pass_hash');
  }

  Future<void> clearAdminCredentials() async {
    await storage.delete(key: 'admin_email');
    await storage.delete(key: 'admin_pass_hash');
  }
}
