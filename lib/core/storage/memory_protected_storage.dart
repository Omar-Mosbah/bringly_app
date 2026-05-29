import 'package:bringly_app/core/storage/protected_storage.dart';

class MemoryProtectedStorage extends ProtectedStorage {
  MemoryProtectedStorage({Map<String, String>? seedValues})
    : _values = <String, String>{...?seedValues};

  final Map<String, String> _values;

  @override
  Future<void> delete({required String key}) async {
    _values.remove(key);
  }

  @override
  Future<String?> read({required String key}) async {
    return _values[key];
  }

  @override
  Future<void> write({required String key, required String value}) async {
    _values[key] = value;
  }
}
