import 'package:ecommerce_b2b/modules/logistics/packing/packing_session.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/common/ids/packing_session_id.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PackingSession', () {
    // Deve criar uma sessão de empacotamento corretamente.
    test('should create packing session', () {
      const id = PackingSessionId('ps1');
      final session = PackingSession(id: id);

      expect(session.id, id);
    });
  });
}
