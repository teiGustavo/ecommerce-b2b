import 'package:ecommerce_b2b/modules/shared_kernel/base/base_aggregate_root.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/ids/representative_id.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/value_objects/email_address.dart';
import 'package:ecommerce_b2b/modules/shared_kernel/value_objects/percentage.dart';
import 'package:ecommerce_b2b/modules/sales_team/domain/aggregates/sales_representative/commission.dart';
import 'package:ecommerce_b2b/modules/sales_team/domain/aggregates/sales_representative/customer_assignment.dart';
import 'package:ecommerce_b2b/modules/sales_team/domain/aggregates/sales_representative/sales_hierarchy_link.dart';

class SalesRepresentative extends AggregateRoot<RepresentativeId> {
  final String fullName;
  final EmailAddress email;
  final Percentage commissionRate;

  final List<CustomerAssignment> _assignments;
  final List<Commission> _commissions;
  SalesHierarchyLink? _supervisorLink;
  final List<SalesHierarchyLink> _subordinateLinks;

  SalesRepresentative({
    required RepresentativeId id,
    required this.fullName,
    required this.email,
    required this.commissionRate,
    List<CustomerAssignment>? assignments,
    List<Commission>? commissions,
    SalesHierarchyLink? supervisorLink,
    List<SalesHierarchyLink>? subordinateLinks,
  })  : _assignments = assignments ?? [],
        _commissions = commissions ?? [],
        _supervisorLink = supervisorLink,
        _subordinateLinks = subordinateLinks ?? [],
        super(id);

  List<CustomerAssignment> get assignments => List.unmodifiable(_assignments);
  List<Commission> get commissions => List.unmodifiable(_commissions);
  SalesHierarchyLink? get supervisorLink => _supervisorLink;
  List<SalesHierarchyLink> get subordinateLinks =>
      List.unmodifiable(_subordinateLinks);

  void assignCustomer(CustomerAssignment assignment) {
    if (!_assignments.contains(assignment)) {
      _assignments.add(assignment);
    }
  }

  void addCommission(Commission commission) {
    _commissions.add(commission);
  }

  void setSupervisor(RepresentativeId supervisorId) {
    _supervisorLink = SalesHierarchyLink(
      supervisorId: supervisorId,
      subordinateId: id,
    );
  }

  void addSubordinate(RepresentativeId subordinateId) {
    _subordinateLinks.add(SalesHierarchyLink(
      supervisorId: id,
      subordinateId: subordinateId,
    ));
  }
}
