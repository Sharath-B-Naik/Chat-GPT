class FavouriteModel {
  final String question;
  final String answer;
  final String? createdAt;

  FavouriteModel({
    required this.question,
    required this.answer,
    this.createdAt,
  });

  factory FavouriteModel.fromMap(Map<String, dynamic> map) {
    return FavouriteModel(
      question: map['question'] ?? '',
      answer: map['answer'] ?? '',
      createdAt: map['createdAt'] ?? '',
    );
  }

  Map<String, String> toMap() {
    return {
      "question": question,
      "answer": answer,
      "createdAt": "${DateTime.now()}"
    };
  }
}
