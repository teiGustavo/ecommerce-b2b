part of 'company_management_cubit.dart';

abstract class CompanyManagementState extends Equatable {
  const CompanyManagementState();

  @override
  List<Object?> get props => [];
}

class CompanyManagementInitial extends CompanyManagementState {}

class CompanyManagementLoading extends CompanyManagementState {}

class CompanyManagementLoaded extends CompanyManagementState {
  final List<Company> companies;

  const CompanyManagementLoaded({
    required this.companies,
  });

  @override
  List<Object?> get props => [companies];
}

class CompanyManagementFailure extends CompanyManagementState {
  final String message;

  const CompanyManagementFailure(this.message);

  @override
  List<Object?> get props => [message];
}

class CompanyManagementSuccess extends CompanyManagementState {
  final String message;

  const CompanyManagementSuccess(this.message);

  @override
  List<Object?> get props => [message];
}
