import 'package:equatable/equatable.dart';
import 'country_model.dart';

/// Represents a single quiz question
class QuestionModel extends Equatable {
  final CountryModel correctAnswer;
  final List<CountryModel> options; // All 4 options including correct answer
  final int questionNumber;

  const QuestionModel({
    required this.correctAnswer,
    required this.options,
    required this.questionNumber,
  });

  @override
  List<Object?> get props => [correctAnswer, options, questionNumber];
}
