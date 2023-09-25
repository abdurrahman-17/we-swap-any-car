// ignore_for_file: constant_identifier_names

enum ProviderStatus {
  idle,
  loading,
  success,
  error,
}

enum ApiCallType {
  GET,
  POST,
  DELETE,
  PUT,
  PATCH,
}

enum SocialLogin {
  google,
  facebook,
  apple,
  twitter,
  instagram,
  tiktok,
  none,
}

enum UserPurpose {
  buy,
  sell,
  swap,
  browse,
}

enum UserType {
  dealerAdmin,
  dealerSubUser,
  private,
}

enum CarServiceHistoryRecord {
  Partial,
  Full,
  None,
}

enum CarStatus {
  active,
  pending,
  sold,
  disabled,
}

enum CarPostType {
  normal,
  premium,
}

enum CarCreateStatus {
  carWorth,
  additionalInformation,
  hpiAndMot,
  serviceHistory,
  conditionAndDamage,
  uploadPhotos,
  completed,
  //for front end
  stepperScreen,
  summaryScreen,
}

enum UserGender {
  male,
  female,
  ratherNotSay,
}

enum SubscriptionChangeStatus {
  active,
  approved,
  rejected,
  pending,
}

enum UpgradeSubscriptionStatus {
  active,
  approved,
  rejected,
  pending,
}

enum SubscriptionsType {
  subscription,
  payAsYouGo,
  freeTrial,
  unlimited,
}

enum SubscriptionPageName {
  initialPage,
  freeTrailPage,
  carSummary,
  myCar,
  mySubscription,
}

enum OfferType {
  none,
  swap,
  cash,
  swapAndCash,
}

enum OfferStatus {
  waiting,
  accepted,
  rejected,
  negotiated,
  canceled,
}

enum MessageType {
  normal,
  offer,
}

enum CarDeletedBy {
  user,
  admin,
}

enum ProgressStatus {
  completed,
  cancel,
  loading,
  error,
}

enum AttachmentType {
  image,
  video,
  document,
}

enum Status {
  active,
  inactive,
  pending,
}

enum ChatStatus {
  active,
  deleted,
  disappeared,
}

enum AnswerType {
  yesno,
  textbox,
  multichoice,
  yesnoText,
  multichoiceText,
}

enum YesNoAnswer {
  yes,
  no,
}

enum SurveyType {
  deletePost,
  deleteProfile,
  relogin,
}

enum ConditionAndDamageTypes {
  scratch,
  dent,
  paint,
  broken,
  tyre,
  scuffed,
  warningLights,
}

enum QuestionnaireType {
  deleteCar,
  deleteProfile,
  deleteFromCarDetails,
}

enum FilterUserTypes {
  dealer,
  private,
  none,
}

enum TransactionPayBy {
  buyer,
  seller,
}
