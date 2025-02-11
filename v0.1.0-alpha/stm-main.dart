//STM: Storage Task MAnager (c) 2025 TheSkyler-Dev, developed under MIT license

import 'dart:convert'; // For JSON parsing
import 'dart:io'; // For file operations

void main() {
  // Call the function to read and parse the JSON file
  parseJsonFile('ext_data/workers.json').then((jsonData) {
    print(jsonData); // Print the parsed JSON data
  }).catchError((error) {
    print('Error: $error'); // Print any errors that occur
  });
}

// Function to read and parse the JSON file asynchronously
Future<Map<String, dynamic>> parseJsonFile(String filePath) async {
  try {
    final file = File(filePath);
    final contents = await file.readAsString();
    final jsonData = jsonDecode(contents);
    return jsonData;
  } catch (e) {
    throw Exception('Failed to read or parse the JSON file: $e');
  }
}