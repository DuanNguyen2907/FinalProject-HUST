import 'package:cloud_firestore/cloud_firestore.dart';

class Symptom {
  final int id;
  final String englishName;
  final String vietnameseName;
  final String description;
  final String category;

  Symptom({
    required this.id,
    required this.englishName,
    required this.vietnameseName,
    required this.description,
    required this.category,
  });

  factory Symptom.fromJson(Map<String, dynamic> json) {
    return Symptom(
      id: json['id'],
      englishName: json['english_name'],
      vietnameseName: json['vietnamese_name'],
      description: json['desc'],
      category: json['class'],
    );
  }

  factory Symptom.fromDocument(DocumentSnapshot doc) {
    return Symptom(
        id: doc['id'],
        englishName: doc['english_name'],
        vietnameseName: doc['vietnamese_name'],
        description: doc['desc'],
        category: doc['class']);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'english_name': englishName,
      'vietnamese_name': vietnameseName,
      'desc': description,
      'class': category,
    };
  }
}
