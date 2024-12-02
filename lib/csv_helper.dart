import 'dart:io';
import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';

Future<void> exportToCsv(List<List<dynamic>> data, String filename) async {
  final directory = await getApplicationDocumentsDirectory();
  final path = '${directory.path}/$filename.csv';
  final file = File(path);
  String csvData = const ListToCsvConverter().convert(data);
  await file.writeAsString(csvData);
  print('CSV exported to $path');
}