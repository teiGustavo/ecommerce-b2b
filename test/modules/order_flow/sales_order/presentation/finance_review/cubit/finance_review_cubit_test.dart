import 'package:ecommerce_b2b/modules/order_flow/domain/enums/credit_status.dart';
import 'package:ecommerce_b2b/modules/order_flow/domain/enums/order_status.dart';
import 'package:ecommerce_b2b/modules/order_flow/sales_order/application/get_pending_finance_reviews/get_pending_finance_reviews_use_case.dart';
import 'package:ecommerce_b2b/modules/order_flow/sales_order/application/process_finance_review/process_finance_review_use_case.dart';
import 'package:ecommerce_b2b/modules/order_flow/sales_order/domain/sales_order.dart';
import 'package:ecommerce_b2b/modules/order_flow/sales_order/domain/finance_review.dart';
import 'package:ecommerce_b2b/modules/order_flow/sales_order/presentation/finance_review/cubit/finance_review_cubit.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/common/ids/order_id.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetPendingFinanceReviewsUseCase extends Mock implements GetPendingFinanceReviewsUseCase {}
class MockProcessFinanceReviewUseCase extends Mock implements ProcessFinanceReviewUseCase {}

class SalesOrderFake extends Fake implements SalesOrder {}
class FinanceReviewFake extends Fake implements FinanceReview {}

void main() {
  setUpAll(() {
    registerFallbackValue(SalesOrderFake());
    registerFallbackValue(FinanceReviewFake());
  });

  group('FinanceReviewCubit', () {
    late MockGetPendingFinanceReviewsUseCase getPendingReviews;
    late MockProcessFinanceReviewUseCase processReview;
    late FinanceReviewCubit cubit;

    setUp(() {
      getPendingReviews = MockGetPendingFinanceReviewsUseCase();
      processReview = MockProcessFinanceReviewUseCase();
      cubit = FinanceReviewCubit(
        getPendingReviews: getPendingReviews,
        processReview: processReview,
      );
    });

    tearDown(() {
      cubit.close();
    });

    test('initial state should be FinanceReviewInitial', () {
      expect(cubit.state, isA<FinanceReviewInitial>());
    });

    test('loadPendingOrders should emit Loading and then Loaded with orders', () async {
      final order = SalesOrder(
        id: const OrderId('o1'),
        status: OrderStatus.pendingFinanceApproval,
        creditStatus: CreditStatus.pending,
        items: [],
      );

      when(() => getPendingReviews.execute()).thenAnswer((_) async => [order]);

      final states = <FinanceReviewState>[];
      cubit.stream.listen(states.add);

      await cubit.loadPendingOrders();
      await Future.delayed(Duration.zero);

      expect(states, [
        isA<FinanceReviewLoading>(),
        isA<FinanceReviewLoaded>(),
      ]);

      final loaded = states[1] as FinanceReviewLoaded;
      expect(loaded.pendingOrders, [order]);
    });

    test('loadPendingOrders should emit Failure when an exception is thrown', () async {
      when(() => getPendingReviews.execute()).thenThrow(Exception('DB error'));

      final states = <FinanceReviewState>[];
      cubit.stream.listen(states.add);

      await cubit.loadPendingOrders();
      await Future.delayed(Duration.zero);

      expect(states, [
        isA<FinanceReviewLoading>(),
        isA<FinanceReviewFailure>(),
      ]);

      final failure = states[1] as FinanceReviewFailure;
      expect(failure.message, contains('DB error'));
    });

    test('approveOrder should process review and reload pending orders', () async {
      final order = SalesOrder(
        id: const OrderId('o1'),
        status: OrderStatus.pendingFinanceApproval,
        creditStatus: CreditStatus.pending,
        items: [],
      );

      when(() => processReview.execute(
        order: any(named: 'order'),
        review: any(named: 'review'),
        warehouses: any(named: 'warehouses'),
      )).thenReturn(null);

      when(() => getPendingReviews.execute()).thenAnswer((_) async => []);

      await cubit.approveOrder(order, 'Approved because risk is low');

      verify(() => processReview.execute(
        order: order,
        review: any(named: 'review'),
        warehouses: [],
      )).called(1);

      verify(() => getPendingReviews.execute()).called(1);
    });

    test('rejectOrder should process review and reload pending orders', () async {
      final order = SalesOrder(
        id: const OrderId('o1'),
        status: OrderStatus.pendingFinanceApproval,
        creditStatus: CreditStatus.pending,
        items: [],
      );

      when(() => processReview.execute(
        order: any(named: 'order'),
        review: any(named: 'review'),
        warehouses: any(named: 'warehouses'),
      )).thenReturn(null);

      when(() => getPendingReviews.execute()).thenAnswer((_) async => []);

      await cubit.rejectOrder(order, 'Credit score too low');

      verify(() => processReview.execute(
        order: order,
        review: any(named: 'review'),
        warehouses: [],
      )).called(1);

      verify(() => getPendingReviews.execute()).called(1);
    });
  });
}
