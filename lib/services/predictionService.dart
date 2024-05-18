import 'dart:convert';
import 'package:http/http.dart' as http;

class PredictionService {
  Future<String> sendData(List<String> symptoms) async {
    var url = Uri.parse('http://10.0.2.2:5000/api/predictions');
    String result = '';

    try {
      // Encode symptoms as a JSON string
      var requestBody = jsonEncode({"symptoms": symptoms});

      var response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: requestBody,
      );

      if (response.statusCode == 201) {
        // Parse response body as JSON
        var responseBody = jsonDecode(response.body);
        print("Your disease is: ${responseBody['vietnamese_name']}");
        result = responseBody['vietnamese_name'];
      } else {
        print('Failed to send data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print("Error sending data: $e");
      // Consider logging the error or throwing a custom exception
    }

    return result;
  }
}
