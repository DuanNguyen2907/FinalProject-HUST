import 'package:app_project/domain/symptom.dart';
import 'package:app_project/services/predictionService.dart';
import 'package:app_project/services/symptomService.dart';
import 'package:flutter/material.dart';

class SymptomPage extends StatefulWidget {
  const SymptomPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SymptomPredictionPageState createState() => _SymptomPredictionPageState();
}

class _SymptomPredictionPageState extends State<SymptomPage> {
  PredictionService predictionService = PredictionService();
  final SymptomService symptomService = SymptomService();
  List<Symptom>? symptoms;
  String searchQuery = '';
  List<String> selectedSymptoms = [];
  List<String> symptomsSelected = [];

  @override
  void initState() {
    super.initState();
    _fetchSymptoms();
  }

  Future<void> _fetchSymptoms() async {
    symptoms = await symptomService.getAllSymptoms();
    setState(() {});
  }

  void _onSymptomTap(Symptom symptom) {
    if (!selectedSymptoms.contains(symptom.vietnameseName)) {
      selectedSymptoms.add(symptom.vietnameseName);
      searchQuery = '';
    }
    if (!symptomsSelected.contains(symptom.englishName)) {
      symptomsSelected.add(symptom.englishName);
      searchQuery = '';
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dự đoán bệnh trong'),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8.0),
            child: Wrap(
              children: selectedSymptoms.map((symptom) {
                return GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    setState(() {
                      _deleteSymtoms(symptom);
                      print(selectedSymptoms);
                    });
                  },
                  child: Chip(
                    visualDensity: VisualDensity.compact,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 4, vertical: 2), // reduced padding
                    label: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(symptom),
                        const Icon(Icons.close, size: 12),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          Visibility(
            visible: symptomsSelected.isNotEmpty,
            child: ElevatedButton(
              onPressed: () async {
                // Handle the selected symptoms (e.g., save to database)
                print(symptomsSelected);
                final result =
                    await predictionService.sendData(symptomsSelected);
                // ignore: use_build_context_synchronously
                _showResultPopup(context, result);
              },
              child: const Text('Save Selected Symptoms'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (query) {
                setState(() {
                  searchQuery = query;
                });
              },
              decoration: const InputDecoration(
                hintText: 'Nhập tên triệu chứng...',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: symptoms == null ? 0 : symptoms?.length,
              itemBuilder: (context, index) {
                final symptom = symptoms?[index];
                if (symptom!.vietnameseName
                        .toLowerCase()
                        .contains(searchQuery.toLowerCase()) &&
                    !selectedSymptoms.contains(symptom.vietnameseName)) {
                  return ListTile(
                    leading: Text('${symptom.id}'), // ID column
                    title: Text(
                        '${symptom.vietnameseName} - ${symptom.description}'), // Vietnamese name and description column
                    subtitle: Text(
                        '${symptom.category} - ${symptom.englishName}'), // Class and English name column
                    onTap: () {
                      _onSymptomTap(symptom);
                    },
                  );
                } else {
                  return Container();
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showResultPopup(BuildContext context, String result) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Prediction Result'),
          content: Text(result),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _deleteSymtoms(String symptomString) {
    selectedSymptoms.remove(symptomString);
    Symptom? foundSymptom = symptoms
        ?.firstWhere((symptom) => symptom.vietnameseName == symptomString);
    symptomsSelected.remove(foundSymptom?.englishName);
  }
}
