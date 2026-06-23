import 'package:drift/drift.dart';
import 'package:ecommerce_b2b/modules/catalog/price_table/domain/enums/price_scope_type.dart';
import 'package:ecommerce_b2b/modules/catalog/price_table/domain/price_rule.dart';
import 'package:ecommerce_b2b/modules/catalog/price_table/domain/price_table.dart';
import 'package:ecommerce_b2b/modules/catalog/price_table/domain/repositories/price_table_repository.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/address/enums/state.dart' as address_state;
import 'package:ecommerce_b2b/modules/shared_kernel/domain/common/ids/price_table_id.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/common/ids/product_id.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/common/ids/product_variant_id.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/finance/value_objects/money.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/finance/value_objects/quantity.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/infrastructure/database/app_database.dart';

class DriftPriceTableRepository implements PriceTableRepository {
  final AppDatabase _db;

  DriftPriceTableRepository(this._db);

  @override
  Future<void> save(PriceTable priceTable) async {
    await _db.transaction(() async {
      await _db.into(_db.priceTables).insertOnConflictUpdate(
        PriceTablesCompanion.insert(
          id: priceTable.id.value,
          name: priceTable.name,
          scopeType: priceTable.scopeType.name,
        ),
      );

      await (_db.delete(_db.priceRules)
            ..where((t) => t.priceTableId.equals(priceTable.id.value)))
          .go();

      for (final rule in priceTable.rules) {
        await _db.into(_db.priceRules).insert(
          PriceRulesCompanion.insert(
            priceTableId: priceTable.id.value,
            productId: rule.productId.value,
            variantId: Value(rule.variantId?.value),
            minQuantity: rule.minQuantity.value,
            maxQuantity: rule.maxQuantity.value,
            stateCode: Value(rule.state?.code),
            unitPrice: rule.unitPrice.amount,
          ),
        );
      }
    });
  }

  @override
  Future<PriceTable?> findById(PriceTableId id) async {
    final row = await (_db.select(_db.priceTables)
          ..where((t) => t.id.equals(id.value)))
        .getSingleOrNull();

    if (row == null) return null;

    final ruleRows = await (_db.select(_db.priceRules)
          ..where((t) => t.priceTableId.equals(id.value)))
        .get();

    return _mapToDomain(row, ruleRows);
  }

  @override
  Future<List<PriceTable>> findAll() async {
    final rows = await _db.select(_db.priceTables).get();
    final List<PriceTable> tables = [];

    for (final row in rows) {
      final ruleRows = await (_db.select(_db.priceRules)
            ..where((t) => t.priceTableId.equals(row.id)))
        .get();
      tables.add(_mapToDomain(row, ruleRows));
    }

    return tables;
  }

  @override
  Future<void> delete(PriceTableId id) async {
    await _db.transaction(() async {
      await (_db.delete(_db.priceRules)
            ..where((t) => t.priceTableId.equals(id.value)))
          .go();
      await (_db.delete(_db.priceTables)
            ..where((t) => t.id.equals(id.value)))
          .go();
    });
  }

  PriceTable _mapToDomain(PriceTableRow row, List<PriceRuleRow> ruleRows) {
    return PriceTable(
      id: PriceTableId(row.id),
      name: row.name,
      scopeType: PriceScopeType.values.firstWhere((e) => e.name == row.scopeType),
      rules: ruleRows.map((r) => PriceRule(
        productId: ProductId(r.productId),
        variantId: r.variantId != null ? ProductVariantId(r.variantId!) : null,
        minQuantity: Quantity.create(r.minQuantity).getOrThrow(),
        maxQuantity: Quantity.create(r.maxQuantity).getOrThrow(),
        state: r.stateCode != null ? address_state.State.fromString(r.stateCode!).getOrNull() : null,
        unitPrice: Money.create(r.unitPrice).getOrThrow(),
      )).toList(),
    );
  }
}
