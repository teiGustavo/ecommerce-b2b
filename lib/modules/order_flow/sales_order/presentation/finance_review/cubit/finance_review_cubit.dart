import 'package:ecommerce_b2b/modules/order_flow/sales_order/application/get_pending_finance_reviews/get_pending_finance_reviews_use_case.dart';
import 'package:ecommerce_b2b/modules/order_flow/sales_order/application/process_finance_review/process_finance_review_use_case.dart';
import 'package:ecommerce_b2b/modules/order_flow/sales_order/domain/finance_review.dart';
import 'package:ecommerce_b2b/modules/order_flow/sales_order/domain/sales_order.dart';
import 'package:ecommerce_b2b/modules/order_flow/sales_order/domain/enums/finance_decision.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'finance_review_state.dart';

class FinanceReviewCubit extends Cubit<FinanceReviewState> {
  final GetPendingFinanceReviewsUseCase _getPendingReviews;
  final ProcessFinanceReviewUseCase _processReview;

  FinanceReviewCubit({
    required this._getPendingReviews,
    required this._processReview,
  })  : super(FinanceReviewInitial());

  Future<void> loadPendingOrders() async {
    emit(FinanceReviewLoading());
    try {
      final orders = await _getPendingReviews.execute();
      emit(FinanceReviewLoaded(orders));
    } catch (e) {
      emit(FinanceReviewFailure(e.toString()));
    }
  }

  Future<void> approveOrder(SalesOrder order, String reason) async {
    try {
      final review = FinanceReview(
        decision: FinanceDecision.approved,
        reviewerId: 'finance-user-1', // Em um cenário real, viria da sessão.
        reviewedAt: DateTime.now(),
        justification: reason,
      );
      
      // Mock de warehouses para o use case.
      _processReview.execute(order: order, review: review, warehouses: []);
      
      await loadPendingOrders();
    } catch (e) {
      emit(FinanceReviewFailure(e.toString()));
    }
  }

  Future<void> rejectOrder(SalesOrder order, String reason) async {
    try {
      final review = FinanceReview(
        decision: FinanceDecision.rejected,
        reviewerId: 'finance-user-1',
        reviewedAt: DateTime.now(),
        justification: reason,
      );
      
      _processReview.execute(order: order, review: review, warehouses: []);
      
      await loadPendingOrders();
    } catch (e) {
      emit(FinanceReviewFailure(e.toString()));
    }
  }
}
