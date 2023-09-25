// all providers should initialized here..

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wsac/bloc/faq/faq_bloc.dart';
import 'package:wsac/bloc/other_cars_by_user/other_cars_bloc.dart';

import '../bloc/application_config/application_config_bloc.dart';
import '../bloc/authentication/authentication_bloc.dart';
import '../bloc/avatar/avatar_bloc.dart';
import '../bloc/car_details/car_details_bloc.dart';
import '../bloc/car_valuation/valuation_check_bloc.dart';
import '../bloc/chat/chat_bloc.dart';
import '../bloc/delete_questionnaire/delete_questionnaire_bloc.dart';
import '../bloc/get_car_system_config/get_system_config_bloc.dart';
import '../bloc/history/history_bloc.dart';
import '../bloc/liked_cars/liked_car_bloc.dart';
import '../bloc/list_unlist/list_unlist_bloc_bloc.dart';
import '../bloc/my_cars/my_cars_bloc.dart';
import '../bloc/my_matches_data/my_matches_bloc.dart';
import '../bloc/need_finance/need_finance_bloc.dart';
import '../bloc/payment/payment_bloc.dart';
import '../bloc/postcode/postcode_bloc.dart';
import '../bloc/report_issue/report_issue_bloc.dart';
import '../bloc/subscription/subscription_bloc.dart';
import '../bloc/user/user_bloc.dart';
import '../bloc/view_cars/view_cars_bloc.dart';

final List<BlocProvider> providers = [
  BlocProvider<AuthenticationBloc>(
    create: (BuildContext context) => AuthenticationBloc(),
  ),
  BlocProvider<ApplicationConfigBloc>(
    create: (BuildContext context) => ApplicationConfigBloc(),
  ),
  BlocProvider<ChatBloc>(
    create: (BuildContext context) => ChatBloc(),
  ),
  BlocProvider<UserBloc>(
    create: (BuildContext context) => UserBloc(),
  ),
  BlocProvider<CarDetailsBloc>(
    create: (BuildContext context) => CarDetailsBloc(),
  ),
  BlocProvider<MyCarsBloc>(
    create: (BuildContext context) => MyCarsBloc(),
  ),
  BlocProvider<LikedCarsBloc>(
    create: (BuildContext context) => LikedCarsBloc(),
  ),
  BlocProvider<ViewCarsBloc>(
    create: (BuildContext context) => ViewCarsBloc(),
  ),
  BlocProvider<AvatarBloc>(
    create: (BuildContext context) => AvatarBloc(),
  ),
  BlocProvider<PostCodeDetailsBloc>(
    create: (BuildContext context) => PostCodeDetailsBloc(),
  ),
  BlocProvider<ValuationCheckBloc>(
    create: (BuildContext context) => ValuationCheckBloc(),
  ),
  BlocProvider<SubscriptionBloc>(
    create: (BuildContext context) => SubscriptionBloc(),
  ),
  BlocProvider<PaymentBloc>(
    create: (BuildContext context) => PaymentBloc(),
  ),
  BlocProvider<ReportIssueBloc>(
    create: (BuildContext context) => ReportIssueBloc(),
  ),
  BlocProvider<NeedFinanceBloc>(
    create: (BuildContext context) => NeedFinanceBloc(),
  ),
  BlocProvider<FaqBloc>(
    create: (BuildContext context) => FaqBloc(),
  ),
  BlocProvider<MyMatchesBloc>(
    create: (BuildContext context) => MyMatchesBloc(),
  ),
  BlocProvider<HistoryBloc>(
    create: (BuildContext context) => HistoryBloc(),
  ),
  BlocProvider<DeleteQuestionnaireBloc>(
    create: (BuildContext context) => DeleteQuestionnaireBloc(),
  ),
  BlocProvider<CarSystemConfigBloc>(
    create: (BuildContext context) => CarSystemConfigBloc(),
  ),
  BlocProvider<ListUnlistBlocBloc>(
    create: (BuildContext context) => ListUnlistBlocBloc(),
  ),
  BlocProvider<OtherCarsBloc>(
    create: (BuildContext context) => OtherCarsBloc(),
  ),
];
