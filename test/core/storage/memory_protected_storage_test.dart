import 'package:bringly_app/core/storage/memory_protected_storage.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'memory storage supports write read delete missing-key and replacement',
    () async {
      final storage = MemoryProtectedStorage();

      expect(await storage.read(key: 'missing'), isNull);

      await storage.write(key: 'key', value: 'one');
      expect(await storage.read(key: 'key'), 'one');

      await storage.write(key: 'key', value: 'two');
      expect(await storage.read(key: 'key'), 'two');

      await storage.delete(key: 'key');
      expect(await storage.read(key: 'key'), isNull);
    },
  );
}
