part of 'finance_review_cubit.dart';

abstract class FinanceReviewState extends Equatable {
  const FinanceReviewState();

  @override
  List<Object?> get props => [];
}

class FinanceReviewInitial extends FinanceReviewState {}

class FinanceReviewLoading extends FinanceReviewState {}

class FinanceReviewLoaded extends FinanceReviewState {
  final List<SalesOrder> pendingOrders;
  const FinanceReviewLoaded(this.pendingOrders);

  @override
  List<Object?> get props => [pendingOrders];
}

class FinanceReviewFailure extends FinanceReviewState {
  final String message;
  const FinanceReviewFailure(this.message);

  @override
  List<Object?> get props => [message];
}
