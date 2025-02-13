//STM: Storage Task MAnager (c) 2025 TheSkyler-Dev, developed under MIT license

import 'dart:convert'; // For JSON parsing
import 'dart:io'; // For file operations

void main() async {
  print('STM: Storage Task Manager CLI');
  print('=============================');


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
  const List<String> ledColors = ['R', 'G', 'B', 'Y', 'M', 'C']; // Representing colors with letters

  // Create a map to store the storage units and their assigned workers
  Map<int, List<int>> storageUnitMap = {};

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

  // Display the storage units with LEDs
  for (var unit in storageUnitMap.keys) {
    List<int> assignedWorkers = storageUnitMap[unit]!;
    print('Storage Unit $unit:');
    for (int j = 0; j < maxWorkersPerUnit; j++) {
      if (j < assignedWorkers.length) {
        print('LED ${j + 1}: ${ledColors[j % ledColors.length]} - Worker ${assignedWorkers[j]}');
      } else {
        print('LED ${j + 1}: Off');
      }
    }
    print('');
  }
}