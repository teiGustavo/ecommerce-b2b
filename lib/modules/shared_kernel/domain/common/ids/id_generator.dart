import 'package:uuid/uuid.dart';

/// Helper to generate UUID v7 identifiers for the domain.
String generateId() {
  return const Uuid().v7();
}

