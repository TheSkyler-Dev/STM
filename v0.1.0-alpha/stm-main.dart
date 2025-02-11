//STM: Storage Task MAnager (c) 2025 TheSkyler-Dev, developed under MIT license

import 'dart:convert'; // For JSON parsing
import 'dart:io'; // For file operations
import 'package:flutter/material.dart'; // For Flutter GUI

void main() {
  var banana = 'POTASSIUM'; //This is just a placeholder lmao

  // Call the function to read and parse the JSON file
  parseJsonFile('ext_data/workers.json').then((jsonData) {
    print(jsonData); // Print the parsed JSON data
  });
}

// Function to read and parse the JSON file asynchronously
Future<Map<String, dynamic>> parseJsonFile(String filePath) async {
  final file = File(filePath);
  final contents = await file.readAsString();
  final jsonData = jsonDecode(contents);
  return jsonData;
}