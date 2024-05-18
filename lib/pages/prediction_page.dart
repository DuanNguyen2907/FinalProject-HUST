import 'package:app_project/domain/symptom.dart';
import 'package:app_project/services/predictionService.dart';
import 'package:app_project/services/symptomService.dart';
import 'package:flutter/material.dart';

class SymptomPage extends StatefulWidget {
  @override
  _SymptomPageState createState() => _SymptomPageState();
}

class _SymptomPageState extends State<SymptomPage> {
  final SymptomService symptomService = SymptomService();
  final Set<Symptom> _selectedSymptoms = {};
  final List<String> symptomsSelected = []; // Use a Set for selected symptoms

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Symptom Page'),
      ),
      body: FutureBuilder<List<Symptom>>(
        future: symptomService.getAllSymptoms(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildLoadingIndicator();
          } else if (snapshot.hasError) {
            return _buildErrorIndicator(snapshot.error);
          } else {
            return _buildSymptomList(snapshot.data ?? []);
          }
        },
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Center(child: CircularProgressIndicator());
  }

  Widget _buildErrorIndicator(Object? error) {
    return Center(
      child: Text('Error loading symptoms: ${error ?? 'Unknown error'}'),
    );
  }

  Widget _buildSymptomList(List<Symptom> symptoms) {
    final groupedSymptoms = _groupSymptomsByCategory(symptoms);
    PredictionService predictionService = PredictionService();

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: groupedSymptoms.length,
            itemBuilder: (context, index) {
              final className = groupedSymptoms.keys.elementAt(index);
              final classSymptoms = groupedSymptoms[className] ?? [];

              return _buildExpansionTile(className, classSymptoms);
            },
          ),
        ),
        ElevatedButton(
          onPressed: () async {
            // Handle the selected symptoms (e.g., save to database)
            print('Selected symptoms: $symptomsSelected');
            final result = await predictionService.sendData(symptomsSelected);
            _showResultPopup(context, result);
          },
          child: Text('Save Selected Symptoms'),
        ),
      ],
    );
  }

  void _showResultPopup(BuildContext context, String result) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Prediction Result'),
          content: Text(result),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildExpansionTile(String className, List<Symptom> classSymptoms) {
    return StatefulBuilder(
      builder: (context, setState) {
        return ExpansionTile(
          title: Text(className),
          children: classSymptoms.map((symptom) {
            return CheckboxListTile(
              title: Text(symptom.vietnameseName),
              subtitle: Text(symptom.description),
              value: symptomsSelected.contains(symptom.englishName),
              onChanged: (value) {
                if (value != null) {
                  if (value) {
                    _selectedSymptoms.add(symptom);
                    symptomsSelected.add(symptom.englishName);
                  } else {
                    _selectedSymptoms.remove(symptom);
                    symptomsSelected.remove(symptom.englishName);
                  }
                  setState(
                      () {}); // Only rebuilds the part of the widget tree inside the StatefulBuilder
                }
              },
            );
          }).toList(),
        );
      },
    );
  }

  Map<String, List<Symptom>> _groupSymptomsByCategory(List<Symptom> symptoms) {
    final groupedSymptoms = <String, List<Symptom>>{};

    for (final symptom in symptoms) {
      groupedSymptoms.putIfAbsent(symptom.category, () => []).add(symptom);
    }

    return groupedSymptoms;
  }
}
