part of 'report_issue_bloc.dart';

abstract class ReportIssueEvent extends Equatable {
  const ReportIssueEvent();

  @override
  List<Object> get props => [];
}

class PostReportIssueEvent extends ReportIssueEvent {
  final Map<String, dynamic> reportData;
  const PostReportIssueEvent({
    required this.reportData,
  });
}
