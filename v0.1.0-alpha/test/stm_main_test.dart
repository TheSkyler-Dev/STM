//testing
import 'dart:io';
import 'package:test/test.dart';
import 'testm.dart';

void main(){
  group('Json Parsing', (){
    test('should parse JSON file correctly', () async{
      final directory = Directory.current;
      print('Current directory: $directory');
      final jsonData = await parseJsonFile('v0.1.0-alpha/test/ext_data/workers.json');
      expect(jsonData, isNotNull);
      expect(jsonData, isA<List<dynamic>>());
      expect(jsonData.length, greaterThan(0));
    });

    test('should throw an exception for invalid JSON file', () async{
      final directory = Directory.current;
      print('Current directory: $directory');
      expect(() => parseJsonFile('v0.1.0-alpha/test/ext_data/invalid.json'), throwsException);
    });
  });

  group('Storage Unit Mapping', (){
    test('should map storage units to workers correctly', () async {
      final jsonData = await parseJsonFile('v0.1.0-alpha/test/ext_data/workers.json');
      final workers = jsonData;
      final storageUnitMap = <int, List<int>>{};
      
      for (var worker in workers){
        int workerId = worker['worker'];
        List<dynamic> storageUnits = worker['storage_units'];
        for (var unit in storageUnits){
          if (!storageUnitMap.containsKey(unit)){
            storageUnitMap[unit] = [];
          }
          storageUnitMap[unit]!.add(workerId);
        }
      }
      expect(storageUnitMap, isNotEmpty);
      expect(storageUnitMap.keys, containsAll([1, 2, 3, 4, 5, 6, 7, 8, 9, 10]));
    });
    test('should handle empty workers list', (){
      final workers = [];
      final storageUnitMap = <int, List<int>>{};

      for (var worker in workers){
        int workerId = worker['worker'];
        List<dynamic> storageUnits = worker['storage_units'];
        for (var unit in storageUnits){
          if (!storageUnitMap.containsKey(unit)){
            storageUnitMap[unit] = [];
          }
          storageUnitMap[unit]!.add(workerId);
        }
      }

      expect(storageUnitMap, isEmpty);
    });
  });

  group('LED Distribution', (){
    test('should distribute LEDs correctly for even number of workers', (){
      final assignedWorkers = [1, 2, 3, 4, 5, 6];
      final maxWorkersPerUnit = 6;
      final ledsPerWorker = maxWorkersPerUnit ~/ assignedWorkers.length;
      final extraLeds = maxWorkersPerUnit % assignedWorkers.length;

      expect(ledsPerWorker, equals(1));
      expect(extraLeds, equals(0));
    });

    test('should distribute LEDs correctly for odd number of workers', (){
      final assignedWorkers = [1, 2, 3, 4, 5];
      final maxWorkersPerUnit = 6;
      final ledsPerWorker = maxWorkersPerUnit ~/ assignedWorkers.length;
      final extraLeds = maxWorkersPerUnit % assignedWorkers.length;

      expect(ledsPerWorker, equals(1));
      expect(extraLeds, equals(1));
    });

    test('should handle zero workers', (){
      final assignedWorkers = [];
      final maxWorkersPerUnit = 6;
      final ledsPerWorker = maxWorkersPerUnit ~/ (assignedWorkers.length == 0 ? 1 : assignedWorkers.length);
      final extraLeds = maxWorkersPerUnit % (assignedWorkers.length == 0 ? 1 : assignedWorkers.length);

      expect(ledsPerWorker, equals(6));
      expect(extraLeds, equals(0));
    });
  });

  group('Worker Colors', (){
    test('should assign unique colors to each worker', (){
      final workers = [
        {'worker': 1},
        {'worker': 2},
        {'worker': 3},
        {'worker': 4},
        {'worker': 5},
        {'worker': 6},
        {'worker': 7},
        {'worker': 8},
        {'worker': 9},
        {'worker': 10}
      ];
      final ledColors = ['R', 'G', 'B', 'Y', 'M', 'C', 'P', 'W', 'O', 'K'];
      final workerColors = <int, String>{};

      for (int i = 0; i < workers.length; i++){
        final workerId = workers[i]['worker'];
        if (workerId != null) {
          workerColors[workerId] = ledColors[i % ledColors.length];
        }
      }

      expect(workerColors.values.toSet().length, equals(10));
    });

    test('should assign consistent colors to each worker', (){
      final workers = [
        {'worker': 1},
        {'worker': 2},
        {'worker': 3},
        {'worker': 4},
        {'worker': 5},
        {'worker': 6},
        {'worker': 7},
        {'worker': 8},
        {'worker': 9},
        {'worker': 10}
      ];
      final ledColors = ['R', 'G', 'B', 'Y', 'M', 'C', 'P', 'W', 'O', 'K'];
      final workerColors = <int, String>{};

      for (int i = 0; i < workers.length; i++){
        final workerId = workers[i]['worker'];
        if (workerId != null) {
          workerColors[workerId] = ledColors[i % ledColors.length];
        }
      }

      final expectedColors = {
        1: 'R',
        2: 'G',
        3: 'B',
        4: 'Y',
        5: 'M',
        6: 'C',
        7: 'P',
        8: 'W',
        9: 'O',
        10: 'K'
      };

      expect(workerColors, equals(expectedColors));
    });

    test('should handle empty workers list', (){
      final workers = [];
      final ledColors = ['R', 'G', 'B', 'Y', 'M', 'C', 'P', 'W', 'O', 'K'];
      final workerColors = <int, String>{};

      for (int i = 0; i < workers.length; i++){
        workerColors[workers[i]['worker']] = ledColors[i % ledColors.length];
      }

      expect(workerColors, isEmpty);
    });
  });
}