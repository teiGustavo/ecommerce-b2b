import 'package:ecommerce_b2b/modules/shared_kernel/base/base_value_object.dart';
import 'package:ecommerce_b2b/modules/logistics/domain/enums/tracking_status.dart';
import 'package:flutter/foundation.dart';

@immutable
class TrackingEvent extends ValueObject {
  final TrackingStatus status;
  final DateTime occurredAt;
  final String? location;

  const TrackingEvent({
    required this.status,
    required this.occurredAt,
    this.location,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TrackingEvent &&
          runtimeType == other.runtimeType &&
          status == other.status &&
          occurredAt == other.occurredAt &&
          location == other.location;

  @override
  int get hashCode => status.hashCode ^ occurredAt.hashCode ^ location.hashCode;
}
