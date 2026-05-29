import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'ci workflow runs pub get analyze and test without secret echo commands',
    () {
      final workflow = File('.github/workflows/ci.yml').readAsStringSync();

      expect(workflow, contains('flutter pub get'));
      expect(workflow, contains('flutter analyze'));
      expect(workflow, contains('flutter test'));
      expect(workflow.toLowerCase(), isNot(contains('echo supabase_anon_key')));
    },
  );
}
