class Flashcard {
  final String id;
  final String question;
  final String answer;

  Flashcard({required this.id, required this.question, required this.answer});

  Map<String, dynamic> toJson() {
    return {'id': id, 'question': question, 'answer': answer};
  }

  factory Flashcard.fromJson(Map<String, dynamic> json) {
    return Flashcard(
      id: json['id'] as String,
      question: json['question'] as String,
      answer: json['answer'] as String,
    );
  }

  Flashcard copyWith({String? id, String? question, String? answer}) {
    return Flashcard(
      id: id ?? this.id,
      question: question ?? this.question,
      answer: answer ?? this.answer,
    );
  }
}
