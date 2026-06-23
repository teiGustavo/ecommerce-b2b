import 'package:ecommerce_b2b/modules/identity_access/domain/user_session.dart';
import 'package:ecommerce_b2b/modules/sales_team/sales_representative/application/get_commissions/get_representative_commissions_use_case.dart';
import 'package:ecommerce_b2b/modules/sales_team/sales_representative/application/get_customers/get_customer_portfolio_use_case.dart';
import 'package:ecommerce_b2b/modules/sales_team/sales_representative/domain/commission.dart';
import 'package:ecommerce_b2b/modules/sales_team/sales_representative/domain/customer_assignment.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/domain/common/ids/representative_id.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'representative_dashboard_state.dart';

class RepresentativeDashboardCubit extends Cubit<RepresentativeDashboardState> {
  final GetRepresentativeCommissionsUseCase _getCommissionsUseCase;
  final GetCustomerPortfolioUseCase _getCustomerPortfolioUseCase;

  RepresentativeDashboardCubit({
    required this._getCommissionsUseCase,
    required this._getCustomerPortfolioUseCase,
  })  : super(RepresentativeDashboardInitial());

  Future<void> loadDashboard(UserSession session) async {
    emit(RepresentativeDashboardLoading());
    
    final repId = RepresentativeId(session.userId.value);
    
    final commissionsResult = await _getCommissionsUseCase.execute(repId, session);
    final portfolioResult = await _getCustomerPortfolioUseCase.execute(repId, session);

    if (commissionsResult.isSuccess && portfolioResult.isSuccess) {
      emit(RepresentativeDashboardLoaded(
        commissions: commissionsResult.getOrThrow(),
        assignments: portfolioResult.getOrThrow(),
      ));
    } else {
      final errorMessage = commissionsResult.isFailure 
        ? commissionsResult.getFailureOrThrow().message 
        : portfolioResult.getFailureOrThrow().message;
      emit(RepresentativeDashboardFailure(errorMessage));
    }
  }
}
