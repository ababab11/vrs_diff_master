import 'dart:io';
//テストで作成したもの
class FileSystemEntityMap {
  Map<String, String> entityMap = {};

  Future<void> processEntities(List<FileSystemEntity> entities) async {
    for (var entity in entities) {
      print("Uuu");
      var file = File(entity.path); // Assuming entity is a file
      if (await file.exists()) {
        var lines = await file.readAsLines();
        for (var line in lines) {
          var columns = line.split(',');
          if (columns.isNotEmpty) {
            var key = columns.first;
            var value = columns.skip(1).join(','); //
            entityMap[key] = value;
          }
        }
      }
    }
  }
}