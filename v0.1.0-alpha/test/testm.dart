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
  Map<int, List<int>> storageUnitMap = mapStorageUnits(workers);
  Map<int, String> workerColors = assignWorkerColors(workers, ['R', 'G', 'B', 'Y', 'M', 'C', 'P', 'W', 'O', 'K']);
  displayStorageUnits(storageUnitMap, workerColors);
}

// Function to read and parse the JSON file asynchronously
Future<List<dynamic>> parseJsonFile(String filePath) async {
  try {
    final file = File(filePath);
    final contents = await file.readAsString();
    final jsonData = jsonDecode(contents);
    return jsonData;
  } catch (e) {
    throw Exception('Failed to read or parse the JSON file: $e');
  }
}

Map<int, List<int>> mapStorageUnits(List<dynamic> workers) {
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

  return storageUnitMap;
}

Map<int, String> assignWorkerColors(List<dynamic> workers, List<String> ledColors) {
  Map<int, String> workerColors = {};
  for (int i = 0; i < workers.length; i++) {
    workerColors[workers[i]['worker']] = ledColors[i % ledColors.length];
  }
  return workerColors;
}

void displayStorageUnits(Map<int, List<int>> storageUnitMap, Map<int, String> workerColors) {
  const int maxWorkersPerUnit = 6;

  var sortedUnits = storageUnitMap.keys.toList()..sort();

  for (var unit in sortedUnits) {
    List<int> assignedWorkers = storageUnitMap[unit]!;
    print('Storage Unit $unit:');
    int numWorkers = assignedWorkers.length;
    int ledsPerWorker = maxWorkersPerUnit ~/ numWorkers;
    int extraLeds = maxWorkersPerUnit % numWorkers;

    int ledIndex = 1;
    for (int j = 0; j < numWorkers; j++) {
      int ledsForThisWorker = ledsPerWorker + (j < extraLeds ? 1 : 0);
      for (int k = 0; k < ledsForThisWorker; k++) {
        print('LED $ledIndex: ${workerColors[assignedWorkers[j]]} - Worker ${assignedWorkers[j]}');
        ledIndex++;
      }
    }
    print('');
  }
}