part of 'representative_dashboard_cubit.dart';

abstract class RepresentativeDashboardState extends Equatable {
  const RepresentativeDashboardState();

  @override
  List<Object?> get props => [];
}

class RepresentativeDashboardInitial extends RepresentativeDashboardState {}

class RepresentativeDashboardLoading extends RepresentativeDashboardState {}

class RepresentativeDashboardLoaded extends RepresentativeDashboardState {
  final List<Commission> commissions;
  final List<CustomerAssignment> assignments;

  const RepresentativeDashboardLoaded({
    required this.commissions,
    required this.assignments,
  });

  @override
  List<Object?> get props => [commissions, assignments];
}

class RepresentativeDashboardFailure extends RepresentativeDashboardState {
  final String message;
  const RepresentativeDashboardFailure(this.message);

  @override
  List<Object?> get props => [message];
}
