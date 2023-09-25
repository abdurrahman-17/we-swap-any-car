import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../core/locator.dart';
import '../../model/report_issue/report_issue_response_model.dart';
import '../../repository/car_repo.dart';
import '../../utility/enums.dart';

part 'report_issue_event.dart';
part 'report_issue_state.dart';

class ReportIssueBloc extends Bloc<ReportIssueEvent, ReportIssueState> {
  ReportIssueBloc() : super(ReportIssueInitialState()) {
    on<ReportIssueEvent>((event, emit) {
      emit(ReportIssueInitialState());
    });

    // post report issue
    on<PostReportIssueEvent>((event, emit) async {
      emit(const PostReportIssueState(
        reportIssueStatus: ProviderStatus.loading,
      ));

      final result =
          await Locator.instance.get<CarRepo>().reportIssue(event.reportData);

      final PostReportIssueState state = result.fold((fail) {
        return const PostReportIssueState(
          reportIssueStatus: ProviderStatus.error,
        );
      }, (reportIssueResponse) {
        return PostReportIssueState(
          reportIssueStatus: ProviderStatus.success,
          reportIssueData: reportIssueResponse,
        );
      });
      emit(state);
    });
  }
}
