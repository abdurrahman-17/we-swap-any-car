import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/locator.dart';
import '../../model/faq/faq_model.dart';
import '../../model/send_email_response_model.dart';
import '../../repository/contact_us_repo.dart';
import '../../utility/enums.dart';

part 'faq_event.dart';
part 'faq_state.dart';

class FaqBloc extends Bloc<FaqEvent, FaqState> {
  FaqBloc() : super(ContactUsInitial()) {
    ///fetch faq questions
    on<GetFaqQuestionsEvent>((event, emit) async {
      emit(const GetfaqQuestionsState(faqDataStatus: ProviderStatus.loading));

      final result =
          await Locator.instance.get<ContactUsRepo>().fetchFaqQuestions();
      final GetfaqQuestionsState state = result.fold((fail) {
        return const GetfaqQuestionsState(
          faqDataStatus: ProviderStatus.error,
        );
      }, (faqQuestions) {
        return GetfaqQuestionsState(
          faqDataStatus: ProviderStatus.success,
          faqQuestionsList: faqQuestions,
        );
      });
      emit(state);
    });
  }
}
