class FeedbackAnswerModel {
  String? questionId;
  String? question;
  String? answer;
  String? ansType;
  String? type;
  String? feedbackAnswer;
  List<String>? answerChoice;

  FeedbackAnswerModel({
    required this.questionId,
    required this.question,
    this.answer,
    required this.ansType,
    required this.type,
    this.feedbackAnswer,
    required this.answerChoice,
  });

  FeedbackAnswerModel.fromJson(Map<String, dynamic> json) {
    questionId = json['questionId'] as String?;
    question = json['question'] as String?;
    ansType = json['ansType'] as String?;
    type = json['type'] as String?;
    answer = json['answer'] as String?;
    feedbackAnswer = json['feedbackAnswer'] as String?;
    if (json['answerChoice'] != null) {
      answerChoice = [];
      for (final item in json['answerChoice'] as List) {
        answerChoice!.add("$item");
      }
    }
  }

  Map<String, dynamic> toJson() => {
        'questionId': questionId,
        'question': question,
        'ansType': ansType,
        'yesOrNoAnswer': answer,
        'multiAnswer': answerChoice,
        'textAnswer': feedbackAnswer,
      };
}
