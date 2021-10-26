import 'package:flutter_secure_storage/flutter_secure_storage.dart';

FlutterSecureStorage storage = const FlutterSecureStorage();

Future<String?> getData(String key) async {
  return await storage.read(key: key);
}

addData(String key, String value) async {
  await storage.write(key: key, value: value);
}

deleteData(String key) async {
  await storage.delete(key: key);
}

deleteAllData() async {
  await storage.deleteAll();
}

Future<Map<String, String>> getAllData() async {
  return await storage.readAll();
}

//TODO: Add try catch
