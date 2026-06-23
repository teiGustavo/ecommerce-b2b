import 'package:drift/drift.dart';
import 'package:ecommerce_b2b/modules/order_flow/quote/domain/enums/quote_status.dart';
import 'package:ecommerce_b2b/modules/order_flow/quote/domain/quote.dart';
import 'package:ecommerce_b2b/modules/order_flow/quote/domain/quote_item.dart';
import 'package:ecommerce_b2b/modules/order_flow/quote/domain/repositories/quote_repository.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/common/ids/product_id.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/common/ids/quote_id.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/finance/value_objects/money.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/finance/value_objects/quantity.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/finance/enums/currency.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/infrastructure/database/app_database.dart';

class DriftQuoteRepository implements QuoteRepository {
  final AppDatabase _db;

  DriftQuoteRepository(this._db);

  @override
  Future<void> save(Quote quote) async {
    await _db.transaction(() async {
      await _db.into(_db.quotesTable).insertOnConflictUpdate(
        QuotesTableCompanion.insert(
          id: quote.id.value,
          companyId: Value(quote.companyId),
          representativeId: Value(quote.representativeId),
          status: quote.status.name,
          createdAt: DateTime.now(), // Simplified
        ),
      );

      // Delete old items and re-insert
      await (_db.delete(_db.quoteItemsTable)
            ..where((t) => t.quoteId.equals(quote.id.value)))
          .go();

      for (final item in quote.items) {
        await _db.into(_db.quoteItemsTable).insert(
          QuoteItemsTableCompanion.insert(
            quoteId: quote.id.value,
            productId: item.productId.value,
            quantity: item.quantity.value,
            unitPrice: item.unitPrice.amount,
            currency: item.unitPrice.currency.code,
          ),
        );
      }
    });
  }

  @override
  Future<Quote?> getById(QuoteId id) async {
    final row = await (_db.select(_db.quotesTable)
          ..where((t) => t.id.equals(id.value)))
        .getSingleOrNull();

    if (row == null) return null;

    final itemRows = await (_db.select(_db.quoteItemsTable)
          ..where((t) => t.quoteId.equals(id.value)))
        .get();

    return _mapToDomain(row, itemRows);
  }

  @override
  Future<List<Quote>> getAll() async {
    final rows = await _db.select(_db.quotesTable).get();
    final List<Quote> quotes = [];
    for (final row in rows) {
      final itemRows = await (_db.select(_db.quoteItemsTable)
            ..where((t) => t.quoteId.equals(row.id)))
          .get();
      quotes.add(_mapToDomain(row, itemRows));
    }
    return quotes;
  }

  @override
  Future<List<Quote>> findByRepresentativeId(String representativeId) async {
    final rows = await (_db.select(_db.quotesTable)
          ..where((t) => t.representativeId.equals(representativeId)))
        .get();
    final List<Quote> quotes = [];
    for (final row in rows) {
      final itemRows = await (_db.select(_db.quoteItemsTable)
            ..where((t) => t.quoteId.equals(row.id)))
          .get();
      quotes.add(_mapToDomain(row, itemRows));
    }
    return quotes;
  }

  Quote _mapToDomain(QuoteRow row, List<QuoteItemRow> itemRows) {
    return Quote(
      id: QuoteId(row.id),
      companyId: row.companyId,
      representativeId: row.representativeId,
      status: QuoteStatus.values.firstWhere((e) => e.name == row.status),
      items: itemRows.map((i) => QuoteItem(
        productId: ProductId(i.productId),
        quantity: Quantity.create(i.quantity).getOrThrow(),
        unitPrice: Money.create(
          i.unitPrice,
          currency: Currency.values.firstWhere((c) => c.code == i.currency),
        ).getOrThrow(),
      )).toList(),
    );
  }
}
