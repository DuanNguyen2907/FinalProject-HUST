import 'package:app_project/domain/symptom.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SymptomService {
  void sendDataToFirebase(Symptom symptom) {
    FirebaseFirestore.instance.collection('symptoms').add(symptom.toJson());
  }

  Future<List<Symptom>> getAllSymptoms() async {
    final symptomsRef = FirebaseFirestore.instance.collection('symptoms');
    final symptomsSnapshot = await symptomsRef.get();
    List<Symptom> symtoms = [];

    symptomsSnapshot.docs.forEach((doc) {
      Symptom symptom = Symptom(
          id: doc["id"],
          englishName: doc["english_name"],
          vietnameseName: doc["vietnamese_name"],
          description: doc["desc"],
          category: doc["class"]);
      symtoms.add(symptom);
    });

    return symtoms;
  }
}
