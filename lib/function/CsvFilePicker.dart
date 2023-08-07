import 'dart:io';
import 'package:file_picker/file_picker.dart';

class CsvFilePicker {
  Future<List<FileSystemEntity>> pickCsvFiles() async {
    String? directoryPath = await FilePicker.platform.getDirectoryPath();

    if (directoryPath != null) {
      final dir = Directory(directoryPath);
      List<FileSystemEntity> files = dir.listSync();
      List<FileSystemEntity> csvFiles = files.where((file) => file.path.endsWith('.csv')).toList();

      if (csvFiles.isEmpty) {
        throw Exception('No csv files in the selected folder');
      }


      return csvFiles;
    } else {
      throw Exception('No folder selected');
    }
  }
}


