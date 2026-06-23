import 'package:ecommerce_b2b/modules/catalog/price_table/domain/price_table.dart';
import 'package:ecommerce_b2b/modules/catalog/price_table/domain/repositories/price_table_repository.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/functional/result.dart';

class SavePriceTableUseCase {
  final PriceTableRepository _priceTableRepository;

  SavePriceTableUseCase(this._priceTableRepository);

  Future<Result<void, Exception>> execute(PriceTable priceTable) async {
    try {
      await _priceTableRepository.save(priceTable);
      return Success(null);
    } catch (e) {
      return Failure(Exception(e.toString()));
    }
  }
}
