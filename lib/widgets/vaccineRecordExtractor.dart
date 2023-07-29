import 'dart:io';

import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:vrs_diff_master/function/writeArrayToFile.dart';

import '../function/countColumnsInFirstFile.dart';
import '../function/getDate.dart';

class VaccineRecordExtractor extends StatefulWidget {
  final List<FileSystemEntity> csvFilesA;
  final List<FileSystemEntity> csvFilesB;
  VaccineRecordExtractor({required this.csvFilesA,required this.csvFilesB});
  @override
  State<VaccineRecordExtractor> createState() => _VaccineRecordExtractorState();
}


class _VaccineRecordExtractorState extends State<VaccineRecordExtractor> {
  double valueOfProgress = 0.0;
  bool processingComplete = false;  // フラグを追加
  String date = "";  //日
  Directory currentDirectory = Directory.current;
  int denominator = 0;  //分母
  int numerator = 0; //分子
  Map<String, int> hash = {};
  List<String> outputArray = []; //書き出し用配列
  String filename = "";
  int count = 0 ;//抽出対象件数
  int vaccineRecordIndexOld = 0;//何回目まで記録されているか（古い方のデータ）
  int vaccineRecordIndexNew = 0;//何回目まで記録されているか（新しい方のデータ）
  int timeGap = 0;
  //Map resultMapA = {String,String} as Map; //Aを処理した結果　101みたいな
  Map<String, String> resultMapA = {}; // 正しいハッシュテーブルの宣言
  String directoryPath = "";


  void initState() {
    super.initState();
    firstDo();
  }
  Future<void> firstDo() async {
    valueOfProgress = 0.0;
    date = GetDate.getCurrentDateTime();
    filename = date +"【接種記録が削除されている分】.csv";
    denominator = getCsvFilesCount()*1; //分母取得
    directoryPath = currentDirectory.path;
    //まず時期による差分をなくす　,　の数をそろえる
    vaccineRecordIndexOld = await FileColumnCounter.countColumnsInFirstFile(widget.csvFilesA) as int;
    vaccineRecordIndexNew = await FileColumnCounter.countColumnsInFirstFile(widget.csvFilesB) as int;
    resultMapA = await createHashTable(widget.csvFilesA,vaccineRecordIndexOld);
    await HikakuAndWrite(widget.csvFilesB,vaccineRecordIndexOld);

     hash = {}; //初期化
     outputArray = []; //書き出し用配列初期化
     processingComplete = true;  // 処理が終わったらフラグを真にする

  }


  int getCsvFilesCount() {
    return widget.csvFilesA.length + widget.csvFilesB.length ;
  }

  void updateProgress(int denominator, int numerator) {
    setState(() {
      valueOfProgress = denominator > 0 ? numerator / denominator : 0.0;
    });}

  Future<Map<String, String>> createHashTable(List<FileSystemEntity> csvFilesA, int n) async {
    Map<String, String> hashTable = {};

    // 順番にCSVファイルを読み込む
    for (var file in csvFilesA) {
      String csvContent = await File(file.path).readAsString(); // 非同期にファイルを読み込む
      List<List<dynamic>> csvRows = CsvToListConverter().convert(csvContent);

      for (var row in csvRows) {
        if (row.length >= 3) {
          String key = row[0].toString();
          String value = ""; // 値を空の文字列として初期化

          if (n == 1) {
            // 3列目の値を文字列に連結
            value = _parseValue(row[2]);
          } else if (n >= 2) {
            // 3 + (n * 8) 列目までの値を合計して文字列に連結
            String sumValue = "";
            for (int i = 0; i < n; i++) {
              //sumValue += int.parse(_parseValue(row[2 + i * 8]));
              value = _parseValue(row[2 + i * 8]);
              sumValue = sumValue + value;
            }
            value = sumValue.toString();
          }

          // 正しくハッシュテーブルに値を追加
          hashTable[key] = value; // 値はすでにString型なのでそのまま代入
        }
      }
      numerator = numerator + 1;
      updateProgress(denominator, numerator); // 進捗を更新しUIに反映する
    }

    return hashTable;
  }


  String _parseValue(dynamic value) {
    // NULLかどうかを判定し、"1"または"0"を返す
    return (value == "") ? "0" : "1";
  }




  void printHashTable(Map<String, String> hashMap) {
    int count = 0;
    for (var entry in hashMap.entries) {
      print('${entry.key}: ${entry.value}');
      count++;
      if (count >= 10) {
        break; // 10個までの表示に制限
      }
    }
  }



  Future<void> HikakuAndWrite(List<FileSystemEntity> csvFilesB, int n) async {
    String key = "";
    String value = ""; // 値を空の文字列として初期化

    // 順番にCSVファイルを読み込む
    for (var file in csvFilesB) {
      String csvContent = await File(file.path).readAsString();
      List<List<dynamic>> csvRows = CsvToListConverter().convert(csvContent);

      for (var row in csvRows) {
        key = row[0].toString();
        if (row.length >= 3) {
          for (int i = 0; i < n; i++) {
            value = value + _parseValue(row[2 + i * 8]);
          }
          updateCombination(resultMapA, key, value, row.toString());
        }
      }
      numerator = numerator + 1;
      updateProgress(getCsvFilesCount() + 1, numerator);
    }
    await FileWriter.writeArrayToFile(outputArray, directoryPath, filename);
    numerator = numerator + 1;
    updateProgress(getCsvFilesCount() + 1, numerator);
  }



  void updateCombination(Map<String, String> dataMap, String stringA, String stringB, String additionalString) {
    String? valueA = dataMap[stringA];

    if (valueA == null || valueA.length != stringB.length) {
      // 無効な組み合わせの場合は処理を終了
      return;
    }

    bool isExtracted = false;

    for (int i = 0; i < valueA.length; i++) {
      if (valueA[i] == '1' && stringB[i] == '0') {
        isExtracted = true;
        break;
      }
    }

    if (isExtracted) {
      // 抽出対象なら書き込み用配列に追加
      outputArray.add(additionalString);
      count = count +1;

    }
  }




  @override
  Widget build(BuildContext context) {

    if (processingComplete) {
      Future.delayed(Duration.zero, () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Processing Completed'),
              content:  Text(currentDirectory.path+"\\\nに" + filename + "のファイル名で保存しました(対象は"+count.toString()+"件)"),
              actions: <Widget>[
                TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      });}

    return  LinearProgressIndicator(
      value: valueOfProgress,
    );
  }
}


