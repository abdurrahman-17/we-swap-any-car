part of 'report_issue_bloc.dart';

abstract class ReportIssueState extends Equatable {
  const ReportIssueState();

  @override
  List<Object> get props => [];
}

class ReportIssueInitialState extends ReportIssueState {}

class PostReportIssueState extends ReportIssueState {
  final ProviderStatus reportIssueStatus;
  final ReportIssueResponseModel? reportIssueData;

  const PostReportIssueState({
    required this.reportIssueStatus,
    this.reportIssueData,
  });
  @override
  List<Object> get props => [reportIssueStatus];
}
