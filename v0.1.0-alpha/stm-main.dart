//STM: Storage Task MAnager (c) 2025 TheSkyler-Dev, developed under MIT license

import 'dart:convert'; // For JSON parsing
import 'dart:io'; // For file operations

void main() async {
  print('STM: Storage Task Manager CLI');
  print('=============================');


  // Call the function to read and parse the JSON file
  List<dynamic> storageUnits = [];
  final jsonData = await parseJsonFile('ext_data/workers.json');
  try {
    storageUnits = jsonData['storage_units'];
  } catch (e){
    throw Exception('Failed to load JSON file: $e');
  }

  while (true){
    print('\nStorage Units:');
    for (int i = 0; i < storageUnits.length; i++){
      print('${i + 1}. Storage Unit ${i +1}: ${storageUnits[i]}');
    }

    print('\nGraphical Representation:');
    displayStorageUnits(storageUnits);

    print('\nOptions:');
    print('1. Edit a storage unit');
    print('2. Save and exit');
    print('3. Exit without saving');
    stdout.write('Choose and option: ');
    String? choice = stdin.readLineSync();

    switch(choice){
      case '1':
      stdout.write('Enter the storage unit number to edit: ');
      String? unitNumberStr = stdin.readLineSync();
      int? unitNumber = int.tryParse(unitNumberStr ?? '');
      if (unitNumber != null && unitNumber > 0 && unitNumber <= storageUnits.length) {
        stdout.write('Enter the new assignment for Storage Unit $unitNumber: ');
        String? newAssignment = stdin.readLineSync();
        if (newAssignment != null) {
          storageUnits[unitNumber - 1] = newAssignment;
        } else {
          print('Invalid assignment.');
        }
      } else {
        print('Invalid storage unit number.');
      }
      break;

      case '2':
      jsonData['storage_units'] = storageUnits;
      await saveJsonFile('ext_data/workers.json', jsonData);
      print('Changes saved.');
      break;

      case '3':
      break;

      default:
      print('Invalid option.');
    }
  }
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

//Function to save the JSON file
Future<void> saveJsonFile(String filePath, Map<String, dynamic> jsonData) async {
  try {
    final file = File(filePath);
    final contents = jsonEncode(jsonData);
    await file.writeAsString(contents);
  } catch (e){
    throw Exception('Failed to save the JSON file: $e');
  }
}

//Function to display storage units with LEDs
void displayStorageUnits(List<dynamic> storageUnits){
  const int maxWorkersPerUnit = 6;
  const List<String> ledColors = ['R', 'G', 'B', 'Y', 'M', 'C']; //representing colors with letters

  for (int i = 0; i < storageUnits.length; i++){
    List<String> workers = storageUnits[i].split(',').map((e) => e.trim()).toList();
    print('Storage Unit ${i + 1}:');
    for (int j = 0; j < maxWorkersPerUnit; j++){
      if (j < workers.length){
        print('LED ${j +1}: ${ledColors[j % ledColors.length]} - ${workers[j]}');
      } else {
        print('LED ${j + 1}: Off');
      }
    }
    print('');
  }
}