import 'package:ecommerce_b2b/modules/customer_portal/return_request/domain/repositories/return_request_repository.dart';
import 'package:ecommerce_b2b/modules/customer_portal/return_request/domain/return_request.dart';
import 'package:ecommerce_b2b/modules/customer_portal/return_request/domain/enums/rma_status.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/common/ids/rma_id.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/infrastructure/database/app_database.dart';

class DriftReturnRequestRepository implements ReturnRequestRepository {
  final AppDatabase _db;

  DriftReturnRequestRepository(this._db);

  @override
  Future<void> save(ReturnRequest request) async {
    await _db.into(_db.returnRequests).insertOnConflictUpdate(
      ReturnRequestsCompanion.insert(
        id: request.id.value,
        orderId: request.orderId,
        reason: request.reason,
        status: request.status.name,
        createdAt: DateTime.now(),
      ),
    );
  }

  @override
  Future<ReturnRequest?> getById(RmaId id) async {
    final row = await (_db.select(_db.returnRequests)
          ..where((t) => t.id.equals(id.value)))
        .getSingleOrNull();

    if (row == null) return null;

    return _mapToDomain(row);
  }

  @override
  Future<List<ReturnRequest>> getAll() async {
    final rows = await _db.select(_db.returnRequests).get();
    return rows.map(_mapToDomain).toList();
  }

  ReturnRequest _mapToDomain(ReturnRequestRow row) {
    return ReturnRequest(
      id: RmaId(row.id),
      orderId: row.orderId,
      status: RmaStatus.values.firstWhere((e) => e.name == row.status),
      reason: row.reason,
      items: [], // Simplified for MVP
    );
  }
}
