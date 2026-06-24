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
  final List<Quote> recentQuotes;
  final List<SalesRepresentative> subordinates;
  final RepresentativeId selectedRepId;
  final String selectedRepName;

  const RepresentativeDashboardLoaded({
    required this.commissions,
    required this.assignments,
    required this.recentQuotes,
    required this.subordinates,
    required this.selectedRepId,
    required this.selectedRepName,
  });

  @override
  List<Object?> get props => [
        commissions,
        assignments,
        recentQuotes,
        subordinates,
        selectedRepId,
        selectedRepName,
      ];
}

class RepresentativeDashboardFailure extends RepresentativeDashboardState {
  final String message;
  const RepresentativeDashboardFailure(this.message);

  @override
  List<Object?> get props => [message];
}
