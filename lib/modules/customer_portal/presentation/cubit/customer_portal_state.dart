part of 'customer_portal_cubit.dart';

abstract class CustomerPortalState extends Equatable {
  const CustomerPortalState();

  @override
  List<Object?> get props => [];
}

class CustomerPortalInitial extends CustomerPortalState {}

class CustomerPortalLoading extends CustomerPortalState {}

class CustomerPortalLoaded extends CustomerPortalState {
  final List<SalesOrder> orders;
  final List<ReturnRequest> returnRequests;
  final BoletoCopy? activeBoleto;
  final String? successMessage;

  const CustomerPortalLoaded({
    required this.orders,
    required this.returnRequests,
    this.activeBoleto,
    this.successMessage,
  });

  CustomerPortalLoaded copyWith({
    List<SalesOrder>? orders,
    List<ReturnRequest>? returnRequests,
    BoletoCopy? activeBoleto,
    bool clearActiveBoleto = false,
    String? successMessage,
    bool clearSuccessMessage = false,
  }) {
    return CustomerPortalLoaded(
      orders: orders ?? this.orders,
      returnRequests: returnRequests ?? this.returnRequests,
      activeBoleto: clearActiveBoleto ? null : (activeBoleto ?? this.activeBoleto),
      successMessage: clearSuccessMessage ? null : (successMessage ?? this.successMessage),
    );
  }

  @override
  List<Object?> get props => [orders, returnRequests, activeBoleto, successMessage];
}

class CustomerPortalFailure extends CustomerPortalState {
  final String message;

  const CustomerPortalFailure(this.message);

  @override
  List<Object?> get props => [message];
}
