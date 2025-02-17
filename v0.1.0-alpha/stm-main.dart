//STM: Storage Task MAnager (c) 2025 TheSkyler-Dev, developed under MIT license

import 'dart:convert'; // For JSON parsing
import 'dart:io'; // For file operations
//import 'package:flutter/material.dart';

void main() async {
  //print('STM: Storage Task Manager CLI');
  //print('=============================');

  // Call the function to read and parse the JSON file
  List<dynamic> workers = [];
  final jsonData = await parseJsonFile('ext_data/workers.json');
  try {
    workers = jsonData;
  } catch (e){
    throw Exception('Failed to load JSON file: $e');
  }

  print('\nWorkers and their assigned storage units');
  for (int i = 0; i < workers.length; i++){
    print('Worker ${workers[i]['worker']}: ${workers[i]['storage_units']}');
  }

  print('\nGraphical Representation:');
  displayStorageUnits(workers);
}

// Function to read and parse the JSON file asynchronously
Future<dynamic> parseJsonFile(String filePath) async {
  try {
    final file = File(filePath);
    final contents = await file.readAsString();
    final jsonData = jsonDecode(contents);
    return jsonData;
  } catch (e) {
    throw Exception('Failed to read or parse the JSON file: $e');
  }
}

// Function to display storage units with LEDs
void displayStorageUnits(List<dynamic> workers) {
  const int maxWorkersPerUnit = 6;
  const List<String> ledColors = ['R', 'G', 'B', 'Y', 'M', 'C', 'P', 'W', 'O', 'K' ]; // Representing colors with letters

  // Create a map to store the storage units and their assigned workers
  Map<int, List<int>> storageUnitMap = {};

  //Create a map to assign fixed colors to workers
  Map<int, String> workerColors = {};
  for (int i = 0; i < workers.length; i++){
    workerColors[workers[i]['worker']] = ledColors[i % ledColors.length];
  }

  for (var worker in workers) {
    int workerId = worker['worker'];
    List<dynamic> storageUnits = worker['storage_units'];

    for (var unit in storageUnits) {
      if (!storageUnitMap.containsKey(unit)) {
        storageUnitMap[unit] = [];
      }
      storageUnitMap[unit]!.add(workerId);
    }

  }

  // Sort the storage units sequentially
  var sortedUnits = storageUnitMap.keys.toList()..sort();

  // Display the storage units with LEDs
  for (var unit in sortedUnits) {
    List<int> assignedWorkers = storageUnitMap[unit]!;
    print('Storage Unit $unit:');
    int numWorkers = assignedWorkers.length;
    int ledsPerWorker = maxWorkersPerUnit ~/ numWorkers;
    int extraLeds = maxWorkersPerUnit % numWorkers;

    int ledIndex = 1;
    for (int j = 0; j < maxWorkersPerUnit; j++) {
      int ledsForThisWorker = ledsPerWorker + (j < extraLeds ? 1 : 0);
      for (int k = 0; k < ledsForThisWorker; k++){
        if (j < assignedWorkers.length){
          print('LED $ledIndex: ${workerColors[assignedWorkers[j]]} - Worker ${assignedWorkers[j]}');
          ledIndex++;
        }
      }
    }

    print('');
  }
}