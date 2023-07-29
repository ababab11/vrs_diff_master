import 'dart:io';
import 'dart:convert';
import 'package:csv/csv.dart';

class FileColumnCounter {
  static Future<int> countColumnsInFirstFile(List<FileSystemEntity> csvFiles) async {
    if (csvFiles.isEmpty) {
      throw Exception('No files provided.');
    }

    final firstFile = csvFiles[0];
    final input = File(firstFile.path).openRead();
    final fields = await input.transform(utf8.decoder).transform(CsvToListConverter()).first;
    int vaccineRecordIndex = 0;


    vaccineRecordIndex = (fields.length - 1) ~/ 8;


    return vaccineRecordIndex;
  }
}


//static