import 'package:ecommerce_b2b/modules/shared_kernel/base/base_value_object.dart';
import 'package:flutter/foundation.dart';

@immutable
class TrackingCode extends ValueObject {
  final String value;

  const TrackingCode(this.value);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TrackingCode &&
          runtimeType == other.runtimeType &&
          value == other.value;

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => value;
}
