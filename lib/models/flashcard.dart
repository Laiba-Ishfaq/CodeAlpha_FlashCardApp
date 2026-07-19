class Flashcard {
  final String id;
  final String question;
  final String answer;
  final bool favorite;
  final int editCount;
  final String? updatedAt; // ISO8601 string

  Flashcard({
    required this.id,
    required this.question,
    required this.answer,
    this.favorite = false,
    this.editCount = 0,
    this.updatedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question': question,
      'answer': answer,
      'favorite': favorite,
      'editCount': editCount,
      'updatedAt': updatedAt,
    };
  }

  factory Flashcard.fromJson(Map<String, dynamic> json) {
    return Flashcard(
      id: json['id'] as String,
      question: json['question'] as String,
      answer: json['answer'] as String,
      favorite: json['favorite'] == true,
      editCount: (json['editCount'] is int)
          ? json['editCount'] as int
          : int.tryParse('${json['editCount']}') ?? 0,
      updatedAt: json['updatedAt'] as String?,
    );
  }

  Flashcard copyWith({
    String? id,
    String? question,
    String? answer,
    bool? favorite,
    int? editCount,
    String? updatedAt,
  }) {
    return Flashcard(
      id: id ?? this.id,
      question: question ?? this.question,
      answer: answer ?? this.answer,
      favorite: favorite ?? this.favorite,
      editCount: editCount ?? this.editCount,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
