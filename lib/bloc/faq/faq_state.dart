part of 'faq_bloc.dart';

abstract class FaqState extends Equatable {
  const FaqState();

  @override
  List<Object> get props => [];
}

class ContactUsInitial extends FaqState {}

class GetfaqQuestionsState extends FaqState {
  final ProviderStatus faqDataStatus;
  final List<FaqModel> faqQuestionsList;

  const GetfaqQuestionsState({
    required this.faqDataStatus,
    this.faqQuestionsList = const [],
  });
  @override
  List<Object> get props => [faqDataStatus];
}

class SendEmailContactUsState extends FaqState {
  final ProviderStatus sendEmailContactUsFetchStatus;
  final SendEmailResponseModel? sendEmailContactUsResponse;
  final String? errorMessage;
  const SendEmailContactUsState({
    required this.sendEmailContactUsFetchStatus,
    this.sendEmailContactUsResponse,
    this.errorMessage,
  });

  @override
  List<Object> get props => [sendEmailContactUsFetchStatus];
}
