import 'dart:io';
//スタティックだからそのまま使える
class FileWriter {
  static Future<void> writeArrayToFile(List<String> array, String path, String filename) async {
    final file = File('$path/$filename');

    // Write the file.
    final sink = file.openWrite();
    for (var element in array) {
      sink.write('$element\n');
    }

    // Be sure to close the IOSink when you're done to free system resources.
    await sink.close();
  }
}
